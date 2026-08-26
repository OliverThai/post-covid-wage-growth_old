# 03_figures.R
# Make project figures from the small CSV created by Stata.

project <- getwd()

trend_file <- file.path(project, "data", "processed", "wage_trends_for_r.csv")
figure_folder <- file.path(project, "outputs", "figures")

if (!file.exists(trend_file)) {
  stop("Missing data/processed/wage_trends_for_r.csv. Run code/02_analysis.do first.")
}

if (!dir.exists(figure_folder)) {
  dir.create(figure_folder, recursive = TRUE)
}

trend <- read.csv(trend_file)

trend$group <- ifelse(
  trend$remote_workable == 1,
  "Remote-workable",
  "Less remote-workable"
)

colors <- c(
  "Remote-workable" = "#2563eb",
  "Less remote-workable" = "#dc2626"
)

if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)

  p1 <- ggplot(trend, aes(x = year, y = hourly_wage, color = group)) +
    geom_line(linewidth = 1.1) +
    geom_point(size = 2) +
    scale_color_manual(values = colors) +
    labs(
      title = "Wage Trends by Remote-Workability",
      x = "Year",
      y = "Average hourly wage",
      color = ""
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "bottom"
    )

  ggsave(
    file.path(figure_folder, "wage_trends.png"),
    p1,
    width = 8,
    height = 5,
    dpi = 300
  )

  p2 <- ggplot(trend, aes(x = year, y = log_wage, color = group)) +
    geom_line(linewidth = 1.1) +
    geom_point(size = 2) +
    scale_color_manual(values = colors) +
    labs(
      title = "Log Wage Trends by Remote-Workability",
      x = "Year",
      y = "Average log hourly wage",
      color = ""
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "bottom"
    )

  ggsave(
    file.path(figure_folder, "log_wage_trends.png"),
    p2,
    width = 8,
    height = 5,
    dpi = 300
  )
} else {
  png(file.path(figure_folder, "wage_trends.png"), width = 2400, height = 1500, res = 300)
  plot(
    NA,
    xlim = range(trend$year),
    ylim = range(trend$hourly_wage),
    xlab = "Year",
    ylab = "Average hourly wage",
    main = "Wage Trends by Remote-Workability"
  )
  for (g in unique(trend$group)) {
    temp <- trend[trend$group == g, ]
    temp <- temp[order(temp$year), ]
    lines(temp$year, temp$hourly_wage, col = colors[g], lwd = 2)
    points(temp$year, temp$hourly_wage, col = colors[g], pch = 19)
  }
  legend("bottomright", legend = names(colors), col = colors, lwd = 2, bty = "n")
  dev.off()

  png(file.path(figure_folder, "log_wage_trends.png"), width = 2400, height = 1500, res = 300)
  plot(
    NA,
    xlim = range(trend$year),
    ylim = range(trend$log_wage),
    xlab = "Year",
    ylab = "Average log hourly wage",
    main = "Log Wage Trends by Remote-Workability"
  )
  for (g in unique(trend$group)) {
    temp <- trend[trend$group == g, ]
    temp <- temp[order(temp$year), ]
    lines(temp$year, temp$log_wage, col = colors[g], lwd = 2)
    points(temp$year, temp$log_wage, col = colors[g], pch = 19)
  }
  legend("bottomright", legend = names(colors), col = colors, lwd = 2, bty = "n")
  dev.off()
}

message("Saved figures to outputs/figures/")
