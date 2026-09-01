# 03_figures.R
# Make project figures from the small CSV created by Stata.

args <- commandArgs(trailingOnly = TRUE)

if (length(args) >= 1) {
  project <- args[1]
} else {
  project <- getwd()
}

trend_file <- file.path(project, "data", "processed", "wage_trends_for_r.csv")
race_file <- file.path(project, "data", "processed", "race_trends_for_r.csv")
age_file <- file.path(project, "data", "processed", "age_trends_for_r.csv")
figure_folder <- file.path(project, "outputs", "figures")

if (!file.exists(trend_file)) {
  stop("Missing data/processed/wage_trends_for_r.csv. Run code/02_analysis.do first.")
}

if (!file.exists(race_file)) {
  stop("Missing data/processed/race_trends_for_r.csv. Run code/02_analysis.do first.")
}

if (!file.exists(age_file)) {
  stop("Missing data/processed/age_trends_for_r.csv. Run code/02_analysis.do first.")
}

if (!dir.exists(figure_folder)) {
  dir.create(figure_folder, recursive = TRUE)
}

trend <- read.csv(trend_file)
race_trend <- read.csv(race_file)
age_trend <- read.csv(age_file)

trend$group <- ifelse(
  trend$remote_workable == 1,
  "Remote-workable",
  "Less remote-workable"
)

colors <- c(
  "Remote-workable" = "#2563eb",
  "Less remote-workable" = "#dc2626"
)

race_trend$race_group <- ifelse(race_trend$race == 1, "White",
  ifelse(race_trend$race == 2, "Black",
    ifelse(race_trend$race == 3, "American Indian",
      ifelse(race_trend$race %in% c(4, 5, 6), "Asian/Pacific Islander",
        ifelse(race_trend$race %in% c(8, 9), "Multiracial", "Other race")
      )
    )
  )
)

age_trend$age_group_name <- ifelse(age_trend$age_group == 1, "25-34",
  ifelse(age_trend$age_group == 2, "35-44", "45-54")
)

if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)

  p1 <- ggplot(trend, aes(x = year, y = hourly_wage, color = group)) +
    geom_line(linewidth = 1.1) +
    geom_point(size = 2) +
    scale_color_manual(values = colors) +
    geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
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
    geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
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

  p3 <- ggplot(race_trend, aes(x = year, y = hourly_wage, color = race_group)) +
    geom_line(linewidth = 1.1) +
    geom_point(size = 2) +
    geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
    labs(
      title = "Wage Trends by Race",
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
    file.path(figure_folder, "race_wage_trends.png"),
    p3,
    width = 8,
    height = 5,
    dpi = 300
  )

  p4 <- ggplot(age_trend, aes(x = year, y = hourly_wage, color = age_group_name)) +
    geom_line(linewidth = 1.1) +
    geom_point(size = 2) +
    geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
    labs(
      title = "Wage Trends by Age Group",
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
    file.path(figure_folder, "age_wage_trends.png"),
    p4,
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
  abline(v = 2020, lty = 2, col = "gray40")
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
  abline(v = 2020, lty = 2, col = "gray40")
  for (g in unique(trend$group)) {
    temp <- trend[trend$group == g, ]
    temp <- temp[order(temp$year), ]
    lines(temp$year, temp$log_wage, col = colors[g], lwd = 2)
    points(temp$year, temp$log_wage, col = colors[g], pch = 19)
  }
  legend("bottomright", legend = names(colors), col = colors, lwd = 2, bty = "n")
  dev.off()

  png(file.path(figure_folder, "race_wage_trends.png"), width = 2400, height = 1500, res = 300)
  plot(
    NA,
    xlim = range(race_trend$year),
    ylim = range(race_trend$hourly_wage),
    xlab = "Year",
    ylab = "Average hourly wage",
    main = "Wage Trends by Race"
  )
  abline(v = 2020, lty = 2, col = "gray40")
  race_colors <- rainbow(length(unique(race_trend$race_group)))
  names(race_colors) <- unique(race_trend$race_group)
  for (g in unique(race_trend$race_group)) {
    temp <- race_trend[race_trend$race_group == g, ]
    temp <- temp[order(temp$year), ]
    lines(temp$year, temp$hourly_wage, col = race_colors[g], lwd = 2)
    points(temp$year, temp$hourly_wage, col = race_colors[g], pch = 19)
  }
  legend("bottomright", legend = names(race_colors), col = race_colors, lwd = 2, bty = "n")
  dev.off()

  png(file.path(figure_folder, "age_wage_trends.png"), width = 2400, height = 1500, res = 300)
  plot(
    NA,
    xlim = range(age_trend$year),
    ylim = range(age_trend$hourly_wage),
    xlab = "Year",
    ylab = "Average hourly wage",
    main = "Wage Trends by Age Group"
  )
  abline(v = 2020, lty = 2, col = "gray40")
  age_colors <- c("25-34" = "#2563eb", "35-44" = "#16a34a", "45-54" = "#dc2626")
  for (g in unique(age_trend$age_group_name)) {
    temp <- age_trend[age_trend$age_group_name == g, ]
    temp <- temp[order(temp$year), ]
    lines(temp$year, temp$hourly_wage, col = age_colors[g], lwd = 2)
    points(temp$year, temp$hourly_wage, col = age_colors[g], pch = 19)
  }
  legend("bottomright", legend = names(age_colors), col = age_colors, lwd = 2, bty = "n")
  dev.off()
}

message("Saved figures to outputs/figures/")
