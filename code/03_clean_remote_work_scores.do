********************************************************************************
* 03_clean_remote_work_scores.do
* Clean occupation-level remote-workability scores.
*
* Expected input:
*   data/raw/remote_work_scores.csv
*
* Required columns:
*   occ_code
*   remote_score OR wfh_score
********************************************************************************

version 16
set more off

local remote_csv "$RAW/remote_work_scores.csv"

capture confirm file "`remote_csv'"
if _rc {
    di as error "Missing remote-workability score file."
    di as error "Place data/raw/remote_work_scores.csv in the project."
    di as error "Required columns: occ_code and remote_score or wfh_score."
    di as error "Dingel-Neiman source: https://github.com/jdingel/DingelNeiman-workathome"
    exit 601
}

import delimited using "`remote_csv'", clear varnames(1) case(lower) stringcols(_all)

capture confirm variable occ_code
if _rc {
    capture confirm variable occ2010
    if !_rc rename occ2010 occ_code
}
capture confirm variable occ_code
if _rc {
    capture confirm variable occ
    if !_rc rename occ occ_code
}
capture confirm variable occ_code
if _rc {
    di as error "Remote score file must include occ_code, occ2010, or occ."
    exit 111
}

capture confirm variable remote_score
if _rc {
    capture confirm variable wfh_score
    if !_rc rename wfh_score remote_score
}
capture confirm variable remote_score
if _rc {
    capture confirm variable teleworkable
    if !_rc rename teleworkable remote_score
}
capture confirm variable remote_score
if _rc {
    di as error "Remote score file must include remote_score, wfh_score, or teleworkable."
    exit 111
}

destring occ_code, replace ignore(" -.")
destring remote_score, replace ignore("%, ")

drop if missing(occ_code, remote_score)

summ remote_score, meanonly
if r(max) > 1 {
    replace remote_score = remote_score / 100
}

collapse (mean) remote_score, by(occ_code)
summ remote_score, detail
local median_score = r(p50)

gen remote_workable = (remote_score >= `median_score') if !missing(remote_score)
label variable remote_score "Occupation remote-workability score"
label variable remote_workable "Remote-workable occupation, above median score"

compress
save "$PROCESSED/remote_scores_clean.dta", replace

di as result "Saved cleaned remote-workability scores to $PROCESSED/remote_scores_clean.dta"
