#!/usr/bin/env python3
"""
Analyse ngspice/LTspice-style .raw transient files without loading all data.

Version: 2026-06-02-overlay-progress

Features:
  * Parses ngspice binary .raw headers and memory-maps numeric data.
  * Plots a spectrogram for one signal vs time, resampling variable-step data
    onto a uniform grid per analysis window.
  * Plots Vin vs detected square-wave frequency using threshold crossings.

Example:
  python ngraw_analyse.py info tb_inverter.raw
  python ngraw_analyse.py spectrogram tb_inverter.raw --signal 'v(y)' --out spec.png \
      --fs 1.2e9 --nperseg 4096 --noverlap 3072 --fmin 2e5 --fmax 5e8
  python ngraw_analyse.py spectrogram tb_inverter.raw --signal 'v(y)' --overlay-signal 'v(vin)' \
      --fs 1.2e9 --nperseg 4096 --noverlap 3072 --fmin 2e5 --fmax 5e8 --out spec_vin.png
  python ngraw_analyse.py vf tb_inverter.raw --xsignal 'v(a)' --ysignal 'v(y)' \
      --threshold 1.65 --out vf.png
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from dataclasses import dataclass
from typing import Iterable, Optional

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import spectrogram


@dataclass
class RawInfo:
    path: str
    title: str
    plotname: str
    flags: str
    nvars: int
    npoints: int
    variables: list[str]
    data_offset: int
    binary: bool


def _read_header(path: str) -> tuple[str, int, bool]:
    """Return decoded header, byte offset of payload, and whether payload is binary."""
    with open(path, "rb") as f:
        buf = b""
        # Headers are normally tiny, but allow up to 16 MiB for safety.
        while len(buf) < 16 * 1024 * 1024:
            chunk = f.read(65536)
            if not chunk:
                break
            buf += chunk
            m = re.search(rb"(?m)^(Binary|Values):\s*\r?\n", buf)
            if m:
                return buf[: m.end()].decode("latin1"), m.end(), (m.group(1) == b"Binary")
    raise ValueError("Could not find Binary: or Values: marker in raw file header")


def read_raw_info(path: str) -> RawInfo:
    header, offset, is_binary = _read_header(path)
    def field(name: str, default: str = "") -> str:
        m = re.search(rf"^{re.escape(name)}:\s*(.*)$", header, re.M)
        return m.group(1).strip() if m else default

    nvars = int(field("No. Variables"))
    npoints = int(field("No. Points"))
    vars_: list[str] = []
    in_vars = False
    for line in header.splitlines():
        if line.strip() == "Variables:":
            in_vars = True
            continue
        if line.strip() in ("Binary:", "Values:"):
            break
        if in_vars:
            # Format: <index> <name> <type>, separated by whitespace/tabs.
            parts = line.strip().split()
            if len(parts) >= 2 and parts[0].isdigit():
                vars_.append(parts[1])
    if len(vars_) != nvars:
        raise ValueError(f"Header says {nvars} variables but parsed {len(vars_)}")
    return RawInfo(path, field("Title"), field("Plotname"), field("Flags"), nvars, npoints, vars_, offset, is_binary)


class RawAccessor:
    """Memory-mapped raw accessor. Binary ngspice data is assumed float64 interleaved by point."""
    def __init__(self, path: str):
        self.info = read_raw_info(path)
        if not self.info.binary:
            raise NotImplementedError(
                "This streaming accessor currently supports Binary: raw files. "
                "For huge files, prefer ngspice binary raw output."
            )
        expected = self.info.npoints * self.info.nvars * 8
        actual = os.path.getsize(path) - self.info.data_offset
        if actual < expected:
            raise ValueError(f"File payload too short: expected {expected}, got {actual}")
        self.mm = np.memmap(
            path,
            mode="r",
            dtype="<f8",          # ngspice binary raw on normal little-endian machines
            offset=self.info.data_offset,
            shape=(self.info.npoints, self.info.nvars),
            order="C",
        )

    def idx(self, name: str) -> int:
        try:
            return self.info.variables.index(name)
        except ValueError:
            raise KeyError(f"Signal {name!r} not found. Available: {self.info.variables}") from None

    def col(self, name: str):
        return self.mm[:, self.idx(name)]


def info_cmd(args):
    r = RawAccessor(args.raw)
    print(f"title:    {r.info.title}")
    print(f"plot:     {r.info.plotname}")
    print(f"flags:    {r.info.flags}")
    print(f"points:   {r.info.npoints}")
    print(f"vars:     {r.info.nvars}")
    print("signals:")
    for v in r.info.variables:
        print(f"  {v}")


def _iter_time_windows(t, y, t0: float, t1: float, win_s: float, hop_s: float):
    """Yield raw slices covering each time window, with searchsorted indexing."""
    start = t0
    n = len(t)
    while start + win_s <= t1:
        stop = start + win_s
        i0 = max(0, int(np.searchsorted(t, start, side="left")) - 1)
        i1 = min(n, int(np.searchsorted(t, stop, side="right")) + 1)
        if i1 - i0 >= 2:
            yield start, stop, np.asarray(t[i0:i1]), np.asarray(y[i0:i1])
        start += hop_s


def spectrogram_cmd(args):
    r = RawAccessor(args.raw)
    t = r.col("time")
    y = r.col(args.signal)

    fs = float(args.fs)
    nperseg = int(args.nperseg)
    noverlap = int(args.noverlap)
    if noverlap >= nperseg:
        raise ValueError("--noverlap must be smaller than --nperseg")
    hop = (nperseg - noverlap) / fs
    win_s = nperseg / fs

    t0 = float(args.t0) if args.t0 is not None else float(t[0])
    t1 = float(args.t1) if args.t1 is not None else float(t[-1])
    if t1 <= t0:
        raise ValueError("t1 must be greater than t0")

    freqs = None
    times = []
    cols = []

    # Progress reporting. We can know the nominal number of windows up front because
    # windows are stepped on a uniform analysis time grid, even when the raw data
    # itself came from a variable-step transient simulation.
    total_windows = max(0, int(np.floor((t1 - t0 - win_s) / hop)) + 1)
    progress_every = max(1, int(args.progress_every))
    last_pct = -1

    # One FFT-like periodogram per window; avoids building a giant uniform-resampled array.
    for window_idx, (start, stop, tw, yw) in enumerate(_iter_time_windows(t, y, t0, t1, win_s, hop), start=1):
        grid = start + np.arange(nperseg) / fs
        yu = np.interp(grid, tw, yw)
        yu = yu - np.mean(yu)
        f, _, sxx = spectrogram(
            yu,
            fs=fs,
            window=args.window,
            nperseg=nperseg,
            noverlap=0,
            detrend=False,
            scaling="density",
            mode="magnitude",
        )
        if freqs is None:
            freqs = f
            mask = (freqs >= args.fmin) & (freqs <= args.fmax)
        cols.append(sxx[:, 0][mask])
        times.append((start + stop) / 2)

        if args.progress and total_windows > 0:
            pct = int(100 * window_idx / total_windows)
            if pct != last_pct and (pct == 100 or window_idx == 1 or window_idx % progress_every == 0):
                print(f"spectrogram: {pct:3d}% ({window_idx}/{total_windows} windows)", file=sys.stderr, flush=True)
                last_pct = pct

    if args.progress and last_pct < 100 and total_windows > 0:
        print(f"spectrogram: 100% ({len(cols)}/{total_windows} windows)", file=sys.stderr, flush=True)

    if not cols:
        raise RuntimeError("No spectrogram windows produced; check t0/t1/fs/nperseg")

    freqs2 = freqs[mask]
    S = np.column_stack(cols)
    S_db = 20 * np.log10(np.maximum(S, np.max(S) * 1e-12))

    times_arr = np.array(times)

    fig, ax = plt.subplots(figsize=(11, 6))
    mesh = ax.pcolormesh(times_arr, freqs2 / 1e6, S_db, shading="auto")
    ax.set_xlabel("Time (s)")
    ax.set_ylabel("Frequency (MHz)")
    ax.set_title(f"Spectrogram: {args.signal}")
    cbar = fig.colorbar(mesh, ax=ax)
    cbar.set_label("Magnitude (dB rel.)")

    if args.overlay_signal:
        ov = r.col(args.overlay_signal)
        # Use the spectrogram time-bin centres for the overlay. This keeps memory
        # usage tiny even for huge .raw files and keeps the overlaid trace aligned
        # with the actual spectrogram columns.
        overlay_values = np.interp(times_arr, t, ov)
        ax2 = ax.twinx()
        ax2.plot(times_arr, overlay_values, linewidth=args.overlay_linewidth, alpha=args.overlay_alpha)
        ylabel = args.overlay_label or args.overlay_signal
        if args.overlay_units:
            ylabel += f" ({args.overlay_units})"
        ax2.set_ylabel(ylabel)
        if args.overlay_ymin is not None or args.overlay_ymax is not None:
            ax2.set_ylim(args.overlay_ymin, args.overlay_ymax)

    fig.tight_layout()
    fig.savefig(args.out, dpi=180)
    print(args.out)


def crossing_times(t: np.ndarray, y: np.ndarray, threshold: float, rising: bool = True) -> np.ndarray:
    """Linearly interpolated threshold crossing times."""
    y0 = y[:-1] - threshold
    y1 = y[1:] - threshold
    if rising:
        idx = np.flatnonzero((y0 < 0) & (y1 >= 0))
    else:
        idx = np.flatnonzero((y0 > 0) & (y1 <= 0))
    # t_cross = t0 + fraction*(t1-t0), fraction = -y0/(y1-y0)
    denom = y1[idx] - y0[idx]
    good = denom != 0
    idx = idx[good]
    frac = -y0[idx] / (y1[idx] - y0[idx])
    return t[idx] + frac * (t[idx + 1] - t[idx])


def vf_cmd(args):
    r = RawAccessor(args.raw)
    t = np.asarray(r.col("time"))        # For edge detection we intentionally materialise selected columns.
    x = np.asarray(r.col(args.xsignal))
    y = np.asarray(r.col(args.ysignal))

    if args.t0 is not None or args.t1 is not None:
        t0 = float(args.t0) if args.t0 is not None else float(t[0])
        t1 = float(args.t1) if args.t1 is not None else float(t[-1])
        sel = (t >= t0) & (t <= t1)
        t, x, y = t[sel], x[sel], y[sel]

    tc = crossing_times(t, y, args.threshold, rising=not args.falling)
    if len(tc) < 2:
        raise RuntimeError("Fewer than two threshold crossings found")
    freq = 1.0 / np.diff(tc)
    t_mid = 0.5 * (tc[:-1] + tc[1:])
    x_mid = np.interp(t_mid, t, x)

    if args.median_bins > 0:
        bins = np.linspace(np.nanmin(x_mid), np.nanmax(x_mid), args.median_bins + 1)
        bx, by = [], []
        for lo, hi in zip(bins[:-1], bins[1:]):
            m = (x_mid >= lo) & (x_mid < hi)
            if np.count_nonzero(m) >= args.min_bin_count:
                bx.append(0.5 * (lo + hi))
                by.append(np.median(freq[m]))
        x_plot, y_plot = np.array(bx), np.array(by)
    else:
        x_plot, y_plot = x_mid, freq

    plt.figure(figsize=(9, 5.5))
    plt.scatter(x_plot, y_plot, s=args.marker_size)
    plt.xlabel(f"{args.xsignal} (V)")
    plt.ylabel(f"Detected frequency of {args.ysignal} (Hz)")
    plt.title(f"{args.ysignal} frequency vs {args.xsignal}")
    if args.logy:
        plt.yscale("log")
    plt.tight_layout()
    plt.savefig(args.out, dpi=180)
    print(args.out)


def main():
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(required=True)

    pi = sub.add_parser("info")
    pi.add_argument("raw")
    pi.set_defaults(func=info_cmd)

    ps = sub.add_parser("spectrogram")
    ps.add_argument("raw")
    ps.add_argument("--signal", required=True)
    ps.add_argument("--out", default="spectrogram.png")
    ps.add_argument("--fs", type=float, required=True, help="Uniform resample rate for FFT; use > 2*fmax, e.g. 1.2e9")
    ps.add_argument("--nperseg", type=int, default=4096)
    ps.add_argument("--noverlap", type=int, default=3072)
    ps.add_argument("--fmin", type=float, default=2e5)
    ps.add_argument("--fmax", type=float, default=5e8)
    ps.add_argument("--t0", type=float)
    ps.add_argument("--t1", type=float)
    ps.add_argument("--window", default="hann")
    ps.add_argument("--progress", action=argparse.BooleanOptionalAction, default=True,
                    help="Print spectrogram progress percentage to stderr; enabled by default")
    ps.add_argument("--progress-every", type=int, default=10,
                    help="Minimum processed-window interval between progress messages")
    ps.add_argument("--overlay-signal",
                    help="Optional signal to overlay as a line over time on a secondary Y axis, e.g. 'v(vin)'")
    ps.add_argument("--overlay-label", help="Optional label for the overlay axis")
    ps.add_argument("--overlay-units", default="V", help="Overlay axis units label; default: V")
    ps.add_argument("--overlay-ymin", type=float, help="Optional overlay Y-axis minimum")
    ps.add_argument("--overlay-ymax", type=float, help="Optional overlay Y-axis maximum")
    ps.add_argument("--overlay-linewidth", type=float, default=1.2)
    ps.add_argument("--overlay-alpha", type=float, default=0.9)
    ps.set_defaults(func=spectrogram_cmd)

    pv = sub.add_parser("vf")
    pv.add_argument("raw")
    pv.add_argument("--xsignal", required=True)
    pv.add_argument("--ysignal", required=True)
    pv.add_argument("--threshold", type=float, default=1.65)
    pv.add_argument("--falling", action="store_true")
    pv.add_argument("--out", default="vf.png")
    pv.add_argument("--t0", type=float)
    pv.add_argument("--t1", type=float)
    pv.add_argument("--median-bins", type=int, default=0, help="Bin X and plot median frequency per bin")
    pv.add_argument("--min-bin-count", type=int, default=3)
    pv.add_argument("--marker-size", type=float, default=6)
    pv.add_argument("--logy", action="store_true")
    pv.set_defaults(func=vf_cmd)

    args = p.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
