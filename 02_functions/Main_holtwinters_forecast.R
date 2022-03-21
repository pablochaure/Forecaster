holtwinters_forecast <-  function(train_data, season_function){
  
  model_fit_1_holtwinters <- exp_smoothing(season = season_function) %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)
  
  return(model_fit_1_holtwinters)
}



# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "holtwinters_forecast"
    ),
    
    file = "00_scripts/f_holtwinters_forecast.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "holtwinters_forecast"
    ),
    
    file = "00_scripts/f_holtwinters_forecast.R",
    append = FALSE)
}
