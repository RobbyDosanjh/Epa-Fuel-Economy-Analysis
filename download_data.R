# Download the public vehicle dataset from FuelEconomy.gov.
# Usage (from the repository root): Rscript download_data.R

source("R/00_utils.R")
ensure_project_root()
dir.create("data", showWarnings = FALSE, recursive = TRUE)

source_url <- "https://www.fueleconomy.gov/feg/epadata/vehicles.csv"
destination <- file.path("data", "vehicles.csv")

cat("Downloading vehicle dataset from FuelEconomy.gov...\n")
tryCatch(
  utils::download.file(source_url, destination, mode = "wb", quiet = FALSE),
  error = function(e) {
    stop("Download failed. Visit https://www.fueleconomy.gov/feg/download.shtml ",
         "and save vehicles.csv in data/. Details: ", conditionMessage(e))
  }
)

if (!file.exists(destination) || is.na(file.info(destination)$size) ||
    file.info(destination)$size < 1000) {
  stop("Downloaded file is missing or unusually small; check the source URL.")
}

header <- readLines(destination, n = 1L, warn = FALSE)
if (!grepl("comb08", header, fixed = TRUE)) {
  stop("The downloaded file does not look like the expected vehicles.csv.")
}

metadata <- c(
  paste0("Source: ", source_url),
  paste0("Downloaded at (UTC): ", format(Sys.time(), tz = "UTC", usetz = TRUE)),
  paste0("MD5 of downloaded file: ", unname(tools::md5sum(destination))),
  "Scope: scripts analyze model years 1984-2025; current download may contain later years."
)
writeLines(metadata, file.path("data", "download_metadata.txt"))
cat("Saved ", destination, " (", round(file.info(destination)$size / 1e6, 1),
    " MB).\n", sep = "")
