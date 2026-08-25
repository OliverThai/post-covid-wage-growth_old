Raw data files expected by this project
========================================

1. IPUMS ACS or CPS labor microdata

   data/raw/ipums_labor.dta
   or
   data/raw/ipums_labor.csv

   Include YEAR, AGE, SEX, RACE, EDUC/EDUCD, STATEFIP, OCC/OCC2010, IND,
   PERWT, and wage/hours variables such as INCWAGE, EARNWEEK, UHRSWORK,
   UHRSWORKT, WKSWORK1, or WKSWORK2.

2. Occupation remote-workability scores

   data/raw/remote_work_scores.csv

   Required columns: occ_code and remote_score or wfh_score.
   Suggested source: https://github.com/jdingel/DingelNeiman-workathome

The scripts stop rather than fake results when these files are missing.
