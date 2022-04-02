nbeats_forecast <-
function(train_data,
                             freq,
                             horizon,
                             epochs        = 20,
                             bagging       = 3,
                             loss_function = 'sMAPE'){
  model_fit_nbeats <- nbeats(id                = "id",
                             freq              = frequency_to_pandas(freq),
                             prediction_length = horizon,
                             lookback_length   = c(2,4) * horizon,
                             loss_function     = loss_function,
                             epochs            = epochs,
                             bagging_size      = bagging,
                             scale             = TRUE) %>%
    set_engine("gluonts_nbeats_ensemble") %>% 
    fit(Value ~ ., data = train_data)
  
  return(model_fit_nbeats)
}
