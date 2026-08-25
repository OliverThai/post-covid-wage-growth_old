# The Remote Work Wage Premium

## Project

**Title:** The Remote Work Wage Premium: Post-COVID Wage Growth in Remote-Workable Occupations

**Research question:** Did workers in remote-workable occupations experience different wage growth after COVID compared to workers in less remote-workable occupations?

This is an independent economic consulting-style research project built in Stata. The project uses public ACS/IPUMS labor-market data and Dingel-Neiman occupation-level work-from-home feasibility data.

## Folder Structure

```text
code/
data/
data/raw/
data/raw/remote/
data/processed/
outputs/
outputs/tables/
outputs/figures/
notes/
```

## Data Sources

### ACS/IPUMS

The main labor-market dataset is an ACS extract from IPUMS. The expected file is:

```text
code/usa_00001.dta
```

The selected IPUMS variables are:

```text
YEAR
AGE
SEX
RACE
EDUC
EMPSTAT
OCC
IND
STATEFIP
INCWAGE
UHRSWORK
WKSWORK1
PERWT
```

### Dingel-Neiman Remote-Workability Data

The remote-workability source is Dingel and Neiman's occupation-level work-from-home feasibility data. The expected raw file is:

```text
data/raw/remote/occupations_workathome.csv
```

The cleaned version is saved as:

```text
data/processed/remote_clean.dta
```

## Key Variable Construction

The project constructs hourly wages as:

```text
hourly_wage = INCWAGE / (UHRSWORK x WKSWORK1)
```

Then it constructs:

```text
log_wage = log(hourly_wage)
post = year >= 2021
age2 = age^2
```

The treatment variable is:

```text
remote_workable
```

This comes from the Dingel-Neiman occupation-level data. In the final merged data, it indicates whether an occupation is classified as remote-workable.

## Method

The project uses a difference-in-differences style comparison of wage growth in remote-workable versus less remote-workable occupations before and after COVID.

The core regression is:

```stata
reg log_wage i.remote_workable##i.post [pw=perwt], robust
```

The main coefficient of interest is:

```text
1.remote_workable#1.post
```

Because the outcome is log hourly wage, this coefficient can be interpreted approximately as a percent wage difference. For example, a coefficient of `0.05` is roughly a 5 percent difference.

## How to Run

Open Stata and set the working directory to the project folder:

```stata
cd "/Users/ollie1/Documents/New project/remote-work-career-project"
```

Then run the do-files in order:

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

## Output Files

Cleaned data:

```text
data/processed/acs_clean.dta
data/processed/remote_clean.dta
data/processed/analysis_data.dta
```

Tables:

```text
outputs/tables/summary_overall.csv
outputs/tables/summary_by_remote.csv
outputs/tables/regression_results.txt
outputs/tables/regression_table.rtf
```

Figures:

```text
outputs/figures/wage_trends.png
```

## Important Limitation

ACS does not directly show whether each person worked remotely. This project studies workers in remote-workable occupations, not confirmed remote workers.

Also, Dingel-Neiman occupation codes may not automatically match IPUMS `occ`. The merge script reports match quality. If the match rate is low, an occupation crosswalk may be needed before interpreting results.

## Connection to Hybrid-Work Research

This project is inspired by research on hybrid work, turnover, and promotions, including papers such as “Balancing Turnover and Promotion Outcomes: Evidence on the Optimal Hybrid-Work Frequency.” Those studies often use internal firm data to observe promotions and retention directly.

This project uses public labor-market data instead. It studies wage growth as a proxy for career advancement rather than internal firm promotions. The advantage is that the project is reproducible with public data; the tradeoff is that it cannot directly measure promotions inside firms.
