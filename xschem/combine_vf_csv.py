#!/usr/bin/env python3
"""
Combine multiple voltage/frequency CSV files into one wide CSV.

Input format expected:
    optional first metadata line, e.g. tb_csringosc-paper1.raw
    Voltage,Frequency
    0.55,12345
    ...

Output format:
    Voltage,<input-file-1-stem>,<input-file-2-stem>,...
    0.55,12345,23456,...

The output Voltage column is a fixed grid from 0.55 V to 3.30 V inclusive
in 0.01 V steps by default. Each input file's Frequency data is linearly
interpolated onto that grid, so input Voltage columns do not need to match.
"""

from __future__ import annotations

import argparse
import csv
import math
from pathlib import Path
from typing import Dict, List, Tuple


def read_vf_csv(path: Path) -> Tuple[List[float], List[float]]:
    """Read a CSV containing a Voltage,Frequency table."""
    with path.open("r", newline="") as f:
        rows = list(csv.reader(f))

    header_index = None
    for i, row in enumerate(rows):
        if len(row) >= 2:
            c0 = row[0].strip().lower()
            c1 = row[1].strip().lower()
            if c0 == "voltage" and c1 == "frequency":
                header_index = i
                break

    if header_index is None:
        raise ValueError(f"{path}: could not find a 'Voltage,Frequency' header row")

    points: List[Tuple[float, float]] = []
    for row in rows[header_index + 1 :]:
        if not row or all(not cell.strip() for cell in row):
            continue
        if len(row) < 2:
            raise ValueError(f"{path}: data row has fewer than 2 columns: {row}")
        try:
            voltage = float(row[0].strip())
            frequency = float(row[1].strip())
        except ValueError as exc:
            raise ValueError(f"{path}: could not parse numeric row: {row}") from exc
        if not (math.isfinite(voltage) and math.isfinite(frequency)):
            raise ValueError(f"{path}: non-finite numeric value in row: {row}")
        points.append((voltage, frequency))

    if len(points) < 2:
        raise ValueError(f"{path}: need at least two data points for interpolation")

    # Sort by voltage and merge duplicate voltage samples by averaging frequency.
    points.sort(key=lambda item: item[0])
    merged_voltages: List[float] = []
    merged_frequencies: List[float] = []
    i = 0
    while i < len(points):
        voltage = points[i][0]
        frequencies = [points[i][1]]
        i += 1
        while i < len(points) and points[i][0] == voltage:
            frequencies.append(points[i][1])
            i += 1
        merged_voltages.append(voltage)
        merged_frequencies.append(sum(frequencies) / len(frequencies))

    if len(merged_voltages) < 2:
        raise ValueError(f"{path}: need at least two distinct voltage values for interpolation")

    return merged_voltages, merged_frequencies


def make_voltage_grid(start: float, stop: float, step: float) -> List[float]:
    """Create an inclusive fixed voltage grid, avoiding floating point drift."""
    if step <= 0:
        raise ValueError("Voltage step must be positive")
    count_float = (stop - start) / step
    count = round(count_float)
    if not math.isclose(count_float, count, rel_tol=0.0, abs_tol=1e-9):
        raise ValueError("Voltage range must contain a whole number of steps")
    return [round(start + i * step, 12) for i in range(count + 1)]


def interpolate_series(
    source_v: List[float],
    source_f: List[float],
    target_v: List[float],
    *,
    allow_extrapolate: bool,
) -> List[float]:
    """Linearly interpolate source frequency values onto target voltages."""
    if len(source_v) != len(source_f):
        raise ValueError("source_v and source_f length mismatch")
    if len(source_v) < 2:
        raise ValueError("need at least two source points")

    out: List[float] = []
    j = 0
    n = len(source_v)

    for voltage in target_v:
        if voltage < source_v[0]:
            if not allow_extrapolate:
                raise ValueError(
                    f"target voltage {voltage:g} is below input range starting at {source_v[0]:g}"
                )
            j = 0
        elif voltage > source_v[-1]:
            if not allow_extrapolate:
                raise ValueError(
                    f"target voltage {voltage:g} is above input range ending at {source_v[-1]:g}"
                )
            j = n - 2
        else:
            while j < n - 2 and source_v[j + 1] < voltage:
                j += 1

        v0, v1 = source_v[j], source_v[j + 1]
        f0, f1 = source_f[j], source_f[j + 1]
        t = (voltage - v0) / (v1 - v0)
        out.append(f0 + t * (f1 - f0))

    return out


def format_voltage(voltage: float) -> str:
    """Format voltages as 0.55, 0.56, ..., 3.3."""
    return f"{voltage:.2f}".rstrip("0").rstrip(".")


def format_value(value: float) -> str:
    """Preserve useful precision without writing noisy long floats."""
    return f"{value:.15g}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Combine several Voltage/Frequency CSVs into one wide CSV, "
            "interpolating each input onto a common voltage grid."
        )
    )
    parser.add_argument("inputs", nargs="+", type=Path, help="Input CSV files, e.g. *_vf.csv")
    parser.add_argument("-o", "--out", type=Path, default=Path("combined_vf.csv"), help="Output CSV path")
    parser.add_argument("--v-start", type=float, default=0.55, help="Output voltage grid start; default: 0.55")
    parser.add_argument("--v-stop", type=float, default=3.30, help="Output voltage grid stop; default: 3.30")
    parser.add_argument("--v-step", type=float, default=0.01, help="Output voltage grid step; default: 0.01")
    parser.add_argument(
        "--keep-suffix",
        action="store_true",
        help="Use full filename including .csv as the output column name instead of the filename stem",
    )
    parser.add_argument(
        "--no-extrapolate",
        action="store_true",
        help=(
            "Fail if the fixed voltage grid extends outside an input file's voltage range. "
            "By default, slight end extrapolation is allowed."
        ),
    )
    args = parser.parse_args()

    target_voltages = make_voltage_grid(args.v_start, args.v_stop, args.v_step)
    series: Dict[str, List[float]] = {}

    for path in args.inputs:
        voltages, frequencies = read_vf_csv(path)
        column_name = path.name if args.keep_suffix else path.stem
        if column_name in series:
            raise ValueError(f"Duplicate output column name '{column_name}'")

        series[column_name] = interpolate_series(
            voltages,
            frequencies,
            target_voltages,
            allow_extrapolate=not args.no_extrapolate,
        )

    with args.out.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Voltage", *series.keys()])
        for row_index, voltage in enumerate(target_voltages):
            writer.writerow(
                [
                    format_voltage(voltage),
                    *[format_value(values[row_index]) for values in series.values()],
                ]
            )

    print(
        f"Wrote {args.out} with {len(target_voltages)} voltage rows "
        f"from {format_voltage(target_voltages[0])} to {format_voltage(target_voltages[-1])} "
        f"and {len(series)} data series."
    )


if __name__ == "__main__":
    main()
