plot_series_threshold_anomalies <- function(time_series_slope_df, label, threshold = 100) {
    
    df_over <- 
        time_series_slope_df |> 
        filter(.spline > threshold)
    
    plot_1 <-
        time_series_slope_df |> 
        plot_base_time_series(label = label) +
        geom_line(
            aes(y = .spline),
            linetype = "dotted"
        ) +
        geom_hline(
            yintercept = threshold,
            color = "red",
            linetype = "dashed"
        ) +
        geom_point(
            aes(x = date, y = .spline),
            data = df_over,
            color = "red"
        ) +
        labs(title = paste0("SARS-CoV-2 Surveillance Anomalies at ", label, " (threshold = ", as.character(threshold), ")"))
    
    return(plot_1)
}