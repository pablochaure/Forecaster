ses_forecast <-  function(train_data){
  
  model_fit_1_ses <- exp_smoothing(trend  = "none",
                                   season = "none") %>%
    set_engine("ets",
               beta  = NULL,
               gamma = NULL) %>%
    fit(Value ~ Date,
        data = train_data)
  
  
  return(model_fit_1_ses)
}


# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "ses_forecast"
    ),
    
    file = "00_scripts/f_ses_forecast.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "ses_forecast"
    ),
    
    file = "00_scripts/f_ses_forecast.R",
    append = FALSE)
}
