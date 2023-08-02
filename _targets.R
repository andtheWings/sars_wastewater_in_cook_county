library(targets)

# Define custom functions and other global objects.
sapply(
    paste0("R/", list.files("R/")),
    source
)

# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr", "tidyr", "purrr", "lubridate"))

# End this file with a list of target objects.
list(
    tar_target(
        nwss_analyzed_file,
        "data/contour-export-NWSS-Analyzed-Export-Export-01-25-2023.csv",
        format = "file"
    ),
    tar_target(
        nwss_analyzed_raw,
        readr::read_csv(nwss_analyzed_file)
        # 5 parsing errors, all with major lab method, but none in Cook County
    ),
    tar_target(
        nwss_cook,
        wrangle_nwss_cook(nwss_analyzed_raw)
    ),
    tar_target(
        nwss_cook_aggregate,
        aggregate_nwss_cook(nwss_cook)
    ),
    tar_target(
        nwss,
        collect_nwss(nwss_cook, nwss_cook_aggregate)
    ),
    
    tar_target(
        percent_ed_covid_specific_diagnosis_file,
        "data/percent-ed-covid-specific-diagnosis.csv",
        format = "file"
    ),
    tar_target(
        percent_ed_covid_specific_diagnosis_raw,
        readr::read_csv(percent_ed_covid_specific_diagnosis_file)
    )
)
