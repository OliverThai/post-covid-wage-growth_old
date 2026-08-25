********************************************************************************
* 02_inspect_remote.do
* Inspect Dingel-Neiman remote-workability occupation data.
*
* Input:
*   data/raw/remote/occupations_workathome.csv
*
* This script helps you identify the occupation-code variable and the
* remote-workability variable before running 03_clean_remote.do.
********************************************************************************

clear all
set more off
version 16

global ROOT "`c(pwd)'"
global REMOTE_RAW "$ROOT/data/raw/remote"
global NOTES "$ROOT/notes"

capture mkdir "$NOTES"

capture confirm file "$REMOTE_RAW/occupations_workathome.csv"
if _rc {
    di as error "Cannot find data/raw/remote/occupations_workathome.csv."
    di as error "Download Dingel-Neiman occupations_workathome.csv and place it in data/raw/remote/."
    exit 601
}

import delimited "$REMOTE_RAW/occupations_workathome.csv", clear varnames(1) case(lower) stringcols(_all)

describe
list in 1/20
summ

* These commands print variable names to the Results window.
* Look for one occupation-code variable and one work-from-home feasibility variable.
ds

* Save a simple note reminding the user what to check.
capture file close remote_notes
file open remote_notes using "$NOTES/remote_variable_notes.txt", write replace
file write remote_notes "After running 02_inspect_remote.do, identify:" _n
file write remote_notes "1. The occupation-code variable that should match IPUMS occ." _n
file write remote_notes "2. The remote-workability variable, usually coded 0/1 or 0-1." _n
file write remote_notes "Then edit the local macros at the top of code/03_clean_remote.do if needed." _n
file close remote_notes

di as text "Inspection complete. See notes/remote_variable_notes.txt."
