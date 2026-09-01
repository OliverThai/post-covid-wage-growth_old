# Wage Growth After COVID

A Stata/R economics project studying how wages changed after COVID.

# Wage Growth After COVID

## 1.0 Research Problem

The COVID-19 pandemic changed the U.S. labor market. Wages did not necessarily change the same way for every group of workers.

This project asks how wages changed after COVID and whether those changes looked different across race groups, age groups, gender, education, industry, state, and remote-workable occupations.

The main research question is:

**How were wages affected after COVID, and did those changes differ across workers and places?**

## 2.0 Research Assumptions

This project studies wage changes before and after COVID using public ACS/IPUMS data.

For the remote-work part, the project studies remote-workable occupations, not confirmed remote workers. ACS does not directly say whether each person worked remotely.

Remote-workability is measured at the occupation level using Dingel-Neiman work-from-home feasibility data.

The main wage outcome is annual wage income:

```text
annual_wage = INCWAGE
log_wage = log(annual_wage)
```

The project uses annual wage income instead of hourly wage because `WKSWORK1` is missing for 2016-2018 in the current ACS extract. Using `INCWAGE` keeps the full set of years in the graphs and regressions.

The COVID/post period variable is:

```text
covid = year > 2020
```

The sample keeps employed prime-age workers, ages 25 to 54.

## 3.0 Data Sources

The main worker-level data comes from ACS/IPUMS. The expected file is:

```text
data/raw/usa_00001.dta
```

The ACS/IPUMS variables used are:

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

The important occupation variable is `OCCSOC`, because it lets the project merge ACS occupations directly with the Dingel-Neiman remote-workability file.

The remote-workability data comes from Dingel and Neiman's occupation-level work-from-home feasibility file:

```text
data/raw/remote/occupations_workathome.csv
```

The file currently has:

```text
onetsoccode
title
teleworkable
```

The Stata code cleans `onetsoccode` into the same six-digit SOC format as `OCCSOC`, then merges the files.

## 4.0 Solution Strategy

The project mostly uses Stata, with one small R file for nicer figures.

Step 01. Setup: Create the project folders.

Step 02. Build Data: Clean the ACS data, clean the remote-workability data, and merge everything into one analysis dataset.

Step 03. Analysis: Create summary stats, run the regressions, and export wage-trend files.

Step 04. Figures: R reads the wage-trend files and saves the graphs.

## 5.0 Method

The first regression idea is:

```text
log_wage = covid + controls
```

The coefficient on `covid` shows the average post-COVID annual wage-income difference, after controls.

The remote-workability regression idea is:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient to look at is:

```text
1.remote_workable#1.covid
```

Because the outcome is log annual wage income, a coefficient of `0.05` is about a 5 percent wage-income difference.

The main Stata regressions are:

```stata
reg log_wage i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.remote_workable##i.covid [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex ///
    i.race i.stateicp i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex ///
    i.race i.stateicp i.year i.ind [pw=perwt], robust

reg log_wage c.remote_score##i.covid age age2 i.educ i.sex ///
    i.race i.stateicp i.year i.ind [pw=perwt], robust

reg log_wage i.race##i.covid age age2 i.educ i.sex ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.age_group##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.sex##i.covid age age2 i.educ i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.college##i.covid age age2 i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.ind##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp [pw=perwt], robust

reg log_wage i.stateicp##i.covid age age2 i.educ i.sex i.race ///
    i.ind [pw=perwt], robust
```

## 6.0 Project Structure

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

## 7.0 How to Run

Open Stata and set the working directory to the project folder:

```stata
cd "/Users/ollie1/Documents/New project/remote-work-career-project"
```

Then run the files in order:

```stata
do code/00_setup.do
do code/01_build_data.do
do code/02_analysis.do
```

The last Stata file runs the R figure script automatically. If that does not work inside Stata, run this in Terminal:

```text
Rscript code/03_figures.R
```

## 8.0 Expected Outputs

Cleaned data:

```text
data/processed/cleaned.dta
data/processed/remote_soc_only.dta
data/processed/analysis_data.dta
data/processed/race_trends_for_r.csv
data/processed/age_trends_for_r.csv
data/processed/gender_trends_for_r.csv
data/processed/college_trends_for_r.csv
data/processed/industry_trends_for_r.csv
data/processed/state_trends_for_r.csv
data/processed/inequality_trends_for_r.csv
```

Tables/logs:

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
outputs/figures/top_industry_growth.png
outputs/figures/state_wage_levels.png
outputs/figures/p10_p50_p90_trends.png
outputs/figures/percent_growth_by_group.png
```

## 9.0 Results

Results are not filled in yet because the Stata do-files still need to be run.

The main results will come from:

```text
1.covid
1.remote_workable#1.covid
i.race#1.covid
i.age_group#1.covid
i.sex#1.covid
i.college#1.covid
i.ind#1.covid
i.stateicp#1.covid
```

The `1.covid` coefficient shows the average post-COVID wage difference.

If the remote-workability interaction is positive, remote-workable occupations had higher wage growth after COVID relative to less remote-workable occupations.

If the remote-workability interaction is negative, remote-workable occupations had lower wage growth after COVID relative to less remote-workable occupations.

## 10.0 Limitations

This is a before/after project, so it should be interpreted carefully. Many things changed after COVID besides remote work.

ACS does not directly measure whether each person worked remotely.

The project assigns remote-workability by occupation, so it compares types of jobs instead of actual remote-work status.

The Dingel-Neiman occupation codes may not perfectly match every IPUMS `OCCSOC` code, so the merge needs to be checked carefully.

## 11.0 Connection to Hybrid-Work Research

This project is inspired by research on hybrid work, turnover, and promotions. Those papers often use internal firm data to directly observe promotions and retention.

This project uses public labor-market data instead. It studies wage growth as a proxy for career advancement rather than internal promotions.

## 12.0 Lessons Learned

Public data can still be used to study career advancement questions when private company data are unavailable.

Occupation-level remote-workability measures are useful, but the occupation-code merge is important.

Log wage regressions are helpful because the results can be read approximately as percent differences.

## 13.0 Next Steps

Add `usa_00001.dta` to `data/raw/`.

Add `occupations_workathome.csv` to `data/raw/remote/`.

Run the three Stata do-files in order.

Check the merge results from `tab _merge`.

Update this README with the actual regression result after the code runs.
