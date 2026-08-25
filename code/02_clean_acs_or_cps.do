********************************************************************************
* 02_clean_acs_or_cps.do
* Clean IPUMS ACS or CPS labor microdata.
*
* Expected input:
*   data/raw/ipums_labor.dta
*   or data/raw/ipums_labor.csv
********************************************************************************

version 16
set more off

local labor_dta "$RAW/ipums_labor.dta"
local labor_csv "$RAW/ipums_labor.csv"

capture confirm file "`labor_dta'"
local has_dta = (_rc == 0)
capture confirm file "`labor_csv'"
local has_csv = (_rc == 0)

if !`has_dta' & !`has_csv' {
    di as error "Missing labor microdata."
    di as error "Place an IPUMS ACS/CPS extract at data/raw/ipums_labor.dta or data/raw/ipums_labor.csv."
    di as error "See README.md for exact download instructions and variable list."
    exit 601
}

if `has_dta' {
    use "`labor_dta'", clear
}
else {
    import delimited using "`labor_csv'", clear varnames(1) case(lower)
}

capture rename *, lower

capture confirm variable occ_code
if _rc {
    capture confirm variable occ2010
    if !_rc rename occ2010 occ_code
}
capture confirm variable occ_code
if _rc {
    capture confirm variable occ
    if !_rc rename occ occ_code
}
capture confirm variable occ_code
if _rc {
    di as error "No occupation variable found. Include OCC or OCC2010 in the IPUMS extract."
    exit 111
}

capture confirm variable weight
if _rc {
    capture confirm variable perwt
    if !_rc rename perwt weight
}
capture confirm variable weight
if _rc {
    gen weight = 1
    label variable weight "Analysis weight; set to 1 because PERWT was unavailable"
}

foreach v in year age sex race statefip {
    capture confirm variable `v'
    if _rc {
        di as error "Required variable `v' is missing from the labor extract."
        exit 111
    }
}

capture confirm variable educ
if _rc {
    capture confirm variable educd
    if !_rc rename educd educ
}
capture confirm variable educ
if _rc {
    di as error "Education variable missing. Include EDUC or EDUCD."
    exit 111
}

capture confirm variable ind
if _rc {
    gen ind = .
    label variable ind "Industry code unavailable in raw extract"
}

gen annual_earnings = .
gen weekly_earnings = .
gen usual_hours = .
gen weeks_worked = .

capture confirm variable incwage
if !_rc replace annual_earnings = incwage if incwage > 0 & incwage < 9999998

capture confirm variable earnweek
if !_rc replace weekly_earnings = earnweek if earnweek > 0 & earnweek < 999999

capture confirm variable uhrswork
if !_rc replace usual_hours = uhrswork if uhrswork > 0 & uhrswork < 99

capture confirm variable uhrsworkt
if !_rc replace usual_hours = uhrsworkt if missing(usual_hours) & uhrsworkt > 0 & uhrsworkt < 99

capture confirm variable wkswork1
if !_rc replace weeks_worked = wkswork1 if wkswork1 > 0 & wkswork1 <= 52

capture confirm variable wkswork2
if !_rc {
    replace weeks_worked = 7    if missing(weeks_worked) & wkswork2 == 1
    replace weeks_worked = 20   if missing(weeks_worked) & wkswork2 == 2
    replace weeks_worked = 33   if missing(weeks_worked) & wkswork2 == 3
    replace weeks_worked = 43.5 if missing(weeks_worked) & wkswork2 == 4
    replace weeks_worked = 48.5 if missing(weeks_worked) & wkswork2 == 5
    replace weeks_worked = 51   if missing(weeks_worked) & wkswork2 == 6
}

gen hourly_wage = .
replace hourly_wage = annual_earnings / (usual_hours * weeks_worked) ///
    if annual_earnings > 0 & usual_hours > 0 & weeks_worked > 0
replace hourly_wage = weekly_earnings / usual_hours ///
    if missing(hourly_wage) & weekly_earnings > 0 & usual_hours > 0

gen log_wage = log(hourly_wage) if hourly_wage > 1 & hourly_wage < 500
label variable log_wage "Log hourly wage"

gen age2 = age^2
gen college = inlist(educ, 10, 11, 12, 13) if !missing(educ)
label variable college "College degree or more, approximate IPUMS EDUC coding"

gen female = (sex == 2) if !missing(sex)
label variable female "Female"

gen young = (age < 40) if age < .
label variable young "Age less than 40"

gen post2020 = (year >= 2020) if !missing(year)
gen post2021 = (year >= 2021) if !missing(year)
label variable post2020 "Year >= 2020"
label variable post2021 "Year >= 2021"

keep if age >= 18 & age <= 64
keep if !missing(log_wage, year, age, sex, race, educ, statefip, occ_code)

compress
save "$PROCESSED/labor_clean.dta", replace

di as result "Saved cleaned labor data to $PROCESSED/labor_clean.dta"
