plot_threshold_anomalies <- function(time_series_df, date_var, y_var, threshold_num) {
    
    df_over <- 
        time_series_df |> 
        filter({{ y_var }} > threshold_num)
    
    plot_1 <-
        time_series_df |> 
        plot_base_time_series({{ date_var }}, {{ y_var }}) +
        geom_hline(
            yintercept = threshold_num,
            color = "red",
            linetype = "dashed"
        ) +
        geom_point(
            aes(x = {{ date_var }}, y = {{ y_var }}),
            data = df_over,
            color = "red"
        ) 
    
    return(plot_1)
    
}