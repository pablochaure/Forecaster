ets_models <-
function(input, data, s_error, d_error, d_trend, d_damping, hw_error, hw_trend, hw_damping, hw_season){
  
  modeltime_table_ets <- modeltime_table()
  
  if ("Simple" %in% input){
    model_fit_simple_ets <- ses_forecast(train_data = data,
                                         error      = s_error)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_simple_ets)

    print("SIMPLE ETS model ok!")
    
  }
  
  if ("Holt" %in% input){
    
    model_fit_double_ets <- holt_forecast(train_data = data,
                                          error      = d_error,
                                          trend      = d_trend,
                                          damping    = d_damping)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_double_ets)
    
    print("DOUBLE/HOLT ETS model ok!")
    
  }
  
  if ("Holt-Winters" %in% input){
    
    model_fit_holtwinters_ets <- holtwinters_forecast(train_data = data,
                                                      error      = hw_error,
                                                      trend      = hw_trend,
                                                      damping    = hw_damping,
                                                      season     = hw_season)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_holtwinters_ets)
    
    print("HOLT-WINTERS ETS model ok!")
  }
  
  if ("Auto" %in% input){
    
    model_fit_auto_ets <- modeltime::exp_smoothing() %>% 
      set_engine("ets") %>% 
      fit(Value ~ Date,
          data = data)
    
    modeltime_table_ets <- modeltime_table_ets %>% 
      add_modeltime_model(model = model_fit_auto_ets)
    
    print("AUTO ETS model ok!")
  }
  
  return(modeltime_table_ets)
}
