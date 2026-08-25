********************************************************************************
* 06_regressions.do
* Difference-in-differences style regressions.
*
* Key coefficient:
*   1.remote_workable#1.post2020 or c.remote_score#1.post2020
********************************************************************************

version 16
set more off

capture confirm file "$PROCESSED/analysis_data.dta"
if _rc {
    di as error "Missing analysis data. Run 04_merge_data.do first."
    exit 601
}

use "$PROCESSED/analysis_data.dta", clear

foreach v in sex race educ statefip ind occ_code year {
    capture destring `v', replace
}

gen byte prime_age = inrange(age, 25, 54)
label variable prime_age "Age 25-54"

estimates clear

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight], vce(cluster occ_code)
estimates store main_post2020
estimates save "$TABLES/main_post2020.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind i.occ_code [pw=weight], vce(cluster occ_code)
estimates store main_occfe_post2020
estimates save "$TABLES/main_occfe_post2020.ster", replace

reg log_wage i.remote_workable##i.post2021 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight], vce(cluster occ_code)
estimates store robust_post2021
estimates save "$TABLES/robust_post2021.ster", replace

reg log_wage c.remote_score##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight], vce(cluster occ_code)
estimates store continuous_score
estimates save "$TABLES/continuous_score.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight] if prime_age == 1, vce(cluster occ_code)
estimates store prime_age
estimates save "$TABLES/prime_age.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight] if college == 1, vce(cluster occ_code)
estimates store college
estimates save "$TABLES/heterogeneity_college.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight] if college == 0, vce(cluster occ_code)
estimates store noncollege
estimates save "$TABLES/heterogeneity_noncollege.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight] if young == 1, vce(cluster occ_code)
estimates store young
estimates save "$TABLES/heterogeneity_young.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.sex i.race i.statefip i.year i.ind [pw=weight] if young == 0, vce(cluster occ_code)
estimates store older
estimates save "$TABLES/heterogeneity_older.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.race i.statefip i.year i.ind [pw=weight] if female == 1, vce(cluster occ_code)
estimates store women
estimates save "$TABLES/heterogeneity_women.ster", replace

reg log_wage i.remote_workable##i.post2020 c.age c.age2 ///
    i.educ i.race i.statefip i.year i.ind [pw=weight] if female == 0, vce(cluster occ_code)
estimates store men
estimates save "$TABLES/heterogeneity_men.ster", replace

if "$HAS_ESTTAB" == "1" {
    esttab main_post2020 main_occfe_post2020 robust_post2021 continuous_score prime_age ///
        using "$TABLES/main_regression_table.rtf", replace ///
        se star(* 0.10 ** 0.05 *** 0.01) ///
        keep(1.remote_workable#1.post2020 1.remote_workable#1.post2021 c.remote_score#1.post2020) ///
        label title("Remote Workability and Post-COVID Wage Growth") ///
        addnotes("Standard errors clustered by occupation.", ///
                 "The key coefficient is the remote-workability by post-period interaction.")

    esttab college noncollege young older women men ///
        using "$TABLES/heterogeneity_table.rtf", replace ///
        se star(* 0.10 ** 0.05 *** 0.01) ///
        keep(1.remote_workable#1.post2020) ///
        label title("Heterogeneity in Remote-Workability Wage Effects") ///
        addnotes("Standard errors clustered by occupation.")
}
else {
    di as text "Formatted esttab tables skipped because esttab is unavailable."
}

di as result "Saved regression outputs to $TABLES"
