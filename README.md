# Remote Work and Career Advancement

## Research Question

Did workers in remote-workable occupations experience different wage growth after COVID compared with workers in less remote-workable occupations?

This is a Stata-first reproducible economics project. It uses public labor-market data, merges workers to occupation-level remote-workability scores, estimates difference-in-differences style regressions, and produces tables, figures, and a short research summary.

## Data Sources

### Labor-Market Microdata

Preferred source: [IPUMS USA](https://usa.ipums.org/usa/) ACS microdata or [IPUMS CPS](https://cps.ipums.org/cps/) CPS/ASEC microdata.

Suggested ACS extract:

- Years: 2015-2023, or the widest pre/post COVID span available.
- Variables: `YEAR`, `AGE`, `SEX`, `RACE`, `EDUC` or `EDUCD`, `STATEFIP`, `OCC` or `OCC2010`, `IND`, `PERWT`, `INCWAGE`, `UHRSWORK`, and `WKSWORK1` or `WKSWORK2`.

Suggested CPS extract:

- Years: pre- and post-COVID CPS ASEC or basic monthly data.
- Variables: `YEAR`, `AGE`, `SEX`, `RACE`, `EDUC` or `EDUCD`, `STATEFIP`, `OCC` or `OCC2010`, `IND`, `PERWT`, `EARNWEEK`, `UHRSWORKT`, and other wage/hours variables available in your extract.

Save the file as one of:

```text
data/raw/ipums_labor.dta
data/raw/ipums_labor.csv
```

### Remote-Workability Scores

Preferred source: Dingel and Neiman, “How Many Jobs Can be Done at Home?”, replication package:

[https://github.com/jdingel/DingelNeiman-workathome](https://github.com/jdingel/DingelNeiman-workathome)

Create a harmonized score file named:

```text
data/raw/remote_work_scores.csv
```

Required columns:

- `occ_code`: occupation code matching the IPUMS occupation code.
- `remote_score`: remote-workability score from 0 to 1. A 0-100 score is also accepted and rescaled.

Accepted alternatives:

- Occupation code: `occ_code`, `occ2010`, or `occ`.
- Score: `remote_score`, `wfh_score`, or `teleworkable`.

Important: Dingel-Neiman files are often SOC-based, while IPUMS ACS/CPS may use Census occupation codes. If the merge rate is poor, add a public SOC-to-Census occupation crosswalk and create `remote_work_scores.csv` at the same occupation level as the IPUMS extract.

## How to Run

Open Stata, change directory to the project folder, and run:

```stata
cd "path/to/remote-work-career-project"
do code/00_master.do
```

The master file runs the full workflow:

1. setup and package checks,
2. labor data cleaning,
3. remote-workability score cleaning,
4. merge,
5. summary statistics,
6. regressions,
7. figures.

If raw files are missing, the scripts stop with a clear error message and do not create fake results.

## Empirical Strategy

The main regression is:

```text
log_wage_it = beta0
            + beta1 remote_workable_i
            + beta2 post_t
            + beta3 remote_workable_i * post_t
            + controls
            + error_it
```

The main Stata specification is:

```stata
reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight], ///
    vce(cluster occ_code)
```

The key coefficient is:

```text
1.remote_workable#1.post2020
```

This coefficient estimates whether wages changed differently after COVID for workers in remote-workable occupations compared with workers in less remote-workable occupations, conditional on the included controls and fixed effects.

## Outputs

Tables are saved to:

```text
outputs/tables/
```

Figures are saved to:

```text
outputs/figures/
```

Expected outputs:

- `summary_stats_overall.csv`
- `summary_stats_by_remote.csv`
- `main_regression_table.rtf` if `esttab` is available
- `heterogeneity_table.rtf` if `esttab` is available
- stored Stata estimates as `.ster`
- wage trend figures as `.png` and `.pdf`

## Heterogeneity and Robustness

The regression script includes:

- college vs non-college workers,
- younger vs older workers,
- women vs men,
- continuous remote-workability score,
- post-2020 and post-2021 definitions,
- prime-age restriction, ages 25-54.

## Connection to Hybrid-Work and Promotion Research

This project is inspired by papers on hybrid work, turnover, and promotions, including Cornell-style work such as “Balancing Turnover and Promotion Outcomes: Evidence on the Optimal Hybrid-Work Frequency.” Those papers often use internal firm data to study promotions and retention directly.

This project uses public labor-market data instead. It studies wage growth as a proxy for career advancement rather than internal firm promotions. That makes the analysis reproducible with public data, but it also means the results should be interpreted as evidence on broad wage changes, not direct promotion outcomes.

## Research Notes

- The scripts are conservative: they stop when required raw data are missing.
- The occupation-code merge is the main practical challenge.
- ACS hourly wages constructed from annual earnings, usual hours, and weeks worked are approximate.
- For a polished paper, refine the sample to wage and salary workers and document any wage trimming choices.
