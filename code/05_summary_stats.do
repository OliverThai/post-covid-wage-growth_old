********************************************************************************
* 05_summary_stats.do
* Create simple summary statistics for the final analysis dataset.
*
* Input:
*   data/processed/analysis_data.dta
*
* Outputs:
*   outputs/tables/summary_overall.csv
*   outputs/tables/summary_by_remote.csv
********************************************************************************

clear all
set more off
version 16

global ROOT "`c(pwd)'"
global PROCESSED "$ROOT/data/processed"
global TABLES "$ROOT/outputs/tables"

capture mkdir "$TABLES"

capture confirm file "$PROCESSED/analysis_data.dta"
if _rc {
    di as error "Missing data/processed/analysis_data.dta. Run code/04_merge.do first."
    exit 601
}

use "$PROCESSED/analysis_data.dta", clear

* Overall summary table.
preserve
collapse ///
    (count) n=log_wage ///
    (mean) hourly_wage log_wage age remote_workable ///
    (sd) sd_hourly_wage=hourly_wage sd_log_wage=log_wage sd_age=age
export delimited using "$TABLES/summary_overall.csv", replace
restore

* Summary table by remote-workability status.
preserve
collapse ///
    (count) n=log_wage ///
    (mean) hourly_wage log_wage age ///
    (sd) sd_hourly_wage=hourly_wage sd_log_wage=log_wage sd_age=age, ///
    by(remote_workable)
export delimited using "$TABLES/summary_by_remote.csv", replace
restore

* Display helpful checks in the Results window.
tab year
tab remote_workable
tab post remote_workable
summ hourly_wage log_wage age

di as result "Saved summary tables to outputs/tables/"
