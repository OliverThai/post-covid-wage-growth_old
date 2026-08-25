# The Remote Work Wage Premium: Post-COVID Wage Growth in Remote-Workable Occupations

## 1. Introduction

COVID-19 changed where many jobs could be performed. Occupations that were feasible to do from home may have experienced different wage dynamics after the pandemic than occupations requiring more in-person work. This project asks whether workers in remote-workable occupations experienced different wage growth after COVID compared with workers in less remote-workable occupations.

## 2. Data

The project is designed for a public ACS/IPUMS extract saved locally as `code/usa_00001.dta`. The analysis uses individual-level observations with year, age, sex, race, education, employment status, occupation, industry, state, wage income, usual weekly hours, weeks worked, and person weights.

The wage outcome is log hourly wage. Hourly wage is constructed as:

```text
hourly_wage = INCWAGE / (UHRSWORK x WKSWORK1)
```

Occupation-level remote-workability is measured using Dingel and Neiman's public work-from-home feasibility data, expected at `data/raw/remote/occupations_workathome.csv`. The cleaned variable `remote_workable` is merged to ACS workers by occupation.

## 3. Empirical Strategy

The main specification is:

```text
log_wage_it = beta0
            + beta1 remote_workable_i
            + beta2 post_t
            + beta3 remote_workable_i * post_t
            + controls
            + error_it
```

The post-COVID indicator is `post = year >= 2021`. The key coefficient is `beta3`, shown in Stata as:

```text
1.remote_workable#1.post
```

Because the outcome is log hourly wage, this coefficient can be interpreted approximately as a percent wage difference. For example, a coefficient of `0.05` is roughly 5 percent.

## 4. Results Placeholder

Results will be populated after the raw data files are added and the do-files are run in order:

```stata
do code/00_setup.do
do code/01_clean_acs.do
do code/02_inspect_remote.do
do code/03_clean_remote.do
do code/04_merge.do
do code/05_summary_stats.do
do code/06_figures.do
do code/07_regressions.do
```

The project will produce summary statistics, a wage trend figure, and regression output. The sign, magnitude, and statistical significance of `1.remote_workable#1.post` will determine whether the evidence suggests faster or slower post-COVID wage growth in remote-workable occupations.

## 5. Limitations

ACS does not directly observe whether each person worked remotely. This project studies remote-workable occupations, not confirmed remote workers.

The design is difference-in-differences style, but it should be interpreted cautiously. Remote-workable occupations differ from less remote-workable occupations in education, industry, skill requirements, labor demand shocks, and exposure to pandemic-era policy changes. Controls and fixed effects reduce some confounding but cannot remove all bias.

Occupation-code harmonization is also a central measurement challenge. If Dingel-Neiman occupation codes do not match IPUMS `occ`, an occupation crosswalk may be needed before interpreting results.

## 6. Conclusion

This project provides a clean, reproducible Stata framework for studying whether remote-workable occupations experienced different wage growth after COVID. It is designed to be understandable in an interview or portfolio setting while still following an economics research workflow.

## Connection to Hybrid-Work, Turnover, and Promotion Research

The project is inspired by research on hybrid work arrangements, turnover, and promotions, including papers such as “Balancing Turnover and Promotion Outcomes: Evidence on the Optimal Hybrid-Work Frequency.” Those studies often rely on internal firm records to observe promotion and retention outcomes directly.

This project takes a different public-data approach. It cannot observe internal promotion records, so it studies wage growth as a proxy for career advancement. The advantage is transparency and reproducibility; the tradeoff is that the analysis speaks to broad labor-market wage changes rather than firm-specific promotion processes.
