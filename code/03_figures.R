# 03_figures.R
# This file makes figures from the CSV files created in Stata.

args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  project <- args[1]
} else {
  project <- getwd()
}

setwd(project)

library(ggplot2)

overall <- read.csv("data/processed/overall_trends_for_r.csv")
remote <- read.csv("data/processed/wage_trends_for_r.csv")
race <- read.csv("data/processed/race_trends_for_r.csv")
age <- read.csv("data/processed/age_trends_for_r.csv")
gender <- read.csv("data/processed/gender_trends_for_r.csv")
college <- read.csv("data/processed/college_trends_for_r.csv")
industry <- read.csv("data/processed/industry_trends_for_r.csv")
state <- read.csv("data/processed/state_trends_for_r.csv")
ineq <- read.csv("data/processed/inequality_trends_for_r.csv")

state_names <- data.frame(
  stateicp = c(1, 2, 3, 4, 5, 6, 11, 12, 13, 14,
    21, 22, 23, 24, 25, 31, 32, 33, 34, 35,
    36, 37, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 51, 52, 53, 54, 56, 61, 62, 63,
    64, 65, 66, 67, 68, 71, 72, 73, 81, 82,
    83, 98),
  state_name = c("Connecticut", "Maine", "Massachusetts", "New Hampshire",
    "Rhode Island", "Vermont", "Delaware", "New Jersey", "New York",
    "Pennsylvania", "Illinois", "Indiana", "Michigan", "Ohio", "Wisconsin",
    "Iowa", "Kansas", "Minnesota", "Missouri", "Nebraska", "North Dakota",
    "South Dakota", "Virginia", "Alabama", "Arkansas", "Florida", "Georgia",
    "Louisiana", "Mississippi", "North Carolina", "South Carolina", "Texas",
    "Kentucky", "Maryland", "Oklahoma", "Tennessee", "West Virginia",
    "Arizona", "Colorado", "Idaho", "Montana", "Nevada", "New Mexico",
    "Utah", "Wyoming", "California", "Oregon", "Washington", "Alaska",
    "Hawaii", "Puerto Rico", "District of Columbia")
)

state <- merge(state, state_names, by = "stateicp")

overall$group <- "All workers"

