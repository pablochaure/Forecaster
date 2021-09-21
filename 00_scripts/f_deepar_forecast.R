deepar_forecast <-
function(train_data,
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
