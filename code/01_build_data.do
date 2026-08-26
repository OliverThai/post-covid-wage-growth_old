* 01_build_data.do
* Clean ACS, clean remote-work data, and merge everything together

clear all
set more off

global project "/Users/ollie1/Documents/New project/remote-work-career-project"
cd "$project"

* Clean ACS/IPUMS data

use "data/raw/usa_00001.dta", clear

capture rename *, lower

keep if empstat == 1
keep if !missing(age) & age >= 25 & age <= 54

keep if !missing(incwage) & incwage > 0
keep if !missing(wkswork1) & wkswork1 > 0
keep if !missing(uhrswork) & uhrswork > 0

gen hourly_wage = incwage / (uhrswork * wkswork1)

sum hourly_wage
local mean = r(mean)
local sd = r(sd)
drop if hourly_wage > `mean' + (2 * `sd')
drop if hourly_wage < `mean' - (2 * `sd')

gen covid = year > 2020
gen log_wage = log(hourly_wage)
gen age2 = age^2

count
sum hourly_wage log_wage age
tab year
tab covid

save "data/processed/cleaned.dta", replace

* Clean Dingel-Neiman remote-workability data

import delimited "data/raw/remote/occupations_workathome.csv", clear varnames(1)

rename onetsoccode soc
rename teleworkable remote_workable

keep soc remote_workable
drop if missing(soc)
drop if missing(remote_workable)
duplicates drop

save "data/processed/remote_soc_only.dta", replace

* Crosswalk SOC codes to ACS occupation codes

* The Dingel-Neiman file uses SOC codes.
* The ACS file uses Census occupation codes called occ.
* This file must have: occ and onetsoccode.

import delimited "data/raw/remote/occ_soc_crosswalk.csv", clear varnames(1)

rename onetsoccode soc

keep occ soc
drop if missing(occ)
drop if missing(soc)

merge m:1 soc using "data/processed/remote_soc_only.dta"
tab _merge

keep if _merge == 3
drop _merge

collapse (mean) remote_workable, by(occ)
replace remote_workable = remote_workable >= .5

save "data/processed/remote_clean.dta", replace

* Merge ACS with remote-workability data

use "data/processed/cleaned.dta", clear

merge m:1 occ using "data/processed/remote_clean.dta"
tab _merge

keep if _merge == 3
drop _merge

save "data/processed/analysis_data.dta", replace

di "Saved final data to data/processed/analysis_data.dta"
