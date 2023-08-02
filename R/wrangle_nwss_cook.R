wrangle_nwss_cook <- function(nwss_analyzed_raw_df) {

    df1 <-
        nwss_analyzed_raw_df |> 
        #Filter for Cook County cases sampled at Wastewater Treatment Plants
        filter(county_names == 17031 & sample_location == "wwtp" & major_lab_method == 1)|>
        # Filter for cases with measurements
        drop_na(pcr_target_avg_conc) |> 
        # Filter for cases that didn't report recovery percentage as zero
        #filter(rec_eff_percent != 0) |> 
        # Filter outliers - rough rule of thumb, visual inspection & values more than double second highest ever, use sparingly as will result in date being thrown out of combined metric
        filter(!(grepl("lemont", wwtp_name) & date == as.Date("2022-02-28"))) |>
        filter(!(grepl("kirie", wwtp_name) & date == as.Date("2022-06-21"))) |>
        filter(!(grepl("kirie", wwtp_name) & date == as.Date("2022-11-27"))) |>
        filter(!(grepl(" sws", wwtp_name) & date == as.Date("2022-06-19"))) |>
        filter(!(grepl("lemont", wwtp_name) & date == as.Date("2022-12-23"))) |>
        filter(!(grepl("calumet", wwtp_name) & date == as.Date("2023-01-08"))) |>
        filter(!(grepl("hanover", wwtp_name) & date == as.Date("2023-02-07"))) |>
        filter(!(grepl(" sws", wwtp_name) & date == as.Date("2023-02-09"))) |>
        select(
            # Time Variables
            date, sample_collect_date_time,
            # WWTP Variables
            wwtp_name, 
            # Location Variables
            longitude, latitude,
            # Measurement Variables
            pcr_target_avg_conc, pcr_target_units, 
            # Adjustment Variables
            rec_eff_percent, flow_rate, population_served, major_lab_method
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
        mutate(
            short_name =
                # factor(
                    case_when(
                        grepl("kirie", wwtp_name) ~ "kirie",
                        grepl("egan", wwtp_name) ~ "egan",
                        grepl("hanover", wwtp_name) ~ "hanover",
                        grepl("brien", wwtp_name) ~ "obrien",
                        grepl(" sws", wwtp_name) ~ "stickney1",
                        grepl(" ws", wwtp_name) ~ "stickney2",
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
            conc_flowrt = pcr_target_avg_conc * (flow_rate * 3.785411784),
        ) |>
        group_by(short_name) |> 
        arrange(date) |> 
        mutate(
            index = row_number(),
            mean_3 = zoo::rollmean(conc_flowrt, 3, fill = NA, align = "center"),
            median_3 = zoo::rollapply(conc_flowrt, 3, median, fill = NA, align = "center"),
            rank = percent_rank(conc_flowrt),
            loess = predict(loess(conc_flowrt ~ index, span = .25)),
            log_conc_flowrt = 
                if_else(
                    conc_flowrt == 0,
                    true = 0,
                    false = log10(conc_flowrt)
                )
        ) |>
        ungroup() |> 
        arrange(date, short_name) #|>
        #sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
    
    return(df1)
    
}