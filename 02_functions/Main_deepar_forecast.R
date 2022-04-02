deepar_forecast <- function(train_data,
                            freq,
                            horizon, 
                            epochs = 20){
  model_fit_deepar <- deep_ar(id                = "id",
                              freq              = frequency_to_pandas(freq),
                              prediction_length = horizon,
                              epochs            = epochs,
                              lookback_length   = 2*horizon,
                              scale             = TRUE) %>%
  
    set_engine("gluonts_deepar") %>% 
    fit(Value ~ ., data = train_data)
  
  return(model_fit_deepar)
}

# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "deepar_forecast"
    ),
    
    file = "01_source/f_deepar_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "deepar_forecast"
    ),
    
    file = "01_source/f_deepar_forecast.R",
    append = FALSE)
}





# 
# deepar_forecast(train_data = training(splits) %>% rename(Value = revenue),
#                 freq = tk_get_timeseries_summary(transactions_tbl$purchased_at)$scale,
#                 horizon = 12)
