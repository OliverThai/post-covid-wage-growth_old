# The Remote Work Wage Premium

A Stata economics project studying post-COVID wage growth in remote-workable occupations.

# The Remote Work Wage Premium

## 1.0 Research Problem

The COVID-19 pandemic changed how work is organized across the U.S. labor market. Some occupations could shift to remote or hybrid work much more easily than others. This project asks whether workers in remote-workable occupations experienced different wage growth after COVID compared to workers in less remote-workable occupations.

The goal is to build an independent economic consulting-style research project that uses public data, transparent cleaning steps, and a reproducible Stata workflow. Instead of using private firm records, the project uses ACS/IPUMS labor-market microdata and a public occupation-level remote-workability measure.

The main research question is:

**Did workers in remote-workable occupations experience different wage growth after COVID compared to workers in less remote-workable occupations?**

## 2.0 Research Assumptions

This project studies remote-workable occupations, not confirmed remote workers. ACS data do not directly show whether each individual worked remotely.

The remote-workability measure is assigned at the occupation level using Dingel-Neiman work-from-home feasibility data.

Hourly wage is constructed from annual wage income, usual weekly hours, and weeks worked:

```text
hourly_wage = INCWAGE / (UHRSWORK x WKSWORK1)
```

The post-COVID period is defined as:

```text
post = year >= 2021
```

The project keeps employed prime-age workers, ages 25 to 54.

## 3.0 Data Sources

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

The remote-workability dataset is Dingel and Neiman's occupation-level work-from-home feasibility data. The expected raw file is:

```text
data/raw/remote/occupations_workathome.csv
```

Important note: Dingel-Neiman occupation codes may not automatically match IPUMS `occ`. The merge script reports match quality. If the match rate is low, an occupation crosswalk may be needed.

## 4.0 Solution Strategy

The solution is organized as a sequence of beginner-readable Stata do-files. Each file handles one step of the research pipeline.

Step 01. Project Setup: Create the folder structure and check whether the expected raw data files exist.

Step 02. ACS Cleaning: Load `code/usa_00001.dta`, keep employed prime-age workers, construct hourly wages, trim wage outliers, create log wages, and save `data/processed/acs_clean.dta`.

Step 03. Remote Data Inspection: Import Dingel-Neiman's CSV, describe the file, list the first rows, and help identify the occupation-code and remote-workability variables.

Step 04. Remote Data Cleaning: Keep the occupation code and remote-workability indicator, clean them, and save `data/processed/remote_clean.dta`.

Step 05. Data Merge: Merge ACS workers to occupation-level remote-workability data using occupation codes and save `data/processed/analysis_data.dta`.

Step 06. Summary Statistics: Create overall and by-group summary tables.

Step 07. Figures: Create a wage-trend line graph comparing remote-workable and less remote-workable occupations over time.

Step 08. Regressions: Estimate difference-in-differences style wage regressions with progressively richer controls.

## 5.0 Method

The main empirical design is a difference-in-differences style comparison:

```text
log_wage_it = beta0
            + beta1 remote_workable_i
            + beta2 post_t
            + beta3 remote_workable_i * post_t
            + controls
            + error_it
```

The main coefficient of interest is:

```text
1.remote_workable#1.post
```

Because the outcome is log hourly wage, this coefficient can be interpreted approximately as a percent wage difference. For example, a coefficient of `0.05` is roughly 5 percent.

The regressions estimated are:

```stata
reg log_wage i.remote_workable##i.post [pw=perwt], robust

reg log_wage i.remote_workable##i.post age age2 i.educ i.sex i.race [pw=perwt], robust

reg log_wage i.remote_workable##i.post age age2 i.educ i.sex i.race ///
    i.statefip i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.post age age2 i.educ i.sex i.race ///
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

## 8.0 Expected Outputs

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

## 9.0 Results

Results are intentionally not filled in until the raw ACS/IPUMS file and Dingel-Neiman CSV are added and the do-files are run.

The main result will come from the coefficient:

```text
1.remote_workable#1.post
```

If the coefficient is positive, remote-workable occupations had higher post-COVID wage growth relative to less remote-workable occupations. If the coefficient is negative, they had lower relative wage growth.

## 10.0 Limitations

ACS does not directly measure whether a worker is remote, hybrid, or fully in person.

The analysis assigns remote-workability by occupation, so it captures differences across occupation types rather than individual remote-work arrangements.

Occupation-code matching between IPUMS and Dingel-Neiman may require a crosswalk.

The design is difference-in-differences style, but remote-workable and less remote-workable occupations may differ in education, industry, skill requirements, and labor-demand shocks.

## 11.0 Connection to Hybrid-Work Research

This project is inspired by research on hybrid work, turnover, and promotions, including papers such as “Balancing Turnover and Promotion Outcomes: Evidence on the Optimal Hybrid-Work Frequency.” Those studies often use internal firm data to directly observe promotions and retention.

This project uses public labor-market data instead. It studies wage growth as a proxy for career advancement rather than internal firm promotions. The benefit is that the project is transparent and reproducible; the tradeoff is that it cannot directly measure promotion outcomes.

## 12.0 Lessons Learned

Public labor-market data can be used to study career advancement questions when private firm data are unavailable.

Occupation-level measures can help connect job characteristics to worker outcomes, but careful merging and code harmonization are essential.

Log wage regressions are useful because coefficients can be interpreted approximately as percentage differences.

## 13.0 Next Steps

Add the raw ACS/IPUMS file to `code/usa_00001.dta`.

Add Dingel-Neiman's `occupations_workathome.csv` to `data/raw/remote/`.

Run the full Stata workflow and review the merge quality.

If the merge quality is low, add an occupation-code crosswalk.

After results are generated, update the Results section with the main coefficient, wage trend figure, and interpretation.
