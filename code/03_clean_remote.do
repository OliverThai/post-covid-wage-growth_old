********************************************************************************
* 03_clean_remote.do
* Clean the Dingel-Neiman remote-workability data
********************************************************************************

clear all
set more off

capture confirm file "data/raw/remote/occupations_workathome.csv"
if _rc {
    di as error "Missing data/raw/remote/occupations_workathome.csv"
    exit 601
}

import delimited "data/raw/remote/occupations_workathome.csv", clear varnames(1)

* The actual Dingel-Neiman file has:
*   onetsoccode = SOC occupation code
*   teleworkable = 0/1 remote-workability measure

rename onetsoccode soc
rename teleworkable remote_workable

keep soc remote_workable
drop if missing(soc)
drop if missing(remote_workable)
duplicates drop

save "data/processed/remote_soc_only.dta", replace

* ACS uses Census occupation codes called occ.
* Dingel-Neiman uses SOC codes.
* Those codes do not match directly, so we need a crosswalk.
capture confirm file "data/raw/remote/occ_soc_crosswalk.csv"
if _rc {
    di as error "The remote-workability file uses SOC codes, but ACS uses Census occ codes."
    di as error "Add a crosswalk file here: data/raw/remote/occ_soc_crosswalk.csv"
    di as error "The crosswalk should have two columns: occ and onetsoccode"
    di as error "I saved data/processed/remote_soc_only.dta, but cannot create remote_clean.dta yet."
    exit 601
}

tempfile remote_soc
save `remote_soc'

import delimited "data/raw/remote/occ_soc_crosswalk.csv", clear varnames(1)

capture rename onetsoccode soc
capture rename soccode soc
capture rename soc_code soc
capture rename occ_code occ

keep if !missing(occ)
keep if !missing(soc)

merge m:1 soc using `remote_soc'
tab _merge
keep if _merge == 3
drop _merge

keep occ remote_workable

* Some Census occ codes can match multiple SOC codes.
* Take the average and turn it back into a 0/1 indicator.
collapse (mean) remote_workable, by(occ)
replace remote_workable = remote_workable >= .5

save "data/processed/remote_clean.dta", replace

di "Saved remote-workability data to data/processed/remote_clean.dta"
