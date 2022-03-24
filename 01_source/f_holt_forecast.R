holt_forecast <-
function(train_data, error = "additive", trend = "additive", damping = "auto"){
  
  model_fit_1_holt <- exp_smoothing(error   = error,
                                    trend   = trend,
                                    season  = "none",
                                    damping = damping) %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)

  return(model_fit_1_holt)
}
