* 02_analysis.do
* Summary stats, regressions, and data for R figures

clear all
set more off

global project "/Users/ollie1/Documents/New project/remote-work-career-project"
cd "$project"

use "data/processed/analysis_data.dta", clear

* Summary statistics

log using "outputs/tables/summary_stats.txt", text replace

count
sum hourly_wage log_wage age
tab year
tab covid
tab remote_workable
tab covid remote_workable
tab race
tab age_group

log close

* Make small files for the R figure script

preserve

collapse (mean) hourly_wage log_wage [pw=perwt], by(year remote_workable)

export delimited using "data/processed/wage_trends_for_r.csv", replace

restore

preserve

collapse (mean) hourly_wage log_wage [pw=perwt], by(year race)

export delimited using "data/processed/race_trends_for_r.csv", replace

restore

preserve

collapse (mean) hourly_wage log_wage [pw=perwt], by(year age_group)

export delimited using "data/processed/age_trends_for_r.csv", replace

restore

* Regressions

log using "outputs/tables/regressions.txt", text replace

* Main post-COVID wage regression.
* The coefficient on 1.covid shows the average wage difference after 2020.

reg log_wage i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

* Remote-workability regression.
* Main coefficient to look at:
* 1.remote_workable#1.covid
*
* Since the outcome is log_wage, a coefficient of 0.05 is about 5 percent.

reg log_wage i.remote_workable##i.covid [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.year i.ind [pw=perwt], robust

reg log_wage c.remote_score##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.year i.ind [pw=perwt], robust

* Heterogeneity by race and age group.

reg log_wage i.race##i.covid age age2 i.educ i.sex ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.age_group##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

log close

* Figures in R

* This runs the R figure script.
* The full Rscript path is used because Stata may not know where R is on Mac.

shell "/usr/local/bin/Rscript" "code/03_figures.R" "$project"

di "Analysis complete."
