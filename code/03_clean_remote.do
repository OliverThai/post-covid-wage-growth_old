********************************************************************************
* 03_clean_remote.do
* Clean Dingel-Neiman remote-workability occupation data.
*
* Input:
*   data/raw/remote/occupations_workathome.csv
*
* Output:
*   data/processed/remote_clean.dta
********************************************************************************

clear all
set more off
version 16

global ROOT "`c(pwd)'"
global REMOTE_RAW "$ROOT/data/raw/remote"
global PROCESSED "$ROOT/data/processed"

capture mkdir "$PROCESSED"

capture confirm file "$REMOTE_RAW/occupations_workathome.csv"
if _rc {
    di as error "Cannot find data/raw/remote/occupations_workathome.csv."
    di as error "Run 02_inspect_remote.do after placing the CSV in data/raw/remote/."
    exit 601
}

import delimited "$REMOTE_RAW/occupations_workathome.csv", clear varnames(1) case(lower) stringcols(_all)

* If these guesses are wrong, run 02_inspect_remote.do and edit these macros.
local occ_var ""
local remote_var ""

foreach candidate in occ occ2010 occupation occupation_code soc soccode soc_code {
    capture confirm variable `candidate'
    if !_rc & "`occ_var'" == "" {
        local occ_var "`candidate'"
    }
}

foreach candidate in remote_workable workathome teleworkable wfh_score remote_score home {
    capture confirm variable `candidate'
    if !_rc & "`remote_var'" == "" {
        local remote_var "`candidate'"
    }
}

if "`occ_var'" == "" {
    di as error "Could not automatically identify the occupation-code variable."
    di as error "Run 02_inspect_remote.do, then edit local occ_var in 03_clean_remote.do."
    describe
    exit 111
}

if "`remote_var'" == "" {
    di as error "Could not automatically identify the remote-workability variable."
    di as error "Run 02_inspect_remote.do, then edit local remote_var in 03_clean_remote.do."
    describe
    exit 111
}

di as text "Using occupation variable: `occ_var'"
di as text "Using remote-workability variable: `remote_var'"

rename `occ_var' occ
rename `remote_var' remote_workable

destring occ, replace ignore(" -.")
destring remote_workable, replace ignore("%, ")

drop if missing(occ, remote_workable)

* If the source uses percentages, rescale to 0-1.
summ remote_workable, meanonly
if r(max) > 1 {
    replace remote_workable = remote_workable / 100
}

* If the source is continuous, convert to a simple high/low indicator.
* Occupations at or above the median are coded remote-workable.
summ remote_workable, detail
local median_remote = r(p50)
replace remote_workable = (remote_workable >= `median_remote') if !missing(remote_workable)

keep occ remote_workable
collapse (mean) remote_workable, by(occ)
replace remote_workable = (remote_workable >= .5) if !missing(remote_workable)

label variable occ "Occupation code"
label variable remote_workable "Remote-workable occupation indicator"

save "$PROCESSED/remote_clean.dta", replace

di as result "Saved cleaned remote-workability data to data/processed/remote_clean.dta"
di as text "If later merge quality is poor, IPUMS occ and Dingel-Neiman occupation codes may need a crosswalk."
