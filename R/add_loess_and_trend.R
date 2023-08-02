add_loess_and_trend <- function(time_series_df, day_num_var, y_var) {
    
    formula1 <- as.formula(paste(y_var, "~", day_num_var))

    loess1 <-
        loess(
            formula1,
            data = time_series_df,
            span = .25
        )

    lm_trend_roll <-
        timetk::slidify(
            ~parameters::parameters(lm(.y ~ .x))[2,2],
            .period = 5,
            .unlist = TRUE,
            .align = "right"
        )
    
    df1 <-
        time_series_df |>
        mutate(
            .loess = predict(loess1),
            .loess_trend = lm_trend_roll(.data[[day_num_var]], .loess)
        )
    
    return(df1)
    
}