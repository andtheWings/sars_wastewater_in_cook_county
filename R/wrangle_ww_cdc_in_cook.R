wrangle_ww_cdc_in_cook <- function(ww_cdc_analyzed_raw_df) {
    
    df1 <-
        ww_cdc_analyzed_raw_df |> 
        #Filter for Cook County cases sampled at Wastewater Treatment Plants
        filter(grepl("17031", county_names) & sample_location == "wwtp")|>
        # Filter for cases with measurements
        filter(!is.na(pcr_target_avg_conc)) |> 
        select(
            # Time Variables
            date, day_num, sample_collect_date_time,
            # WWTP Variables
            wwtp_name, population_served,
            # Location Variables
            longitude, latitude,
            # Measurement Variables
            pcr_target_avg_conc, pcr_target_units, 
            # Adjustment Variables
            rec_eff_percent, flow_rate
        ) |> 
        # As of 2022-11-11, when filtering by !is.na(pcr_target_avg_conc), no missing values
        #
        # group_by(date, sample_collect_date_time, wwtp_name, major_lab_method, population_served) |>
        # summarize(
        #     across(
        #         c(flow_rate, pcr_target_avg_conc, pcr_target_flowpop_lin, pcr_target_flowpop_log10),
        #         ~mean(.x, na.rm = TRUE)
        #     ),
        #     .groups = "keep"
        # ) |> 
        # ungroup() |> 
        #
        mutate(
            short_name =
                # factor(
                    case_when(
                        grepl("kirie", wwtp_name) ~ "kirie",
                        grepl("egan", wwtp_name) ~ "egan",
                        grepl("hanover", wwtp_name) ~ "hanover",
                        grepl("brien", wwtp_name) ~ "obrien",
                        grepl(" sws", wwtp_name) ~ "stickney 1",
                        grepl(" ws", wwtp_name) ~ "stickney 2",
                        grepl("lemont", wwtp_name) ~ "lemont",
                        grepl("calumet", wwtp_name) ~ "calumet"
                    ),
                    # ordered = TRUE,
                    # levels = c("hanover", "egan", "kirie", "obrien", "stickney 1", "stickney 2", "lemont", "calumet")
                # ),
            display_name =
                # factor(
                    case_when(
                        grepl("kirie", wwtp_name) ~ "Kirie, Mid Northwest Suburbs",
                        grepl("egan", wwtp_name) ~ "Egan, Far Northwest Suburbs",
                        grepl("hanover", wwtp_name) ~ "Hanover Park, Far Northwest Suburbs",
                        grepl("brien", wwtp_name) ~ "O'Brien, Northeast Suburbs and Chicago",
                        grepl(" sws", wwtp_name) ~ "Stickney (1), West Suburbs and Chicago",
                        grepl(" ws", wwtp_name) ~ "Stickney (2), West Suburbs and Chicago",
                        grepl("lemont", wwtp_name) ~ "Lemont, Far Southwest Suburbs",
                        grepl("calumet", wwtp_name) ~ "Calumet, South Suburbs and Chicago"
                    ),
                #     ordered = TRUE,
                #     levels = c("Hanover Park, Far Northwest Suburbs", "Egan, Far Northwest Suburbs", "Kirie, Mid Northwest Suburbs", "O'Brien, Northeast Suburbs and Chicago", "Stickney (1), West Suburbs and Chicago", "Stickney (2), West Suburbs and Chicago", "Lemont, Far Southwest Suburbs", "Calumet, South Suburbs and Chicago")
                # ),
            .after = wwtp_name
        ) |> 
        mutate(
            M_viral_copies_per_day_per_person = pcr_target_avg_conc * (rec_eff_percent/100) * (flow_rate * 3.785411784) / population_served
            # flow_rate_l = flow_rate * 3.785411784, #convert flow_rate to liters
            # conc_flowrt = pcr_target_avg_conc * flow_rate_l
        ) |>
        arrange(date)
    
    # lemont_adjust_dates <- 
    #     df1 |>
    #     filter(short_name != "lemont") |>
    #     group_by(date) |>
    #     tally() |>
    #     ungroup() |>
    #     filter(n == 7) |>
    #     mutate(date = date + 1) |>
    #     pull(date)
    
    return(df1)
    
}