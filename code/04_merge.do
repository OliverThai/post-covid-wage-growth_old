********************************************************************************
* 04_merge.do
* Merge ACS data with remote-workability data
********************************************************************************

clear all
set more off

use "data/processed/cleaned.dta", clear

merge m:1 occ using "data/processed/remote_clean.dta"

* This tells us how well the occupation codes matched.
tab _merge

keep if _merge == 3
drop _merge

save "data/processed/analysis_data.dta", replace

di "Saved final analysis data to data/processed/analysis_data.dta"
