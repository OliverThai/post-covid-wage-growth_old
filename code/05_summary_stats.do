********************************************************************************
* 05_summary_stats.do
* Produce summary statistics tables.
********************************************************************************

version 16
set more off

capture confirm file "$PROCESSED/analysis_data.dta"
if _rc {
    di as error "Missing analysis data. Run 04_merge_data.do first."
    exit 601
}

use "$PROCESSED/analysis_data.dta", clear

preserve
collapse ///
    (count) n=log_wage ///
    (mean) log_wage hourly_wage age college female remote_score ///
    (sd) sd_log_wage=log_wage sd_hourly_wage=hourly_wage sd_age=age, ///
    by(remote_workable)
export delimited using "$TABLES/summary_stats_by_remote.csv", replace
restore

preserve
collapse ///
    (count) n=log_wage ///
    (mean) log_wage hourly_wage age college female remote_score
export delimited using "$TABLES/summary_stats_overall.csv", replace
restore

di as result "Saved summary statistics to $TABLES"
