********************************************************************************
* 07_figures.do
* Create wage trend figures for remote-workable vs less remote-workable jobs.
********************************************************************************

version 16
set more off

capture confirm file "$PROCESSED/analysis_data.dta"
if _rc {
    di as error "Missing analysis data. Run 04_merge_data.do first."
    exit 601
}

use "$PROCESSED/analysis_data.dta", clear

collapse (mean) mean_log_wage=log_wage mean_hourly_wage=hourly_wage [pw=weight], ///
    by(year remote_workable)

label define remote_lbl 0 "Less remote-workable" 1 "Remote-workable", replace
label values remote_workable remote_lbl

twoway ///
    (line mean_log_wage year if remote_workable == 1, lcolor(navy) lwidth(medthick)) ///
    (line mean_log_wage year if remote_workable == 0, lcolor(maroon) lwidth(medthick)), ///
    legend(order(1 "Remote-workable" 2 "Less remote-workable") position(6) rows(1)) ///
    xtitle("Year") ytitle("Mean log hourly wage") ///
    title("Wage Trends by Occupation Remote-Workability") ///
    graphregion(color(white)) bgcolor(white)
graph export "$FIGURES/wage_trends_log_wage.png", replace width(1800)
graph export "$FIGURES/wage_trends_log_wage.pdf", replace

twoway ///
    (line mean_hourly_wage year if remote_workable == 1, lcolor(navy) lwidth(medthick)) ///
    (line mean_hourly_wage year if remote_workable == 0, lcolor(maroon) lwidth(medthick)), ///
    legend(order(1 "Remote-workable" 2 "Less remote-workable") position(6) rows(1)) ///
    xtitle("Year") ytitle("Mean hourly wage") ///
    title("Hourly Wage Trends by Occupation Remote-Workability") ///
    graphregion(color(white)) bgcolor(white)
graph export "$FIGURES/wage_trends_hourly_wage.png", replace width(1800)
graph export "$FIGURES/wage_trends_hourly_wage.pdf", replace

di as result "Saved figures to $FIGURES"
