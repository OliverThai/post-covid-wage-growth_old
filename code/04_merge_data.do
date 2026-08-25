********************************************************************************
* 04_merge_data.do
* Merge labor microdata with occupation-level remote-workability scores.
********************************************************************************

version 16
set more off

capture confirm file "$PROCESSED/labor_clean.dta"
if _rc {
    di as error "Missing $PROCESSED/labor_clean.dta. Run 02_clean_acs_or_cps.do first."
    exit 601
}

capture confirm file "$PROCESSED/remote_scores_clean.dta"
if _rc {
    di as error "Missing $PROCESSED/remote_scores_clean.dta. Run 03_clean_remote_work_scores.do first."
    exit 601
}

use "$PROCESSED/labor_clean.dta", clear
merge m:1 occ_code using "$PROCESSED/remote_scores_clean.dta"

tab _merge
count if _merge == 1
if r(N) > 0 {
    di as text "Warning: some labor observations did not match remote-work scores."
    di as text "This usually means occupation coding systems differ and need a crosswalk."
}

keep if _merge == 3
drop _merge

compress
save "$PROCESSED/analysis_data.dta", replace

di as result "Saved analysis data to $PROCESSED/analysis_data.dta"
