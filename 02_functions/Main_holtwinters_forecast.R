holtwinters_forecast <-  function(train_data, season_function){
  
  model_fit_1_holtwinters <- exp_smoothing(season = season_function) %>%
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
