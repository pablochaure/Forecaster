holt_forecast <-  function(train_data, trend_function){
  
  model_fit_1_holt <- exp_smoothing(trend  = trend_function,
                                    season = "none") %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)

  return(model_fit_1_holt)
}


# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "holt_forecast"
    ),
    
    file = "00_scripts/f_holt_forecast.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "holt_forecast"
    ),
    
    file = "00_scripts/f_holt_forecast.R",
    append = FALSE)
}
