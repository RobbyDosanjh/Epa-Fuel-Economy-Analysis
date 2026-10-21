# Stage 1: Describe fuel economy and explore distributions on the full dataset.

run_exploratory_analysis <- function(vehicles) {
  vars <- c("barrels08", "city08", "highway08", "comb08")
  numeric_summary <- do.call(rbind, lapply(vars, function(var) {
    x <- vehicles[[var]]
    x <- x[is.finite(x)]
    data.frame(
      variable = var,
      n = length(x),
      mean = mean(x),
      median = stats::median(x),
      sd = stats::sd(x),
      min = min(x),
      max = max(x)
    )
  }))
  save_table(numeric_summary, "descriptive_statistics.csv")

  histogram <- ggplot2::ggplot(vehicles, ggplot2::aes(x = comb08)) +
    ggplot2::geom_histogram(binwidth = 3, fill = "#2864B4",
                            color = "white", na.rm = TRUE) +
    ggplot2::labs(
      title = "Distribution of Combined Vehicle Fuel Economy",
      subtitle = "EPA vehicle models (1984-2025; includes alternative-fuel vehicles)",
      x = "Combined fuel economy (MPG-equivalent as recorded)",
      y = "Number of vehicles"
    ) +
    ggplot2::theme_minimal(base_size = 12)
  save_plot(histogram, "01_combined_mpg_distribution.png")

  # Exclude negative / unavailable emissions values for the visualization.
  scatter_data <- dplyr::filter(vehicles, is.finite(comb08),
                                 is.finite(co2TailpipeGpm), co2TailpipeGpm > 0)
  emissions_scatter <- ggplot2::ggplot(
      scatter_data, ggplot2::aes(x = comb08, y = co2TailpipeGpm)
    ) +
    ggplot2::geom_point(alpha = 0.18, size = 0.5, color = "#2864B4") +
    ggplot2::labs(
      title = "Fuel Economy vs. Tailpipe CO2 Emissions",
      subtitle = "Vehicles with a positive reported tailpipe CO2 value",
      x = "Combined fuel economy (MPG)",
      y = "CO2 tailpipe emissions (grams/mile)"
    ) +
    ggplot2::theme_minimal(base_size = 12)
  save_plot(emissions_scatter, "02_mpg_vs_tailpipe_co2.png")

  invisible(numeric_summary)
}
