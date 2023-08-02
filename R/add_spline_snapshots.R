add_spline_snapshots <- function(time_series_df, y_var_char) {
    
    # Slice the desired vector of dates
    date_vct <- time_series_df$date[6:length(time_series_df$date)]
    
    df1 <-
        # For each date in the vector...
        map(
            date_vct, 
            .f =
                ~ time_series_df |>
                # Create a version of the data where that date is at the leading edge...
                filter(date <= .x) |>
                # Fit a spline...
                add_spline_and_slope(y_var_char) |>
                # And slice out the fitted values for that time point
                slice_max(date)
        ) |> 
        # Bind together all these slices
        reduce(bind_rows) |> 
        # Rename spline variables to clarify these come from separate time snapshots
        rename(
            .spline_snapshot = .spline,
            .z_spline_snapshot = .z_spline,
            .spline_slope_snapshot = .spline_slope,
            .pdc_snapshot = .percent_daily_change
        ) |>
        # Join these variables back into the original dataframe
        select(date, .spline_snapshot, .z_spline_snapshot, .spline_slope_snapshot, .pdc_snapshot) |>
        right_join(time_series_df, by = "date")
    
    return(df1)
    
}