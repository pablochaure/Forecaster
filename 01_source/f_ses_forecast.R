ses_forecast <-
function(train_data){
  
  model_fit_1_ses <- exp_smoothing(trend  = "none",
                                   season = "none") %>%
    set_engine("ets",
               beta  = NULL,
               gamma = NULL) %>%
    fit(Value ~ Date,
        data = train_data)
  
  
  return(model_fit_1_ses)
}
