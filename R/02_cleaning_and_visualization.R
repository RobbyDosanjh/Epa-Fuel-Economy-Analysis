# Stage 2: Create a well-defined sample and compare transmission categories.

prepare_standard_vehicles <- function(vehicles) {
  # The source column may be logical or text depending on read.csv and file version.
  phev_text <- tolower(trimws(as.character(vehicles$phevBlended)))
  filtered <- vehicles[
    !is.na(phev_text) & phev_text == "false" &
      !is.na(vehicles$co2TailpipeGpm) & vehicles$co2TailpipeGpm > 0 &
      !is.na(vehicles$comb08) & vehicles$comb08 > 0,
    , drop = FALSE
  ]

  filtered <- dplyr::mutate(
    filtered,
    transmission = dplyr::case_when(
      startsWith(dplyr::coalesce(trany, ""), "Auto") ~ "Automatic",
      startsWith(dplyr::coalesce(trany, ""), "Man") ~ "Manual",
      TRUE ~ "Other / Unknown"
    ),
    drivetrain = dplyr::case_when(
      drive == "Front-Wheel Drive" ~ "Front-Wheel Drive",
      drive %in% c("All-Wheel Drive", "4-Wheel Drive",
                   "4-Wheel or All-Wheel Drive", "Part-time 4-Wheel Drive") ~
        "All-Wheel Drive",
      drive == "Rear-Wheel Drive" ~ "Rear-Wheel Drive",
      TRUE ~ "Other / Unknown"
    )
  )
  if (nrow(filtered) == 0) stop("No rows remain after standard-fuel filtering.")
  filtered
}

run_transmission_analysis <- function(vehicles) {
  grouped <- vehicles |>
    dplyr::group_by(transmission) |>
    dplyr::summarise(
      vehicle_count = dplyr::n(),
      mean_mpg = mean(comb08, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(percent_of_vehicles = round(100 * vehicle_count /
                                                 sum(vehicle_count), 2))
  save_table(grouped, "transmission_summary.csv")

  chart <- ggplot2::ggplot(
      grouped, ggplot2::aes(x = transmission, y = mean_mpg)
    ) +
    ggplot2::geom_col(fill = "#2864B4", width = 0.68) +
    ggplot2::geom_text(ggplot2::aes(label = sprintf("%.1f", mean_mpg)),
                       vjust = -0.4, size = 4) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.15))) +
    ggplot2::labs(
      title = "Average Combined MPG by Transmission Type",
      subtitle = "Non-plug-in vehicles with positive tailpipe emissions",
      x = "Transmission", y = "Average combined MPG"
    ) +
    ggplot2::theme_minimal(base_size = 12)
  save_plot(chart, "03_mean_mpg_by_transmission.png")

  invisible(grouped)
}
