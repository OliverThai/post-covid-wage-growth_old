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

* IMPORTANT:
* After running 02_inspect_remote.do, change these names if needed.
*
* The final cleaned file needs:
*   occ = occupation code
*   remote_workable = 0/1 remote-workable occupation indicator

capture rename occ_code occ
capture rename occ2010 occ
capture rename occupation_code occ

capture rename remote_score remote_workable
capture rename wfh_score remote_workable
capture rename teleworkable remote_workable
capture rename workathome remote_workable

capture confirm variable occ
if _rc {
    di as error "Could not find occupation variable. Rename it to occ in this do-file."
    describe
    exit 111
}

capture confirm variable remote_workable
if _rc {
    di as error "Could not find remote-workability variable. Rename it to remote_workable in this do-file."
    describe
    exit 111
}

destring occ, replace ignore(" -.")
destring remote_workable, replace ignore("%, ")

keep if !missing(occ)
keep if !missing(remote_workable)

* If remote_workable is a 0-100 score, change it to 0-1.
replace remote_workable = remote_workable / 100 if remote_workable > 1

* If it is still a continuous score, make a simple above-median indicator.
sum remote_workable, detail
local median = r(p50)
replace remote_workable = remote_workable >= `median'

keep occ remote_workable

* Make sure there is only one row per occupation.
collapse (mean) remote_workable, by(occ)
replace remote_workable = remote_workable >= .5

save "data/processed/remote_clean.dta", replace

di "Saved remote-workability data to data/processed/remote_clean.dta"
