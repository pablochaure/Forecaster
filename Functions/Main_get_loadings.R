get_loadings <- function(calibration_tbl){
  loadings_tbl <- calibration_tbl %>%
    modeltime_accuracy() %>%
    mutate(rank = min_rank(-rmse)) %>% 
    select(.model_id, rank)
  
  return(loadings_tbl)
}

# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "get_loadings"
    ),
    
    file = "00_scripts/f_get_loadings.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "get_loadings"
    ),
    
    file = "00_scripts/f_get_loadings.R",
    append = FALSE)
}