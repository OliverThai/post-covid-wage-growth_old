********************************************************************************
* 06_figures.do
* Create wage trend figure by remote-workability status.
*
* Input:
*   data/processed/analysis_data.dta
*
* Output:
*   outputs/figures/wage_trends.png
********************************************************************************

clear all
set more off
version 16

global ROOT "`c(pwd)'"
global PROCESSED "$ROOT/data/processed"
global FIGURES "$ROOT/outputs/figures"

capture mkdir "$FIGURES"

capture confirm file "$PROCESSED/analysis_data.dta"
if _rc {
    di as error "Missing data/processed/analysis_data.dta. Run code/04_merge.do first."
    exit 601
}

use "$PROCESSED/analysis_data.dta", clear

* Weighted average hourly wage by year and remote-workability group.
collapse (mean) hourly_wage [pw=perwt], by(year remote_workable)

label define remote_label 0 "Less remote-workable" 1 "Remote-workable", replace
label values remote_workable remote_label

twoway ///
    (line hourly_wage year if remote_workable == 1, lcolor(navy) lwidth(medthick)) ///
    (line hourly_wage year if remote_workable == 0, lcolor(maroon) lwidth(medthick)), ///
    title("Hourly Wage Trends by Remote-Workability") ///
    xtitle("Year") ///
    ytitle("Weighted average hourly wage") ///
    legend(order(1 "Remote-workable" 2 "Less remote-workable") position(6) rows(1)) ///
    graphregion(color(white)) bgcolor(white)

graph export "$FIGURES/wage_trends.png", replace width(1800)

di as result "Saved wage trend figure to outputs/figures/wage_trends.png"
