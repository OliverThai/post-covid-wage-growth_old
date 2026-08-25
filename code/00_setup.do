********************************************************************************
* 00_setup.do
* Basic setup for the remote work wage project
********************************************************************************

clear all
set more off

* Go to the project folder first.
* This makes the rest of the file paths work.
cd "/Users/ollie1/Documents/New project/remote-work-career-project"

capture mkdir "data"
capture mkdir "data/raw"
capture mkdir "data/raw/remote"
capture mkdir "data/processed"
capture mkdir "outputs"
capture mkdir "outputs/tables"
capture mkdir "outputs/figures"
capture mkdir "notes"

di "Folders are ready."

* The ACS/IPUMS file can go in data/raw/ or code/.
capture confirm file "data/raw/usa_00001.dta"
if _rc {
    capture confirm file "code/usa_00001.dta"
    if _rc {
        di as error "Missing ACS file. Put usa_00001.dta in data/raw/ or code/."
    }
}

capture confirm file "data/raw/remote/occupations_workathome.csv"
if _rc {
    di as error "Missing remote-work file: data/raw/remote/occupations_workathome.csv"
}

di "Setup complete."
