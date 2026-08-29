# The Remote Work Wage Premium

A Stata economics project studying post-COVID wage growth in remote-workable occupations.

# The Remote Work Wage Premium

## 1.0 Research Problem

The COVID-19 pandemic changed how work is organized across the U.S. labor market. Some occupations could shift to remote or hybrid work much more easily than others.

This project asks whether workers in remote-workable occupations experienced different wage growth after COVID compared to workers in less remote-workable occupations.

The main research question is:

**Did workers in remote-workable occupations experience different wage growth after COVID compared to workers in less remote-workable occupations?**

## 2.0 Research Assumptions

This project studies remote-workable occupations, not confirmed remote workers. ACS does not directly say whether each person worked remotely.

Remote-workability is measured at the occupation level using Dingel-Neiman work-from-home feasibility data.

Hourly wage is created as:

```text
hourly_wage = INCWAGE / (UHRSWORK x WKSWORK1)
```

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
UHRSWORK
WKSWORK1
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

Step 03. Analysis: Create summary stats, run the regressions, and export a small wage-trend file.

Step 04. Figures: R reads the wage-trend file and saves the graphs.

## 5.0 Method

The main regression idea is:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient to look at is:

```text
1.remote_workable#1.covid
```

Because the outcome is log wage, a coefficient of `0.05` is about a 5 percent wage difference.

The main Stata regressions are:

```stata
reg log_wage i.remote_workable##i.covid [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex ///
    i.race i.stateicp i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex ///
    i.race i.stateicp i.year i.ind [pw=perwt], robust

reg log_wage c.remote_score##i.covid age age2 i.educ i.sex ///
    i.race i.stateicp i.year i.ind [pw=perwt], robust
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

The last Stata file tries to run the R figure script automatically. If that does not work inside Stata, run this in Terminal:

```text
Rscript code/03_figures.R
```

## 8.0 Expected Outputs

Cleaned data:

```text
data/processed/cleaned.dta
data/processed/remote_soc_only.dta
data/processed/analysis_data.dta
data/processed/wage_trends_for_r.csv
```

Tables/logs:

```text
outputs/tables/summary_stats.txt
outputs/tables/regressions.txt
```

Figure:

```text
outputs/figures/wage_trends.png
outputs/figures/log_wage_trends.png
```

## 9.0 Results

Results are not filled in yet because the Stata do-files still need to be run.

The main result will come from:

```text
1.remote_workable#1.covid
```

If the coefficient is positive, remote-workable occupations had higher wage growth after COVID relative to less remote-workable occupations.

If the coefficient is negative, remote-workable occupations had lower wage growth after COVID relative to less remote-workable occupations.

## 10.0 Limitations

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
