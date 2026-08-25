********************************************************************************
* 01_setup.do
* Create folders, check Stata packages, and write a raw-data checklist.
********************************************************************************

version 16
set more off

foreach d in "$RAW" "$PROCESSED" "$TABLES" "$FIGURES" {
    capture mkdir "`d'"
}

capture which esttab
if _rc {
    di as text "Package estout/esttab not found. Attempting SSC install..."
    capture ssc install estout, replace
    capture which esttab
    if _rc {
        di as error "esttab is unavailable. Regressions will still save .ster files."
        global HAS_ESTTAB 0
    }
    else global HAS_ESTTAB 1
}
else global HAS_ESTTAB 1

capture file close checklist
file open checklist using "$RAW/README_raw_data_checklist.txt", write replace
file write checklist "Raw data files expected by this project" _n
file write checklist "========================================" _n _n
file write checklist "1. IPUMS ACS or CPS labor microdata:" _n
file write checklist "   data/raw/ipums_labor.dta or data/raw/ipums_labor.csv" _n
file write checklist "   Include YEAR, AGE, SEX, RACE, EDUC/EDUCD, STATEFIP, OCC/OCC2010, IND, PERWT, and wage/hours variables." _n _n
file write checklist "2. Occupation remote-workability scores:" _n
file write checklist "   data/raw/remote_work_scores.csv" _n
file write checklist "   Required columns: occ_code and remote_score or wfh_score." _n
file write checklist "   Suggested source: https://github.com/jdingel/DingelNeiman-workathome" _n _n
file write checklist "The scripts stop rather than fake results when these files are missing." _n
file close checklist

di as result "Setup complete."
