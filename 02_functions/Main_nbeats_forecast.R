nbeats_forecast <-  function(train_data,
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

# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "nbeats_forecast"
    ),
    
    file = "01_source/f_nbeats_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "nbeats_forecast"
    ),
    
    file = "01_source/f_nbeats_forecast.R",
    append = FALSE)
}


# nbeats_forecast(train_data = training(splits) %>% rename(Value = revenue),
#                 freq = tk_get_timeseries_summary(transactions_tbl$purchased_at)$scale,
#                 horizon = 12)
