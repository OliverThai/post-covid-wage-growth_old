********************************************************************************
* 02_analysis.do
* Summary stats, figure, and regressions
********************************************************************************

clear all
set more off

global project "/Users/ollie1/Documents/New project/remote-work-career-project"
cd "$project"

use "data/processed/analysis_data.dta", clear

********************************************************************************
* Summary statistics
********************************************************************************

log using "outputs/tables/summary_stats.txt", text replace

count
sum hourly_wage log_wage age
tab year
tab covid
tab remote_workable
tab covid remote_workable

log close

********************************************************************************
* Wage trend figure
********************************************************************************

preserve

collapse (mean) hourly_wage [pw=perwt], by(year remote_workable)

twoway ///
    (line hourly_wage year if remote_workable == 1, lcolor(blue)) ///
    (line hourly_wage year if remote_workable == 0, lcolor(red)), ///
    title("Wage Trends by Remote-Workability") ///
    xtitle("Year") ///
    ytitle("Average hourly wage") ///
    legend(order(1 "Remote-workable" 2 "Less remote-workable"))

graph export "outputs/figures/wage_trends.png", replace

restore

********************************************************************************
* Regressions
********************************************************************************

log using "outputs/tables/regressions.txt", text replace

* Main coefficient to look at:
* 1.remote_workable#1.covid
*
* Since the outcome is log_wage, a coefficient of 0.05 is about 5 percent.

reg log_wage i.remote_workable##i.covid [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex ///
    i.stateicp i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex ///
    i.stateicp i.year i.ind [pw=perwt], robust

log close

di "Analysis complete."
