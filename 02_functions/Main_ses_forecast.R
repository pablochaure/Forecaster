ses_forecast <-  function(train_data, error = "additive"){
  
  model_fit_1_ses <- exp_smoothing_custom(error  = error,
                                          trend  = "none",
                                          season = "none") %>%
    set_engine("ets") %>%
    fit(Value ~ Date,
        data = train_data)
  
  
  return(model_fit_1_ses)
}


# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "ses_forecast"
    ),
    
    file = "01_source/f_ses_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "ses_forecast"
    ),
    
    file = "01_source/f_ses_forecast.R",
    append = FALSE)
}
