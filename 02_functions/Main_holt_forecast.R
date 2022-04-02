holt_forecast <-  function(train_data, error = "additive", trend = "additive", damping = "auto"){
  
  model_fit_1_holt <- exp_smoothing_custom(error   = error,
                                           trend   = trend,
                                           season  = "none",
                                           damping = damping) %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)

  return(model_fit_1_holt)
}


# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "holt_forecast"
    ),
    
    file = "01_source/f_holt_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "holt_forecast"
    ),
    
    file = "01_source/f_holt_forecast.R",
    append = FALSE)
}
