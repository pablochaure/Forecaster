ses_forecast <-
function(train_data, error = "additive"){
  
  model_fit_1_ses <- exp_smoothing_custom(error  = error,
                                          trend  = "none",
                                          season = "none") %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)
  
  
  return(model_fit_1_ses)
}
