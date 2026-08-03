# Experiments

Experiments in this directory are game-selection instruments. They do not
replace mathematical or formal verification.

## Erdős 700(iii) extremal rows

`erdos700_extremal.py` constructs large residual instances from known exact
factorizations, rejects instances that fail the strict component-cap,
high-height-mass, or upper-half gates, and scores candidate rows using exact
truncated Legendre valuations.

It compares uniform rows, midpoint rows, component and base products,
divisor/cofactor rows, adaptive multipliers, and weighted-depth hill climbing.
The retained JSON records which components supplied the winning depth.

Example:

```sh
python experiments/erdos700_extremal.py \
  --output-json runs/extremal-lab/results.json \
  --output-md runs/extremal-lab/report.md
```

The output is diagnostic only. Finite rows cannot prove or disprove the
asymptotic conjecture.
