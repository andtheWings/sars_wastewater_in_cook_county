plot_series_auto_anomalies <- function(time_series_slope_df, label, alpha = 0.05) {
    
    time_series_slope_df |> 
        plot_anomaly_diagnostics(
            date, M_viral_copies_per_day_per_person,
            .title = paste0("SARS-CoV-2 Surveillance Anomalies at ", label, " (alpha = ", alpha, ")"), 
            .y_lab = "Million Viral Copies per Day per Person",
            .interactive = FALSE,
            .alpha = alpha
        ) +
        geom_line(
            aes(x = date, y = .smooth),
            data = time_series_slope_df,
            color = "purple",
            linetype = "dotted",
            size = 1
        )
    
}