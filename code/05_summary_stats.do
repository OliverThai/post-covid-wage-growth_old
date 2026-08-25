********************************************************************************
* 05_summary_stats.do
* Summary statistics
********************************************************************************

clear all
set more off

use "data/processed/analysis_data.dta", clear

* Basic checks in the Stata results window.
count
sum hourly_wage log_wage age
tab year
tab covid
tab remote_workable
tab covid remote_workable

* Save a simple log of summary statistics.
log using "outputs/tables/summary_stats.txt", text replace

count
sum hourly_wage log_wage age
tab year
tab covid
tab remote_workable
tab covid remote_workable

log close

di "Saved summary stats to outputs/tables/summary_stats.txt"
