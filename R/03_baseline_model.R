# Stage 3: Fit an intercept-only model as a baseline for MPG predictions.

run_baseline_model <- function(vehicles) {
  baseline <- stats::lm(comb08 ~ 1, data = vehicles)
  actual <- vehicles$comb08
  predicted <- as.numeric(stats::fitted(baseline))
  errors <- actual - predicted

  measures <- data.frame(
    model = "Intercept-only baseline",
    sample_size = length(errors),
    predicted_mpg = unname(stats::coef(baseline)[1]),
    mean_absolute_error = mean(abs(errors)),
    mean_squared_error = mean(errors^2),
    root_mean_squared_error = sqrt(mean(errors^2)),
    sum_absolute_error = sum(abs(errors)),
    sum_squared_error = sum(errors^2)
  )
  save_table(measures, "baseline_metrics.csv")

  plot_data <- data.frame(vehicle_index = seq_along(actual),
                          mpg = actual, predicted_mpg = predicted)
  figure <- ggplot2::ggplot(plot_data, ggplot2::aes(x = vehicle_index, y = mpg)) +
    ggplot2::geom_point(alpha = 0.10, size = 0.5, color = "#2864B4") +
    ggplot2::geom_hline(yintercept = unname(stats::coef(baseline)[1]),
                        color = "#C94B45", linewidth = 0.9) +
    ggplot2::labs(
      title = "Observed MPG vs. an Intercept-Only Baseline",
      subtitle = "Red line is the same predicted mean MPG for every vehicle",
      x = "Vehicle row index", y = "Combined MPG"
    ) +
    ggplot2::theme_minimal(base_size = 12)
  save_plot(figure, "04_baseline_model.png")

  invisible(measures)
}
