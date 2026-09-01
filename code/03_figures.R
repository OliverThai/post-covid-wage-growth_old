# 03_figures.R
# Make figures from the small CSV files created by Stata.

args <- commandArgs(trailingOnly = TRUE)

if (length(args) >= 1) {
  project <- args[1]
} else {
  project <- getwd()
}

processed <- file.path(project, "data", "processed")
figure_folder <- file.path(project, "outputs", "figures")

if (!dir.exists(figure_folder)) {
  dir.create(figure_folder, recursive = TRUE)
}

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("Please install ggplot2 in R: install.packages('ggplot2')")
}

library(ggplot2)

read_trend <- function(file_name) {
  path <- file.path(processed, file_name)
  if (!file.exists(path)) {
    stop(paste("Missing", path, "- run code/02_analysis.do first."))
  }
  read.csv(path)
}

save_line_graph <- function(data, x, y, color, title, y_label, file_name) {
  p <- ggplot(data, aes(x = .data[[x]], y = .data[[y]], color = .data[[color]])) +
    geom_line(linewidth = 1.1) +
    geom_point(size = 2) +
    geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
    labs(
      title = title,
      x = "Year",
      y = y_label,
      color = ""
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "bottom"
    )

  ggsave(file.path(figure_folder, file_name), p, width = 8, height = 5, dpi = 300)
}

overall <- read_trend("overall_trends_for_r.csv")
remote <- read_trend("wage_trends_for_r.csv")
race <- read_trend("race_trends_for_r.csv")
age <- read_trend("age_trends_for_r.csv")
gender <- read_trend("gender_trends_for_r.csv")
college <- read_trend("college_trends_for_r.csv")
industry <- read_trend("industry_trends_for_r.csv")
state <- read_trend("state_trends_for_r.csv")
ineq <- read_trend("inequality_trends_for_r.csv")

overall$group <- "All workers"

remote$group <- ifelse(
  remote$remote_workable == 1,
  "Remote-workable",
  "Less remote-workable"
)

race$group <- ifelse(race$race == 1, "White",
  ifelse(race$race == 2, "Black",
    ifelse(race$race == 3, "American Indian",
      ifelse(race$race %in% c(4, 5, 6), "Asian/Pacific Islander",
        ifelse(race$race %in% c(8, 9), "Multiracial", "Other race")
      )
    )
  )
)

age$group <- ifelse(age$age_group == 1, "25-34",
  ifelse(age$age_group == 2, "35-44", "45-54")
)

gender$group <- ifelse(gender$sex == 1, "Men", "Women")
college$group <- ifelse(college$college == 1, "College degree", "No college degree")

save_line_graph(overall, "year", "hourly_wage", "group",
  "Overall Wage Growth After COVID",
  "Average hourly wage",
  "overall_wage_growth.png"
)

save_line_graph(remote, "year", "hourly_wage", "group",
  "Wage Trends by Remote-Workability",
  "Average hourly wage",
  "wage_trends.png"
)

save_line_graph(remote, "year", "log_wage", "group",
  "Log Wage Trends by Remote-Workability",
  "Average log hourly wage",
  "log_wage_trends.png"
)

save_line_graph(race, "year", "hourly_wage", "group",
  "Wage Trends by Race",
  "Average hourly wage",
  "race_wage_trends.png"
)

save_line_graph(age, "year", "hourly_wage", "group",
  "Wage Trends by Age Group",
  "Average hourly wage",
  "age_wage_trends.png"
)

save_line_graph(gender, "year", "hourly_wage", "group",
  "Wage Trends by Gender",
  "Average hourly wage",
  "gender_wage_trends.png"
)

save_line_graph(college, "year", "hourly_wage", "group",
  "Wage Trends by Education",
  "Average hourly wage",
  "college_wage_trends.png"
)

pre_post <- function(data, group_var) {
  data$period <- ifelse(data$year > 2020, "Post-COVID", "Pre-COVID")
  out <- aggregate(
    data$hourly_wage,
    by = list(group = data[[group_var]], period = data$period),
    FUN = mean
  )
  names(out)[3] <- "avg_wage"
  pre <- out[out$period == "Pre-COVID", c("group", "avg_wage")]
  post <- out[out$period == "Post-COVID", c("group", "avg_wage")]
  names(pre)[2] <- "pre_wage"
  names(post)[2] <- "post_wage"
  merged <- merge(pre, post, by = "group")
  merged$wage_growth <- merged$post_wage - merged$pre_wage
  merged
}

industry_growth <- pre_post(industry, "ind")
industry_growth <- industry_growth[order(-industry_growth$wage_growth), ]
industry_growth$group <- as.character(industry_growth$group)
top_industry <- head(industry_growth, 10)
write.csv(
  top_industry,
  file.path(project, "outputs", "tables", "top_industry_growth.csv"),
  row.names = FALSE
)

p_ind <- ggplot(top_industry, aes(x = reorder(group, wage_growth), y = wage_growth)) +
  geom_col(fill = "#2563eb") +
  coord_flip() +
  labs(
    title = "Industries With the Biggest Wage Growth After COVID",
    x = "Industry code",
    y = "Post-COVID wage growth"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave(file.path(figure_folder, "top_industry_growth.png"), p_ind, width = 8, height = 5, dpi = 300)

state_growth <- pre_post(state, "stateicp")
state_growth <- state_growth[order(-state_growth$wage_growth), ]
state_growth$group <- as.character(state_growth$group)
top_state <- head(state_growth, 15)
write.csv(
  top_state,
  file.path(project, "outputs", "tables", "top_state_growth.csv"),
  row.names = FALSE
)

p_state <- ggplot(top_state, aes(x = reorder(group, wage_growth), y = wage_growth)) +
  geom_col(fill = "#16a34a") +
  coord_flip() +
  labs(
    title = "States With the Biggest Wage Growth After COVID",
    x = "State code",
    y = "Post-COVID wage growth"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave(file.path(figure_folder, "top_state_growth.png"), p_state, width = 8, height = 5, dpi = 300)

state_post <- state[state$year > 2020, ]
state_levels <- aggregate(
  state_post$hourly_wage,
  by = list(state = state_post$stateicp),
  FUN = mean
)
names(state_levels)[2] <- "post_covid_wage"
state_levels <- state_levels[order(-state_levels$post_covid_wage), ]
state_levels$state <- as.character(state_levels$state)
top_state_levels <- head(state_levels, 15)
write.csv(
  top_state_levels,
  file.path(project, "outputs", "tables", "top_state_wage_levels.csv"),
  row.names = FALSE
)

p_state_level <- ggplot(top_state_levels, aes(x = reorder(state, post_covid_wage), y = post_covid_wage)) +
  geom_col(fill = "#7c3aed") +
  coord_flip() +
  labs(
    title = "States With the Highest Post-COVID Wage Levels",
    x = "State code",
    y = "Average post-COVID hourly wage"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave(file.path(figure_folder, "state_wage_levels.png"), p_state_level, width = 8, height = 5, dpi = 300)

ineq$group <- "P90-P10 gap"

save_line_graph(ineq, "year", "p90_p10_gap", "group",
  "Wage Inequality After COVID",
  "P90 hourly wage minus P10 hourly wage",
  "wage_inequality.png"
)

message("Saved figures to outputs/figures/")
