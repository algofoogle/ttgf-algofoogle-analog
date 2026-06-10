# Xschem stuff

This directory contains Xschem schematics of the VCO, but also other utilities...

## ngra8.py

Post-processes ngspice ".raw" files. For my specific use-cases:

### "vf" mode: Plot frequency vs. input voltage

For 1 or many `var*.raw` files, generate a respective `..._vf.csv` file and `..._vf.png` file:

```bash
python ./ngra8.py vf var*.raw --xsignal 'v(vin)' --ysignal 'v(osc)' --threshold 1.65 --median-bins 200 --out _vf --csv --csv-v-step 1e-2
```

The CSV file is 2 columns: V (10mV steps, typically from 0.55V to 3.3V), and the respective frequency (Hz).

The PNG file is a plot of this.


### "spectrogram" mode

For 1 or many `var*.raw` files, generate a respective `..._spec.png` file that is a spectrogram of the `v(osc)` output:

```bash
python ./ngra8.py spectrogram var*.raw --signal 'v(osc)' --fs 15e8 --nperseg 4096 --noverlap 3072 --fmin 1e5 --fmax 7e8 --overlay-signal 'v(vin)' --out _spec
```

Note that `--fs` should be set to something at least 2&times; fmax: The higher it is, the finer the binning.

## combine_vf_csv.py

Combines columns from multiple CSV files genrated by "[ngra8.py vf](#vf-mode-plot-frequency-vs-input-voltage)" mode into a single CSV file, attempting to match voltage key values by interpolation so that the whole file could be plotted as a simple X/Y scatter plot:

```bash
python3 ./combine_vf_csv.py -o combined.csv var*.csv
```
