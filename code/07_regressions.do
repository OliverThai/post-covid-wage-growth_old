********************************************************************************
* 07_regressions.do
* Difference-in-differences style regressions
********************************************************************************

clear all
set more off

use "data/processed/analysis_data.dta", clear

* Main coefficient to look at:
* 1.remote_workable#1.covid
*
* Since the outcome is log_wage, a coefficient of 0.05 is about 5 percent.

log using "outputs/tables/regressions.txt", text replace

* 1. Basic regression.
reg log_wage i.remote_workable##i.covid [pw=perwt], robust

* 2. Add basic demographics.
reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race [pw=perwt], robust

* 3. Add state and year fixed effects.
reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.statefip i.year [pw=perwt], robust

* 4. Add industry controls.
reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.statefip i.year i.ind [pw=perwt], robust

log close

di "Saved regression output to outputs/tables/regressions.txt"
