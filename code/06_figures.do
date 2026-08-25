********************************************************************************
* 06_figures.do
* Wage trend graph
********************************************************************************

clear all
set more off

use "data/processed/analysis_data.dta", clear

* Average hourly wages by year and remote-workability group.
collapse (mean) hourly_wage [pw=perwt], by(year remote_workable)

twoway ///
    (line hourly_wage year if remote_workable == 1, lcolor(blue)) ///
    (line hourly_wage year if remote_workable == 0, lcolor(red)), ///
    title("Wage Trends by Remote-Workability") ///
    xtitle("Year") ///
    ytitle("Average hourly wage") ///
    legend(order(1 "Remote-workable" 2 "Less remote-workable"))

graph export "outputs/figures/wage_trends.png", replace

di "Saved graph to outputs/figures/wage_trends.png"
