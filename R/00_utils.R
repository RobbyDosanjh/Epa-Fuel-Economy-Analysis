# Helpers shared by the four analysis stages.

ensure_project_root <- function() {
  if (!file.exists(file.path("R", "00_utils.R"))) {
    stop("Run scripts from the repository root (epa-fuel-economy-analysis).")
  }
}

create_output_dirs <- function() {
  dir.create("outputs/figures", showWarnings = FALSE, recursive = TRUE)
  dir.create("outputs/tables", showWarnings = FALSE, recursive = TRUE)
}

read_vehicle_data <- function(path = file.path("data", "vehicles.csv")) {
  if (!file.exists(path)) {
    stop("Missing data/vehicles.csv. Run: Rscript download_data.R")
  }

  vehicles <- utils::read.csv(path, stringsAsFactors = FALSE)
  needed <- c("year", "barrels08", "city08", "highway08", "comb08",
              "trany", "drive", "make", "phevBlended", "co2TailpipeGpm")
  absent <- setdiff(needed, names(vehicles))
  if (length(absent) > 0) {
    stop("Missing expected columns: ", paste(absent, collapse = ", "))
  }

  # Match the 1984-2025 model-year period of the original coursework.
  vehicles <- vehicles[!is.na(vehicles$year) &
                       vehicles$year >= 1984 & vehicles$year <= 2025, , drop = FALSE]
  if (nrow(vehicles) == 0) stop("No vehicle records for model years 1984-2025.")
  vehicles
}

save_plot <- function(plot, filename, width = 9, height = 5.5) {
  ggplot2::ggsave(
    filename = file.path("outputs", "figures", filename),
    plot = plot, width = width, height = height,
    units = "in", dpi = 160, bg = "white"
  )
}

save_table <- function(data, filename) {
  readr::write_csv(data, file.path("outputs", "tables", filename))
}
