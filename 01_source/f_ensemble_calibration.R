ensemble_calibration <-
function(input, calibration_tbl, test_data){
  ensemble_tbl <- modeltime_table()
  
  if ("Mean average" %in% input){
    ensemble_mean <- ensemble_average(object = calibration_tbl,
                                      type   = "mean"
    )
    
    ensemble_tbl <- ensemble_tbl %>% add_modeltime_model(model = ensemble_mean)
  }
  if ("Median average" %in% input){
    ensemble_median <- ensemble_average(object = calibration_tbl,
                                        type   = "median"
    )
    
    ensemble_tbl <- ensemble_tbl %>% add_modeltime_model(model = ensemble_median)
  }
  if ("Weighted average" %in% input){
    loadings_tbl <- get_loadings(calibration_tbl)
    
    ensemble_weighted <- ensemble_weighted(object         = calibration_tbl,
                                           loadings       = loadings_tbl$rank,
                                           scale_loadings = TRUE
    )

    ensemble_tbl <- ensemble_tbl %>% add_modeltime_model(model = ensemble_weighted)
  }
  
  ensemble_calib_tbl <- ensemble_tbl %>% 
    modeltime_calibrate(new_data = test_data)
  
  return(ensemble_calib_tbl)
}
