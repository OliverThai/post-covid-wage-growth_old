********************************************************************************
* 02_inspect_remote.do
* Look at the Dingel-Neiman remote-workability file
********************************************************************************

clear all
set more off

capture confirm file "data/raw/remote/occupations_workathome.csv"
if _rc {
    di as error "Missing data/raw/remote/occupations_workathome.csv"
    exit 601
}

import delimited "data/raw/remote/occupations_workathome.csv", clear varnames(1)

describe
list in 1/20
summarize

di "Look for the occupation code variable and the remote-workability variable."
di "Then edit 03_clean_remote.do if the variable names are different."
