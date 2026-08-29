# The Remote Work Wage Premium: Post-COVID Wage Growth in Remote-Workable Occupations

## 1. Introduction

This project studies whether workers in remote-workable occupations had different wage growth after COVID compared to workers in less remote-workable occupations.

## 2. Data

The project uses ACS/IPUMS worker-level data and Dingel-Neiman occupation-level remote-workability data.

The ACS file should be saved as `data/raw/usa_00001.dta`.

The remote-workability file should be saved as `data/raw/remote/occupations_workathome.csv`.

The ACS extract includes `OCCSOC`, so the project can merge worker occupations directly with the Dingel-Neiman SOC occupation file.

## 3. Empirical Strategy

The main regression is:

```text
log_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient is:

```text
1.remote_workable#1.covid
```

Since the outcome is log hourly wage, this coefficient is roughly a percent wage difference.

## 4. Results Placeholder

Results will be added after the raw data files are placed in the project and the three Stata do-files are run.

## 5. Limitations

ACS does not directly show whether a person worked remotely. The project measures whether the person's occupation is remote-workable.

The occupation merge may miss some observations if Dingel-Neiman occupation codes do not match every IPUMS `OCCSOC` code.

## 6. Conclusion

This project creates a simple, reproducible Stata workflow for studying remote-workability and post-COVID wage growth using public data.
