DL_models <-
function(input,
                      train_data, 
                      freq, 
                      horizon, 
                      epochs        = 20, 
                      bagging       = 3,
                      loss_function = 'sMAPE'){
  modeltime_table_DL <- modeltime_table()
  
  if("Deep AR" %in% input){
    model_fit_deepar <- deepar_forecast(train_data      = train_data,
                                        freq            = freq,
                                        horizon         = horizon,
                                        epochs          = epochs)
    
    modeltime_table_DL <- modeltime_table_DL %>% 
      add_modeltime_model(model = model_fit_deepar)
    
    print("Deep AR model ok!")
  }
  
  if("NBeats Ensemble" %in% input){
    model_fit_nbeats <- nbeats_forecast(train_data    = train_data,
                                        freq          = freq,
                                        horizon       = horizon,
                                        epochs        = epochs,
                                        bagging       = bagging,
                                        loss_function = loss_function)
    
    modeltime_table_DL <- modeltime_table_DL %>% 
      add_modeltime_model(model = model_fit_nbeats)
    
    print("NBeats Ensemble model ok!")
  }
  
  return(modeltime_table_DL)
}
