********************************************************************************
* 07_regressions.do
* Run difference-in-differences style wage regressions.
*
* Input:
*   data/processed/analysis_data.dta
*
* Outputs:
*   outputs/tables/regression_results.txt
*   outputs/tables/reg_*.ster
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

* Make sure categorical variables are numeric for Stata factor-variable notation.
foreach var in remote_workable post educ sex race statefip year ind {
    capture destring `var', replace
}

* The coefficient of interest in each model is:
*   1.remote_workable#1.post
*
* Because the outcome is log hourly wage, this coefficient can be interpreted
* approximately as a percent wage difference. For example, a coefficient of
* 0.05 is roughly a 5 percent difference in post-COVID wage growth for workers
* in remote-workable occupations relative to less remote-workable occupations.

capture log close regressions
log using "$TABLES/regression_results.txt", text replace name(regressions)

di as text "Regression 1: Basic DiD-style regression"
reg log_wage i.remote_workable##i.post [pw=perwt], robust
estimates store reg1_basic
estimates save "$TABLES/reg1_basic.ster", replace

di as text "Regression 2: Add demographic controls"
reg log_wage i.remote_workable##i.post age age2 i.educ i.sex i.race [pw=perwt], robust
estimates store reg2_demographics
estimates save "$TABLES/reg2_demographics.ster", replace

di as text "Regression 3: Add state and year fixed effects"
reg log_wage i.remote_workable##i.post age age2 i.educ i.sex i.race ///
    i.statefip i.year [pw=perwt], robust
estimates store reg3_state_year_fe
estimates save "$TABLES/reg3_state_year_fe.ster", replace

di as text "Regression 4: Add industry controls"
reg log_wage i.remote_workable##i.post age age2 i.educ i.sex i.race ///
    i.statefip i.year i.ind [pw=perwt], robust
estimates store reg4_industry
estimates save "$TABLES/reg4_industry.ster", replace

log close regressions

* If esttab is installed, also export a cleaner table.
capture which esttab
if !_rc {
    esttab reg1_basic reg2_demographics reg3_state_year_fe reg4_industry ///
        using "$TABLES/regression_table.rtf", replace ///
        se star(* 0.10 ** 0.05 *** 0.01) ///
        keep(1.remote_workable#1.post) ///
        title("Remote-Workability and Post-COVID Wage Growth") ///
        addnotes("Outcome is log hourly wage.", ///
                 "Key coefficient: remote_workable x post.", ///
                 "A coefficient of 0.05 is approximately 5 percent.")
}
else {
    di as text "esttab is not installed, so regression_table.rtf was not created."
    di as text "The text log and .ster estimate files were still saved."
}

di as result "Saved regression outputs to outputs/tables/"
