holt_forecast <-
function(train_data, trend_function){
  
  model_fit_1_holt <- exp_smoothing(trend  = trend_function,
                                    season = "none") %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)

  return(model_fit_1_holt)
}
