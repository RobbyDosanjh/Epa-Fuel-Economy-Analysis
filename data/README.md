# Data source

The project uses the official downloadable **FuelEconomy.gov vehicle database**
from the U.S. Department of Energy and U.S. Environmental Protection Agency:

- Dataset information: https://www.fueleconomy.gov/feg/download.shtml
- Direct CSV download: https://www.fueleconomy.gov/feg/epadata/vehicles.csv

Run `Rscript download_data.R` from the repository root. The script downloads
`vehicles.csv` to this folder and writes the download timestamp and MD5 hash to
`download_metadata.txt`. Both generated files are intentionally ignored by Git.

The analysis includes **model years 1984 through 2025**. The online source is
updated over time, so even with the model-year cutoff, counts and statistical
results may differ from those in the original 2024 dataset snapshot used for
the accompanying historical figures and coursework report.

Key fields: `comb08` (combined MPG), `city08`, `highway08`, `barrels08`
(estimated annual petroleum consumption), `co2TailpipeGpm` (tailpipe CO2
in g/mile), `trany` (transmission), `drive` (drive type), `phevBlended`,
`make`, and `year`.
