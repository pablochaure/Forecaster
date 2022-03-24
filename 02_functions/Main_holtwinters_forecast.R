holtwinters_forecast <-  function(train_data,  error = "additive", trend = "additive", damping = "auto", season = "additive"){
  
  model_fit_1_holtwinters <- exp_smoothing(error   = error,
                                           trend   = trend,
                                           season  = season,
                                           damping = damping) %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)
  
  return(model_fit_1_holtwinters)
}



# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "holtwinters_forecast"
    ),
    
    file = "01_source/f_holtwinters_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "holtwinters_forecast"
    ),
    
    file = "01_source/f_holtwinters_forecast.R",
    append = FALSE)
}
