get_loadings <- function(calibration_tbl){
  loadings_tbl <- calibration_tbl %>%
    modeltime_accuracy() %>%
    mutate(rank = min_rank(-rmse)) %>% 
    select(.model_id, rank)
  
  return(loadings_tbl)
}

# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "get_loadings"
    ),
    
    file = "01_source/f_get_loadings.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "get_loadings"
    ),
    
    file = "01_source/f_get_loadings.R",
    append = FALSE)
}
