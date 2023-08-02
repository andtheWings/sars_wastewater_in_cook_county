collect_nwss <- function(nwss_cook_df, nwss_cook_aggregate_df) {
    
    list1 <- list()
    
    list1[["egan"]] <- filter(nwss_cook_df, short_name == "egan")
    list1[["kirie"]] <- filter(nwss_cook_df, short_name == "kirie")
    list1[["obrien"]] <- filter(nwss_cook_df, short_name == "obrien")
    list1[["hanover"]] <- filter(nwss_cook_df, short_name == "hanover")
    list1[["stickney1"]] <- filter(nwss_cook_df, short_name == "stickney1")
    list1[["stickney2"]] <- filter(nwss_cook_df, short_name == "stickney2")
    list1[["lemont"]] <- filter(nwss_cook_df, short_name == "lemont")
    list1[["calumet"]] <- filter(nwss_cook_df, short_name == "calumet")
    list1[["cook_aggregate"]] <- nwss_cook_aggregate_df
    
    # list2 <- map(
    #     .x = list1, 
    #     .f = ~add_spline_and_slope(.x, "conc_flowrt")
    # )
    
    return(list1)
    
}