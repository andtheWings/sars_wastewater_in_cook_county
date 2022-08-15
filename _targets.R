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
tar_option_set(packages = "dplyr")

# End this file with a list of target objects.
list(
  tar_target(
      biobot_wastewater_by_county_raw_csv,
      "covid19-wastewater-data/wastewater_by_county.csv",
      format = "file"
  ),
  tar_target(
      biobot_wastewater_by_county_raw,
      readr::read_csv(biobot_wastewater_by_county_raw_csv)
  ),
  tar_target(
      biobot_wastewater_in_cook,
      wrangle_biobot_data_to_cook(biobot_wastewater_by_county_raw)
  ),
  tar_target(
      biobot_cases_by_county_raw_csv,
      "covid19-wastewater-data/cases_by_county.csv",
      format = "file"
  ),
  tar_target(
      biobot_cases_by_county_raw,
      readr::read_csv(biobot_cases_by_county_raw_csv)
  ),
  tar_target(
      biobot_cases_in_cook,
      wrangle_biobot_data_to_cook(biobot_cases_by_county_raw) |> 
          filter(date < lubridate::ymd("2022-06-06"))
  )
)