remote$group <- ifelse(remote$remote_workable == 1,
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

college$group <- ifelse(college$college == 1,
  "College degree",
  "No college degree"
)

p1 <- ggplot(overall, aes(x = year, y = annual_wage)) +
  geom_line(color = "#2563eb", linewidth = 1.1) +
  geom_point(color = "#2563eb", size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Overall Wage Growth After COVID",
    x = "Year",
    y = "Average annual wage income"
  ) +
  theme_minimal()

ggsave("outputs/figures/overall_wage_growth.png", p1, width = 8, height = 5, dpi = 300)

p2 <- ggplot(remote, aes(x = year, y = annual_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Wage Trends by Remote-Workability",
    x = "Year",
    y = "Average annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/wage_trends.png", p2, width = 8, height = 5, dpi = 300)

p3 <- ggplot(remote, aes(x = year, y = log_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Log Wage Trends by Remote-Workability",
    x = "Year",
    y = "Average log annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/log_wage_trends.png", p3, width = 8, height = 5, dpi = 300)

p4 <- ggplot(race, aes(x = year, y = annual_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Wage Trends by Race",
    x = "Year",
    y = "Average annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/race_wage_trends.png", p4, width = 8, height = 5, dpi = 300)

p5 <- ggplot(age, aes(x = year, y = annual_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Wage Trends by Age Group",
    x = "Year",
    y = "Average annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/age_wage_trends.png", p5, width = 8, height = 5, dpi = 300)

p6 <- ggplot(gender, aes(x = year, y = annual_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Wage Trends by Gender",
    x = "Year",
    y = "Average annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/gender_wage_trends.png", p6, width = 8, height = 5, dpi = 300)

p7 <- ggplot(college, aes(x = year, y = annual_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Wage Trends by Education",
    x = "Year",
    y = "Average annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/college_wage_trends.png", p7, width = 8, height = 5, dpi = 300)

industry$period <- ifelse(industry$year > 2020, "Post-COVID", "Pre-COVID")
industry_avg <- aggregate(annual_wage ~ ind + period, data = industry, FUN = mean)

industry_pre <- subset(industry_avg, period == "Pre-COVID")
industry_post <- subset(industry_avg, period == "Post-COVID")

names(industry_pre)[3] <- "pre_wage"
names(industry_post)[3] <- "post_wage"

industry_growth <- merge(
  industry_pre[, c("ind", "pre_wage")],
  industry_post[, c("ind", "post_wage")],
  by = "ind"
)

industry_growth$wage_growth <- industry_growth$post_wage - industry_growth$pre_wage
industry_growth <- industry_growth[order(-industry_growth$wage_growth), ]
top_industry <- head(industry_growth, 10)
top_industry$ind <- as.character(top_industry$ind)

write.csv(top_industry, "outputs/tables/top_industry_growth.csv", row.names = FALSE)

p8 <- ggplot(top_industry, aes(x = reorder(ind, wage_growth), y = wage_growth)) +
  geom_col(fill = "#2563eb") +
  coord_flip() +
  labs(
    title = "Industries With the Biggest Wage Growth After COVID",
    x = "Industry code",
    y = "Post-COVID wage income growth"
  ) +
  theme_minimal()

ggsave("outputs/figures/top_industry_growth.png", p8, width = 8, height = 5, dpi = 300)

state$period <- ifelse(state$year > 2020, "Post-COVID", "Pre-COVID")
state_avg <- aggregate(annual_wage ~ stateicp + state_name + period, data = state, FUN = mean)

state_pre <- subset(state_avg, period == "Pre-COVID")
state_post <- subset(state_avg, period == "Post-COVID")

names(state_pre)[4] <- "pre_wage"
names(state_post)[4] <- "post_wage"

state_growth <- merge(
  state_pre[, c("stateicp", "state_name", "pre_wage")],
  state_post[, c("stateicp", "state_name", "post_wage")],
  by = "stateicp"
)

state_growth$state_name <- state_growth$state_name.x
state_growth$state_name.x <- NULL
state_growth$state_name.y <- NULL

state_growth$wage_growth <- state_growth$post_wage - state_growth$pre_wage
state_growth <- state_growth[order(-state_growth$wage_growth), ]
top_state_growth <- head(state_growth, 15)

write.csv(top_state_growth, "outputs/tables/top_state_growth.csv", row.names = FALSE)

p9 <- ggplot(top_state_growth, aes(x = reorder(state_name, wage_growth), y = wage_growth)) +
  geom_col(fill = "#16a34a") +
  coord_flip() +
  labs(
    title = "States With the Biggest Wage Growth After COVID",
    x = "State",
    y = "Post-COVID wage income growth"
  ) +
  theme_minimal()

ggsave("outputs/figures/top_state_growth.png", p9, width = 8, height = 5, dpi = 300)

state_level <- subset(state, year > 2020)
state_level <- aggregate(annual_wage ~ stateicp + state_name, data = state_level, FUN = mean)
names(state_level)[3] <- "post_covid_wage"
state_level <- state_level[order(-state_level$post_covid_wage), ]
top_state_level <- head(state_level, 15)

write.csv(top_state_level, "outputs/tables/top_state_wage_levels.csv", row.names = FALSE)

p10 <- ggplot(top_state_level, aes(x = reorder(state_name, post_covid_wage), y = post_covid_wage)) +
  geom_col(fill = "#7c3aed") +
  coord_flip() +
  labs(
    title = "States With the Highest Post-COVID Wage Levels",
    x = "State",
    y = "Average post-COVID annual wage income"
  ) +
  theme_minimal()

ggsave("outputs/figures/state_wage_levels.png", p10, width = 8, height = 5, dpi = 300)

p11 <- ggplot(ineq, aes(x = year, y = p90_p10_gap)) +
  geom_line(color = "#dc2626", linewidth = 1.1) +
  geom_point(color = "#dc2626", size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Wage Inequality After COVID",
    x = "Year",
    y = "P90 annual wage income minus P10 annual wage income"
  ) +
  theme_minimal()

ggsave("outputs/figures/wage_inequality.png", p11, width = 8, height = 5, dpi = 300)

message("Saved figures to outputs/figures/")
