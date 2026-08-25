# Remote Work and Career Advancement: Evidence from Wage Growth After COVID

## 1. Introduction

COVID-19 changed where many jobs could be performed. Occupations that were feasible to do from home may have experienced different wage dynamics after the pandemic than occupations requiring more in-person work. This project asks whether workers in remote-workable occupations experienced different wage growth after COVID compared with workers in less remote-workable occupations.

## 2. Data

The project is designed for public IPUMS ACS or CPS labor-market microdata. The analysis uses individual-level observations with wages or earnings, hours, occupation, demographics, state, industry, and year.

The preferred outcome is log hourly wage. In ACS-style data, hourly wage is constructed from annual wage income, usual hours worked, and weeks worked. In CPS-style data, weekly earnings and usual hours can be used when available.

Occupation-level remote-workability is measured using a public work-from-home feasibility score such as Dingel and Neiman’s occupation-level measure. A binary treatment variable identifies occupations with above-median remote-workability.

## 3. Empirical Strategy

The main specification is:

```text
log_wage_it = beta0
            + beta1 remote_workable_i
            + beta2 post_t
            + beta3 remote_workable_i * post_t
            + controls
            + error_it
```

The key coefficient is `beta3`, the interaction between remote-workability and the post-COVID period. It estimates whether wages changed differently after COVID in remote-workable occupations relative to less remote-workable occupations.

Controls include age, age squared, education, sex, race, state fixed effects, year fixed effects, and industry fixed effects when available. A robustness specification includes occupation fixed effects. Standard errors are clustered by occupation.

## 4. Results Placeholder

Results will be populated after the user downloads the public raw data files and runs:

```stata
do code/00_master.do
```

The project will produce summary statistics, wage trend figures, main regression estimates, heterogeneity estimates, and robustness checks. The sign, magnitude, and statistical significance of the remote-workability by post-period interaction will determine whether the evidence suggests faster or slower post-COVID wage growth in remote-workable occupations.

## 5. Limitations

This design is difference-in-differences style, but it should be interpreted cautiously. Remote-workable occupations differ from less remote-workable occupations in education, industry, skill requirements, labor demand shocks, and exposure to pandemic-era policy changes. Controls and fixed effects reduce some confounding but cannot remove all bias.

Wage measures may be approximate, especially when hourly wages are constructed from annual earnings and usual schedules. Occupation-code harmonization between IPUMS data and remote-workability scores is also a central measurement challenge.

Finally, wage growth is only a proxy for career advancement. The project does not directly observe promotions, responsibilities, internal job ladders, or within-firm mobility.

## 6. Conclusion

This project provides a reproducible Stata framework for studying whether remote-workable occupations experienced different wage growth after COVID. Once the public raw data are added, the project can be run from start to finish with the master do-file.

## Connection to Hybrid-Work, Turnover, and Promotion Research

The project is inspired by research on hybrid work arrangements, turnover, and promotions, including Cornell-style papers such as “Balancing Turnover and Promotion Outcomes: Evidence on the Optimal Hybrid-Work Frequency.” Those studies often rely on internal firm records to observe promotion and retention outcomes directly.

This project takes a different public-data approach. It cannot observe internal promotion records, so it studies wage growth as a proxy for career advancement. The advantage is transparency and reproducibility; the tradeoff is that the analysis speaks to broad labor-market wage changes rather than firm-specific promotion processes.
