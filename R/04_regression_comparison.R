# Stage 4: Compare two univariate regression models on the same sample.
# Annual petroleum consumption (barrels08) is derived from fuel economy;
# its strong association is not evidence of a new independent predictor.

run_regression_comparison <- function(vehicles) {
  comparison_data <- vehicles |>
    dplyr::filter(drivetrain != "Other / Unknown",
                  is.finite(barrels08), barrels08 > 0,
                  is.finite(comb08)) |>
    dplyr::mutate(
      drivetrain = factor(drivetrain,
                          levels = c("All-Wheel Drive", "Front-Wheel Drive",
                                     "Rear-Wheel Drive"))
    )
  if (nrow(comparison_data) < 30 ||
      dplyr::n_distinct(comparison_data$drivetrain) < 2) {
    stop("Insufficient known-drivetrain data to compare models.")
  }

  drivetrain_model <- stats::lm(comb08 ~ drivetrain, data = comparison_data)
  barrels_model <- stats::lm(comb08 ~ barrels08, data = comparison_data)

  evaluate <- function(fit, label) {
    summary_fit <- summary(fit)
    residuals <- stats::residuals(fit)
    fstat <- summary_fit$fstatistic
    data.frame(
      model = label,
      sample_size = length(residuals),
      r_squared = unname(summary_fit$r.squared),
      adjusted_r_squared = unname(summary_fit$adj.r.squared),
      residual_standard_error = unname(summary_fit$sigma),
      mean_absolute_error = mean(abs(residuals)),
      root_mean_squared_error = sqrt(mean(residuals^2)),
      residual_sum_of_squares = sum(residuals^2),
      f_statistic = unname(fstat[["value"]]),
      f_df1 = unname(fstat[["numdf"]]),
      f_df2 = unname(fstat[["dendf"]]),
      f_p_value = stats::pf(fstat[["value"]], fstat[["numdf"]],
                            fstat[["dendf"]], lower.tail = FALSE)
    )
  }

  model_metrics <- rbind(
    evaluate(drivetrain_model, "Drivetrain"),
    evaluate(barrels_model, "Annual petroleum consumption")
  )
  save_table(model_metrics, "regression_model_comparison.csv")

  coefficients <- rbind(
    data.frame(model = "Drivetrain",
               term = names(stats::coef(drivetrain_model)),
               estimate = unname(stats::coef(drivetrain_model))),
    data.frame(model = "Annual petroleum consumption",
               term = names(stats::coef(barrels_model)),
               estimate = unname(stats::coef(barrels_model)))
  )
  save_table(coefficients, "regression_coefficients.csv")

  prediction_data <- data.frame(
    actual_mpg = comparison_data$comb08,
    drivetrain_prediction = as.numeric(stats::predict(drivetrain_model)),
    barrels_prediction = as.numeric(stats::predict(barrels_model))
  )
  prediction_chart <- ggplot2::ggplot(
      prediction_data, ggplot2::aes(x = actual_mpg, y = barrels_prediction)
    ) +
    ggplot2::geom_point(alpha = 0.14, size = 0.5, color = "#2864B4") +
    ggplot2::geom_abline(slope = 1, intercept = 0,
                         linetype = "dashed", color = "#C94B45") +
    ggplot2::labs(
      title = "Actual vs. Fitted MPG: Petroleum Consumption Model",
      subtitle = "Dashed line represents perfect fit; predictor is MPG-derived",
      x = "Actual combined MPG", y = "Fitted combined MPG"
    ) +
    ggplot2::theme_minimal(base_size = 12)
  save_plot(prediction_chart, "05_actual_vs_fitted_mpg.png")

  cat("Model comparison (see outputs/tables for full results):\n")
  print(model_metrics[, c("model", "sample_size", "adjusted_r_squared",
                          "root_mean_squared_error")], row.names = FALSE)

  invisible(model_metrics)
}
