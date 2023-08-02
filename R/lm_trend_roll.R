lm_trend_roll <- function() {
    
    timetk::slidify(
        ~parameters::parameters(lm(.y ~ .x))[2,2], 
        .period = 3, 
        .unlist = TRUE, 
        .align = "right"
    )
    
}