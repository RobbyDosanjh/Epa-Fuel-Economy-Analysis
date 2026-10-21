# Case study: EPA vehicle fuel economy

## Question

How does combined vehicle fuel economy differ across drivetrain and
transmission categories, and how well do simple regression models describe
the observed values?

## Source and scope

A U.S. Department of Energy / EPA FuelEconomy.gov download provided vehicle
attributes for model years 1984-2025. The original academic report was based
on a dataset downloaded in November 2024. The four figures in `figures/` and
the **historical figures below** come from that original analysis. They have
**not** been recomputed using the latest live download.

## Process

1. Inspect the distribution of combined city/highway MPG and its relationship
   with annual petroleum use and tailpipe CO2.
2. Restrict the vehicle sample to non-plug-in hybrids and vehicles with
   positive reported tailpipe CO2 for standard-fuel analyses.
3. Compare average combined MPG across transmission types.
4. Fit an intercept-only baseline, then compare simple drivetrain and annual
   petroleum-consumption regression models.
5. Examine fit statistics and discuss interpretation limits.

## Historical findings from the submitted report

| Item | Reported value |
|---|---:|
| Vehicles in original full dataset | 48,202 |
| Vehicles after standard-fuel filter | 46,957 |
| Combined MPG mean before filtering | 22.08 |
| Baseline predicted MPG after filtering | 20.58 |
| Drivetrain model adjusted R² | 0.249 |
| Petroleum consumption model adjusted R² | 0.813 |
| Drivetrain model residual standard error | 4.74 MPG |
| Petroleum consumption residual standard error | 2.37 MPG |

These values were transcribed from the provided original report. Differences
from running the refactored project can arise because the public dataset is
updated **and** this portfolio version no longer guesses front/rear drive for
ambiguous labels. See methodology below.

## Important interpretation

The high R² for annual petroleum consumption should **not** be described as
strong, independent predictive power: `barrels08` is computed using fuel
economy. In other words, the two measures partly encode the same underlying
information. The strong association is therefore expected, and it would be
misleading to frame the model as explaining the causes of fuel efficiency.

Drivetrain categories are associated with differences in average MPG, but this
is observational data and is not evidence that changing drivetrain alone
would cause the displayed MPG difference. Vehicle size, mass, engine design,
and model year are potential confounding factors.

## Portfolio improvements vs. original coursework

- Scripts use project-relative paths and generate CSV result tables and PNGs.
- Missing or ambiguous drive types (including the source label `2-Wheel Drive`)
  remain `Other / Unknown`, instead of being forced into a front/rear category.
- Regression models are fitted to the **same** subset of vehicles with known
  drivetrain categories and positive estimated petroleum use for comparability.
- The old model coefficients and R² values are **historical references only**;
  fresh output tables should be used to describe new runs.
- `co2TailpipeGpm > 0` means positive CO2 emissions, not zero emissions.

## Possible next iteration

Fit a multiple regression using independently measured characteristics
(e.g., engine displacement, model year, cylinders), perform train/test
validation, and evaluate out-of-sample prediction error.

## Attribution

Data: U.S. Department of Energy and U.S. Environmental Protection Agency,
FuelEconomy.gov, https://www.fueleconomy.gov/feg/download.shtml.
