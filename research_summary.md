# Wage Growth After COVID

## 1. Introduction

This project studies how wages changed after COVID and whether those changes differed by race, age, gender, education, industry, state, and occupation remote-workability.

## 2. Data

The project uses ACS/IPUMS worker-level data and Dingel-Neiman occupation-level remote-workability data.

The ACS file should be saved as `data/raw/usa_00001.dta`.

The remote-workability file should be saved as `data/raw/remote/occupations_workathome.csv`.

The ACS extract includes `OCCSOC`, so the project can merge worker occupations directly with the Dingel-Neiman SOC occupation file for the remote-workability part of the analysis.

## 3. Empirical Strategy

The main regression is:

```text
log_wage = covid + controls
```

The project also estimates difference-in-differences style regressions:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient is:

```text
1.remote_workable#1.covid
```

Since the outcome is log annual wage income, this coefficient is roughly a percent wage-income difference.

The project also compares post-COVID wage changes across race, age, gender, education, industry, and state groups. It also includes a simple wage-inequality graph using the gap between high-wage and low-wage workers.

## 4. Results Placeholder

Results will be added after the Stata do-files are run and the tables/figures are reviewed.

## 5. Limitations

This is a before/after labor-market project, so the post-COVID coefficient should not be interpreted as the effect of COVID alone.

ACS does not directly show whether a person worked remotely. The project measures whether the person's occupation is remote-workable.

The occupation merge may miss some observations if Dingel-Neiman occupation codes do not match every IPUMS `OCCSOC` code.

## 6. Conclusion

This project creates a simple, reproducible Stata/R workflow for studying post-COVID wage growth using public data.
