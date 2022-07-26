library(targets)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
sapply(
    paste0("R/", list.files("R/")),
    source
)

# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr", "tidyr"))

# End this file with a list of target objects.
list(
    tar_target(
        ww_cdc_analyzed_file,
        "data/contour-export-NWSS-Analyzed-Export-Export-07-26-2022.csv",
        format = "file"
    ),
    tar_target(
        ww_cdc_analyzed_raw,
        readr::read_csv(ww_cdc_analyzed_file)
        # 5 parsing errors, all with major lab method, but none in Cook County
    ),
    tar_target(
        ww_cdc_in_cook,
        wrangle_ww_cdc_in_cook(ww_cdc_analyzed_raw)
    )
)
