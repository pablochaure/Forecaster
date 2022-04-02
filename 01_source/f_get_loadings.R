get_loadings <-
function(calibration_tbl){
  loadings_tbl <- calibration_tbl %>%
    modeltime_accuracy() %>%
    mutate(rank = min_rank(-rmse)) %>% 
    select(.model_id, rank)
  
  return(loadings_tbl)
}
