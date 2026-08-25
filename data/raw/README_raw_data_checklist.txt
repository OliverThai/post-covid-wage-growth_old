Raw data checklist
==================

Put the ACS/IPUMS Stata file here:

data/raw/usa_00001.dta

The cleaning script can also use this location:

code/usa_00001.dta

Put the Dingel-Neiman remote-workability CSV here:

data/raw/remote/occupations_workathome.csv

Because that file uses SOC occupation codes, also add a crosswalk here:

data/raw/remote/occ_soc_crosswalk.csv

The crosswalk should have two columns:

occ
onetsoccode

The scripts will not create fake results if these files are missing.
