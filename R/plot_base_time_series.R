plot_base_time_series<- function(time_series_df, y_var, date_var = date) {
   
    time_series_df |>
        ggplot(
            aes(
                x = {{date_var}}, 
                y = {{y_var}}#,
                #color = {{group_var}}
            )
        ) +
        geom_line() +
        labs(x = NULL) +
        theme_bw()
    
}