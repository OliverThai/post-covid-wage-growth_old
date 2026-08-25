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

If the file is already in the code folder, the cleaning script can also read:

```text
code/usa_00001.dta
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
IND
STATEFIP
INCWAGE
UHRSWORK
WKSWORK1
PERWT
```

The remote-workability data comes from Dingel and Neiman's occupation-level work-from-home feasibility file:

```text
data/raw/remote/occupations_workathome.csv
```

## 4.0 Solution Strategy

The project is split into small Stata do-files so each step is easy to understand.

Step 01. Setup: Create folders and check whether the raw files exist.

Step 02. Clean ACS: Keep employed prime-age workers, create hourly wages, drop wage outliers using two standard deviations from the mean, create `covid`, `log_wage`, and `age2`, then save the cleaned data.

Step 03. Inspect Remote Data: Open the Dingel-Neiman CSV and look at the variables.

Step 04. Clean Remote Data: Create a simple occupation-level file with `occ` and `remote_workable`.

Step 05. Merge: Merge workers to remote-workability by occupation.

Step 06. Summary Stats: Create basic summary statistics.

Step 07. Figures: Create a wage trend graph.

Step 08. Regressions: Run the main difference-in-differences style regressions.

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

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.statefip i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.statefip i.year i.ind [pw=perwt], robust
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
do code/01_clean_acs.do
do code/02_inspect_remote.do
do code/03_clean_remote.do
do code/04_merge.do
do code/05_summary_stats.do
do code/06_figures.do
do code/07_regressions.do
```

## 8.0 Expected Outputs

Cleaned data:

```text
data/processed/cleaned.dta
data/processed/remote_clean.dta
data/processed/analysis_data.dta
```

Tables/logs:

```text
outputs/tables/summary_stats.txt
outputs/tables/regressions.txt
```

Figure:

```text
outputs/figures/wage_trends.png
```

## 9.0 Results

Results are not filled in yet because the raw ACS/IPUMS file and Dingel-Neiman CSV need to be added first.

The main result will come from:

```text
1.remote_workable#1.covid
```

If the coefficient is positive, remote-workable occupations had higher wage growth after COVID relative to less remote-workable occupations.

If the coefficient is negative, remote-workable occupations had lower wage growth after COVID relative to less remote-workable occupations.

## 10.0 Limitations

ACS does not directly measure whether each person worked remotely.

The project assigns remote-workability by occupation, so it compares types of jobs instead of actual remote-work status.

The Dingel-Neiman occupation codes may not perfectly match IPUMS `occ`, so the merge needs to be checked carefully.

## 11.0 Connection to Hybrid-Work Research

This project is inspired by research on hybrid work, turnover, and promotions. Those papers often use internal firm data to directly observe promotions and retention.

This project uses public labor-market data instead. It studies wage growth as a proxy for career advancement rather than internal promotions.

## 12.0 Lessons Learned

Public data can still be used to study career advancement questions when private company data are unavailable.

Occupation-level remote-workability measures are useful, but the occupation-code merge is important.

Log wage regressions are helpful because the results can be read approximately as percent differences.

## 13.0 Next Steps

Add `usa_00001.dta` to `data/raw/` or `code/`.

Add `occupations_workathome.csv` to `data/raw/remote/`.

Run the Stata do-files in order.

Check the merge results from `tab _merge`.

Update this README with the actual regression result after the code runs.
