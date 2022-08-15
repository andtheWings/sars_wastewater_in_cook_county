wrangle_biobot_data_to_cook <- function(biobot_data_by_county_raw_df) {
    
    df1 <-
        biobot_data_by_county_raw_df |> 
        filter(name == "Cook County, IL") |> 
        select(2:3) |> 
        mutate(across(1, lubridate::ymd))
    
    return(df1)
    
}