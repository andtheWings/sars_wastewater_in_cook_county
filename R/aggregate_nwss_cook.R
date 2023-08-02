aggregate_nwss_cook <- function(nwss_cook_sf) {
    
    index_date = min(nwss_cook_sf$date)
    
    lemont_adjust_dates <- 
        nwss_cook_sf |>
        #filter(short_name %in% c("kirie", "egan", "hanover")) |>
        filter(short_name != "lemont") |>
        group_by(date) |>
        tally() |>
        ungroup() |>
        #filter(n == 7) |>
        filter(n > 5) |>
        mutate(date = date + 1) |>
        pull(date)
    
    #calculate county-wide metrics
    ww_cook <-  
        nwss_cook_sf |>
        filter(short_name != "egan") |>
        group_by(short_name, date) |>
        arrange(sample_collect_date_time) |>
        slice(1) |>  #only take one sample collection per day
        ungroup() |>
        mutate(date = if_else(short_name == "lemont" & date %in% lemont_adjust_dates, date - 1, date)) |> #fix one-off lemont dates
        group_by(date) |>
        summarise(
            num_sites = length(date),
            conc_flowrt_sum = sum(conc_flowrt)
        ) |>  #sum values for county wide
        ungroup() |>
        #filter(num_sites == 8) |>  #only include complete sampling dates
        filter(num_sites == 7) |>  #egan missing huge number of dates in december, exclude from county wide for now and investigate
        arrange(date) |>
        mutate(
            log_conc_flowrt_sum = if_else(
                conc_flowrt_sum == 0,
                true = 0,
                false = log10(conc_flowrt_sum)
            ), 
            median_3 = zoo::rollapply(conc_flowrt_sum, 3, median, fill = NA, align = "center")
        ) 
    
    return(ww_cook)
    
}