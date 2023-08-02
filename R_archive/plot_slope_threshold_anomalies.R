plot_slope_threshold_anomalies <- function(time_series_slope_df, label, threshold = 2) {
    
    df_over <- 
        time_series_slope_df |> 
        filter(.slope > threshold)
    
    plot_1 <-
        time_series_slope_df |> 
        plot_time_series(
            date, .slope, 
            .smooth = FALSE, 
            .title = paste0("SARS-CoV-2 Surveillance Slope Anomalies at ", label, " (threshold = ", as.character(threshold), ")"), 
            .y_lab = "Change in Million Viral Copies per Day per Person",
            .interactive = FALSE
        ) +
        geom_hline(
            yintercept = threshold,
            color = "red",
            linetype = "dashed"
        ) +
        geom_point(
            aes(x = date, y = .slope),
            data = df_over,
            color = "red"
        )
    
    return(plot_1)
}