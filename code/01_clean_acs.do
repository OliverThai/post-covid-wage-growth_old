********************************************************************************
* 01_clean_acs.do
* Clean the ACS/IPUMS data and create hourly wages
********************************************************************************

clear all
set more off

* This project expects the ACS file in data/raw/.
* If you already put it in code/, this script will use that too.
capture confirm file "data/raw/usa_00001.dta"
if _rc == 0 {
    use "data/raw/usa_00001.dta", clear
}
else {
    capture confirm file "code/usa_00001.dta"
    if _rc {
        di as error "Could not find usa_00001.dta in data/raw/ or code/."
        exit 601
    }
    use "code/usa_00001.dta", clear
}

* Make variable names lowercase if needed.
capture rename *, lower

* Keep employed workers.
keep if empstat == 1

* Keep prime-age workers.
keep if !missing(age) & age >= 25 & age <= 54

* Keep valid wage, hours, and weeks worked.
keep if !missing(incwage) & incwage > 0
keep if !missing(wkswork1) & wkswork1 > 0
keep if !missing(uhrswork) & uhrswork > 0

* Create hourly wage.
gen hourly_wage = incwage / (uhrswork * wkswork1)

* Drop wage outliers using two standard deviations from the mean.
sum hourly_wage
local mean = r(mean)
local sd = r(sd)
drop if hourly_wage > `mean' + (2 * `sd')
drop if hourly_wage < `mean' - (2 * `sd')

* Main variables for the analysis.
gen covid = year > 2020
gen post = covid
gen log_wage = log(hourly_wage)
gen age2 = age^2

* Quick checks.
count
sum hourly_wage log_wage age
tab year
tab covid

save "data/processed/cleaned.dta", replace

di "Saved cleaned ACS data to data/processed/cleaned.dta"
