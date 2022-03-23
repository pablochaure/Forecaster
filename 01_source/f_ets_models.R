ets_models <-
function(input, dat, trend_function, season_function){
  
  modeltime_table_ets <- modeltime_table()
  
  if ("Auto" %in% input){
    
    model_fit_auto_ets <- exp_smoothing() %>% 
      set_engine("ets") %>% 
      fit(Value ~ Date,
          data = dat)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_auto_ets)
    
    print("AUTO ETS model ok!")
  }
  
  if ("Simple" %in% input){
    model_fit_simple_ets <- ses_forecast(train_data = dat)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_simple_ets)
    
    print("SIMPLE ETS model ok!")
    
  }
  
  if ("Holt" %in% input){
    
    model_fit_double_ets <- holt_forecast(train_data     = dat,
                                          trend_function = trend_function)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_double_ets)
    
    print("DOUBLE/HOLT ETS model ok!")
    
  }
  
  if ("Holt-Winters" %in% input){
    
    model_fit_holtwinters_ets <- holtwinters_forecast(train_data      = dat,
                                                      season_function = season_function)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_holtwinters_ets)
    
    print("HOLT-WINTERS ETS model ok!")
  }

  return(modeltime_table_ets)
}
