********************************************************************************
* 04_merge.do
* Merge cleaned ACS data with occupation-level remote-workability data.
*
* Inputs:
*   data/processed/acs_clean.dta
*   data/processed/remote_clean.dta
*
* Output:
*   data/processed/analysis_data.dta
********************************************************************************

clear all
set more off
version 16

global ROOT "`c(pwd)'"
global PROCESSED "$ROOT/data/processed"

capture confirm file "$PROCESSED/acs_clean.dta"
if _rc {
    di as error "Missing data/processed/acs_clean.dta. Run code/01_clean_acs.do first."
    exit 601
}

capture confirm file "$PROCESSED/remote_clean.dta"
if _rc {
    di as error "Missing data/processed/remote_clean.dta. Run code/03_clean_remote.do first."
    exit 601
}

use "$PROCESSED/acs_clean.dta", clear

* Make sure occupation is numeric in the ACS data.
capture destring occ, replace

merge m:1 occ using "$PROCESSED/remote_clean.dta"

* Diagnostic: check how many ACS observations matched to remote-workability data.
tab _merge

count if _merge == 3
local matched = r(N)
count
local total = r(N)
local match_rate = 100 * `matched' / `total'
di as text "Occupation-code match rate: " %6.2f `match_rate' "%"

if `match_rate' < 80 {
    di as error "Warning: merge quality is low."
    di as text "IPUMS occ may not use the same occupation coding as Dingel-Neiman."
    di as text "A public occupation crosswalk may be needed before interpreting results."
}

keep if _merge == 3
drop _merge

save "$PROCESSED/analysis_data.dta", replace

di as result "Saved merged analysis data to data/processed/analysis_data.dta"
