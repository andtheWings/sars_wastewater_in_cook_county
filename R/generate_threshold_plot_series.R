generate_threshold_plot_series <- function(time_series_df, date_vct_slice, y_var_char, fit_var_symb, threshold_num) {
    
    date_vct <- time_series_df$date[date_vct_slice]
    
    map(
        date_vct, 
        .f =
            ~ time_series_df |> 
            filter(date <= .x) |>
            add_spline_and_slope("day_num", y_var_char) |> 
            #add_loess_and_trend("day_num", "log_conc_flowrt_sum") |> 
            # pivot_longer(
            #     cols = c(.spline_slope, .loess_trend),
            #     values_to = "trend_value",
            #     names_to = "trend_type"
            # ) |> 
            # filter(!is.na(trend_value)) |> 
            plot_threshold_anomalies(date, {{ fit_var_symb }}, threshold_num) |> 
            ggplotly()
    )
    
}