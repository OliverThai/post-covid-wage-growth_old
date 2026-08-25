********************************************************************************
* Remote Work and Career Advancement
* Master do-file
*
* Run from the project root:
*     do code/00_master.do
********************************************************************************

clear all
set more off
version 16

capture log close _all

local cwd "`c(pwd)'"
if substr("`cwd'", -5, 5) == "/code" {
    cd ..
}

global ROOT "`c(pwd)'"
global RAW "$ROOT/data/raw"
global PROCESSED "$ROOT/data/processed"
global TABLES "$ROOT/outputs/tables"
global FIGURES "$ROOT/outputs/figures"
global CODE "$ROOT/code"

log using "$ROOT/outputs/project_log.smcl", replace

di as text "Starting Remote Work and Career Advancement project"
di as text "Project root: $ROOT"

do "$CODE/01_setup.do"
do "$CODE/02_clean_acs_or_cps.do"
do "$CODE/03_clean_remote_work_scores.do"
do "$CODE/04_merge_data.do"
do "$CODE/05_summary_stats.do"
do "$CODE/06_regressions.do"
do "$CODE/07_figures.do"

di as result "Workflow complete."
di as result "Tables:  $TABLES"
di as result "Figures: $FIGURES"

log close
