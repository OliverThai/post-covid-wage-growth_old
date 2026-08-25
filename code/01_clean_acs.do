********************************************************************************
* 01_clean_acs.do
* Clean ACS/IPUMS data and construct hourly wages.
*
* Input:
*   code/usa_00001.dta
*
* Output:
*   data/processed/acs_clean.dta
********************************************************************************

clear all
set more off
version 16

global ROOT "`c(pwd)'"
global CODE "$ROOT/code"
global PROCESSED "$ROOT/data/processed"

capture mkdir "$PROCESSED"

capture confirm file "$CODE/usa_00001.dta"
if _rc {
    di as error "Cannot find code/usa_00001.dta."
    di as error "Move your IPUMS ACS Stata file into the code folder and rerun this script."
    exit 601
}

use "$CODE/usa_00001.dta", clear

* IPUMS files often arrive with uppercase names depending on export settings.
* Lowercase names make the rest of the code easier to read.
capture rename *, lower

* Keep employed workers only. In this extract, empstat == 1 means employed.
keep if empstat == 1

* Keep prime-age workers.
keep if !missing(age) & age >= 25 & age <= 54

* Keep observations with valid earnings, hours, and weeks worked.
keep if !missing(incwage) & incwage > 0
keep if !missing(uhrswork) & uhrswork > 0
keep if !missing(wkswork1) & wkswork1 > 0

* Construct hourly wage from annual wage income, usual hours, and weeks worked.
gen hourly_wage = incwage / (uhrswork * wkswork1)
label variable hourly_wage "Hourly wage = INCWAGE / (UHRSWORK * WKSWORK1)"

* Default outlier rule: trim at the 1st and 99th percentiles.
summ hourly_wage, detail
local p1 = r(p1)
local p99 = r(p99)
keep if !missing(hourly_wage) & hourly_wage >= `p1' & hourly_wage <= `p99'

* Option A, if you prefer fixed wage cutoffs instead:
* keep if !missing(hourly_wage) & hourly_wage >= 2 & hourly_wage <= 500

* Main analysis variables.
gen log_wage = log(hourly_wage)
label variable log_wage "Log hourly wage"

gen post = (year >= 2021) if !missing(year)
label variable post "Post-COVID period: year >= 2021"

gen age2 = age^2
label variable age2 "Age squared"

* Basic checks to make sure the cleaned sample looks sensible.
count
summ hourly_wage log_wage age
tab year
tab post

save "$PROCESSED/acs_clean.dta", replace

di as result "Saved cleaned ACS data to data/processed/acs_clean.dta"
