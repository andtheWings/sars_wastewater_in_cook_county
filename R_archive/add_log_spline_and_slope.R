add_log_spline_and_slope <- function(time_series_df) {
    
    df1 <- 
        time_series_df |> 
        mutate(log_M_copies_per_day_per_person = log(M_viral_copies_per_day_per_person)) |> 
        filter(!is.infinite(log_M_copies_per_day_per_person))
    
    fitted_spline_1 <- pspline::sm.spline(df1$day_num, df1$log_M_copies_per_day_per_person)
    
    df2 <- 
        time_series_df |> 
        mutate(
            .spline = exp(predict(fitted_spline_1, time_series_df$day_num, nderiv = 0)[,1]),
            .slope = predict(fitted_spline_1, time_series_df$day_num, nderiv = 1)[,1]
        )
    
    return(df2)
    
}