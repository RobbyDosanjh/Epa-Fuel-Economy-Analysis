# Run the entire portfolio project.
# From the repository root:
#   Rscript download_data.R
#   Rscript run_analysis.R

source("R/00_utils.R")
ensure_project_root()

packages <- c("dplyr", "ggplot2", "readr")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  stop("Missing packages: ", paste(missing, collapse = ", "),
       ". Install them first with install.packages(c('dplyr','ggplot2','readr')).")
}

source("R/01_exploratory_analysis.R")
source("R/02_cleaning_and_visualization.R")
source("R/03_baseline_model.R")
source("R/04_regression_comparison.R")

create_output_dirs()
vehicles <- read_vehicle_data()
cat("Imported ", nrow(vehicles), " vehicle rows, model years 1984-2025.\n", sep = "")

run_exploratory_analysis(vehicles)
standard_vehicles <- prepare_standard_vehicles(vehicles)
cat("Standard-fuel analysis sample: ", nrow(standard_vehicles), " vehicles.\n", sep = "")
run_transmission_analysis(standard_vehicles)
run_baseline_model(standard_vehicles)
run_regression_comparison(standard_vehicles)

summary_lines <- c(
  paste("Run date (UTC):", format(Sys.time(), tz = "UTC", usetz = TRUE)),
  paste("Original rows (1984-2025):", nrow(vehicles)),
  paste("Non-PHEV, positive tailpipe CO2 rows:", nrow(standard_vehicles)),
  "Results are recomputed from the locally downloaded version of vehicles.csv.",
  "For original coursework snapshot results, see report/PROJECT_SUMMARY.md."
)
writeLines(summary_lines, "outputs/run_summary.txt")
cat("Finished. Inspect outputs/figures/ and outputs/tables/.\n")
