Raw data files expected by this project
========================================

1. ACS/IPUMS labor microdata

   Expected file:
   code/usa_00001.dta

   Include these IPUMS variables:
   YEAR, AGE, SEX, RACE, EDUC, EMPSTAT, OCC, IND, STATEFIP,
   INCWAGE, UHRSWORK, WKSWORK1, PERWT.

2. Dingel-Neiman occupation remote-workability data

   Expected file:
   data/raw/remote/occupations_workathome.csv

   Run code/02_inspect_remote.do first to identify the occupation-code
   variable and remote-workability variable. Then update the macros in
   code/03_clean_remote.do if the automatic guesses are wrong.

The scripts stop rather than fake results when these files are missing.
