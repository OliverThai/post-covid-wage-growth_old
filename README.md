# Wage Growth After COVID

This project looks at how wage income changed after COVID using public ACS/IPUMS labor-market data. The main question is whether wage growth after COVID looked different across workers, industries, states, and occupations that were more or less remote-workable.

The project uses Stata for the main cleaning and regression work. R is used at the end to make the figures.

## Research Question

How were wages affected after COVID, and did those changes differ across groups of workers?

The project also keeps the original remote-work question:

Did workers in remote-workable occupations experience different wage growth after COVID compared with workers in less remote-workable occupations?

## Data

The worker-level data comes from ACS/IPUMS. The raw ACS file should be saved here:

```text
data/raw/usa_00001.dta
```

The project uses these ACS/IPUMS variables:

```text
YEAR
AGE
SEX
RACE
EDUC
EMPSTAT
OCC
OCCSOC
IND
STATEICP
INCWAGE
PERWT
```

Remote-workability comes from the Dingel-Neiman occupation-level work-from-home feasibility file. Save it here:

```text
data/raw/remote/occupations_workathome.csv
```

That file should include:

```text
onetsoccode
title
teleworkable
```

The ACS extract includes `OCCSOC`, so the Stata code can merge workers to the remote-workability data using SOC occupation codes.

## Main Variables

The outcome is annual wage income:

```stata
gen annual_wage = incwage
gen log_wage = log(annual_wage)
```

I use annual wage income instead of hourly wage because `WKSWORK1` is missing for 2016-2018 in the current ACS extract. Using `INCWAGE` keeps the full 2016-2024 sample.

The post-COVID variable is:

```stata
gen covid = year > 2020
```

The sample keeps employed prime-age workers ages 25 to 54.

## Method

The basic regression compares wages before and after COVID:

```text
log_wage = covid + controls
```

The remote-workability regression uses an interaction:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient is:

```text
1.remote_workable#1.covid
```

If this coefficient is positive, remote-workable occupations had higher wage growth after COVID relative to less remote-workable occupations. If it is negative, they had lower relative wage growth.

Because the outcome is log wage income, a coefficient like `0.05` is roughly a 5 percent difference.

## How to Run

Open Stata and move into the project folder:

```stata
cd "/Users/ollie1/Documents/New project/remote-work-career-project"
```

Then run:

```stata
do code/00_setup.do
do code/01_build_data.do
do code/02_analysis.do
```

The last Stata file runs the R figure script automatically. If R does not run from Stata, run this separately in Terminal:

```text
Rscript code/03_figures.R
```

## Outputs

Main cleaned data files:

```text
data/processed/cleaned.dta
data/processed/remote_soc_only.dta
data/processed/analysis_data.dta
```

Tables:

```text
outputs/tables/summary_stats.txt
outputs/tables/regressions.txt
outputs/tables/top_industry_growth.csv
outputs/tables/top_state_wage_levels.csv
outputs/tables/percent_growth_by_group.csv
```

Figures:

```text
outputs/figures/overall_wage_growth.png
outputs/figures/log_wage_trends.png
outputs/figures/top_industry_growth.png
outputs/figures/state_wage_levels.png
outputs/figures/p10_p50_p90_trends.png
outputs/figures/percent_growth_by_group.png
```

## Results

The results are not written into the project yet. After running the Stata files, the main regression output will be in:

```text
outputs/tables/regressions.txt
```

The key number for the remote-work part is:

```text
1.remote_workable#1.covid
```

The figures can be used to describe overall wage growth, wage growth by group, industry wage growth, state wage levels, and wage inequality after COVID.
