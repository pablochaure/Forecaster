holtwinters_forecast <-
function(train_data, season_function){
  
  model_fit_1_holtwinters <- exp_smoothing(season = season_function) %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)
  
  return(model_fit_1_holtwinters)
}
