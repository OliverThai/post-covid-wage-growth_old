********************************************************************************
* 00_setup.do
* Project setup for:
* "The Remote Work Wage Premium: Post-COVID Wage Growth in
*  Remote-Workable Occupations"
*
* Run this first, or run each numbered do-file in order.
********************************************************************************

clear all
set more off
version 16

* This project uses relative paths. Start Stata in the project folder:
* cd "/Users/ollie1/Documents/New project/remote-work-career-project"

global ROOT "`c(pwd)'"
global CODE "$ROOT/code"
global RAW "$ROOT/data/raw"
global REMOTE_RAW "$ROOT/data/raw/remote"
global PROCESSED "$ROOT/data/processed"
global TABLES "$ROOT/outputs/tables"
global FIGURES "$ROOT/outputs/figures"
global NOTES "$ROOT/notes"

foreach folder in "$CODE" "$RAW" "$REMOTE_RAW" "$PROCESSED" "$TABLES" "$FIGURES" "$NOTES" {
    capture mkdir "`folder'"
}

di as result "Project folders checked/created."
di as text "Project root: $ROOT"

* Check whether the key raw input files are present.
capture confirm file "$CODE/usa_00001.dta"
if _rc {
    di as error "Missing ACS/IPUMS file: code/usa_00001.dta"
    di as text "Put your IPUMS Stata file there before running 01_clean_acs.do."
}
else {
    di as result "Found ACS/IPUMS file: code/usa_00001.dta"
}

capture confirm file "$REMOTE_RAW/occupations_workathome.csv"
if _rc {
    di as error "Missing Dingel-Neiman file: data/raw/remote/occupations_workathome.csv"
    di as text "Put occupations_workathome.csv there before running 02_inspect_remote.do."
}
else {
    di as result "Found remote-workability file: data/raw/remote/occupations_workathome.csv"
}

di as text "Setup finished."
