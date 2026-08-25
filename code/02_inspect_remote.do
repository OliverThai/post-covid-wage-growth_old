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

di "This file uses onetsoccode and teleworkable."
di "ACS uses occ, so a Census occ to SOC crosswalk is needed before merging."
