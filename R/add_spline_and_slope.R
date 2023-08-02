add_spline_and_slope <- function(time_series_df, y_var, date_var = "date") {
    
    df1 <- 
        time_series_df |> 
        # Add an time index variable to feed into the spline fitting function
        dplyr::mutate(
            .day_num = as.numeric(.data[[ date_var ]] - min(.data[[ date_var ]]))
        )
    
    # Fit a spline to the data
    fitted_spline_1 <- pspline::sm.spline(df1[[".day_num"]], df1[[ y_var ]])

    df2 <-
        df1 |>
        dplyr::mutate(
            # Add the fitted spline
            .spline = predict(fitted_spline_1, .day_num, nderiv = 0)[,1],
            # Standardize the spline as with a z-score
            .z_spline = (.spline - mean(.spline))/sd(.spline),
            # Add the 1st derivative (slope) of the spline
            .spline_slope = predict(fitted_spline_1, .day_num, nderiv = 1)[,1],
            # Standardize the slope into percent daily change
            .percent_daily_change = .spline_slope / lag(.spline) * 100
        )
    
    return(df2)
    
}