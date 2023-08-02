plot_spline_snapshots <- function(time_series_df, date_vct_slice, y_var, title_char = NULL) {
    
    # Slice the desired vector of dates
    date_vct <- time_series_df$date[date_vct_slice]
    
    list1 <-
        map(
            # For each date in the vector...
            date_vct, 
            .f =
                # Create a version of the data where that date is at the leading edge...
                ~ time_series_df |> 
                filter(date <= .x) |>
                # Fit a spline...
                add_spline_and_slope(y_var) |>  
                # And plot it...
                ggplot(aes(x = date)) +
                geom_point(aes(y = .data[[ y_var ]]), alpha = 0.25) +
                geom_line(aes(y = .spline)) +
                labs(
                    title = title_char,
                    x = NULL,
                    y = NULL
                ) +
                theme_bw()
        ) |> 
        map(ggplotly)
    
    return(list1)
    
}