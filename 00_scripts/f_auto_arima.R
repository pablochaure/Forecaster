auto_arima_table <-
function(max_depth = 6, nrounds = 15, eta = 0.3, colsample_bytree = 1, min_child_weight = 1, gamma = 0, train_data, input){
  
  model_fit_1_arima_basic <- arima_reg() %>%
    set_engine("auto_arima") %>%
    fit(Value ~ Date,
        data = train_data)
  
  modeltime_table_autoarima <- modeltime_table(
    model_fit_1_arima_basic
  )
  
  if(input$arima_boost_checkbox == TRUE){
    model_fit_autoarimaboost <- arima_boost(tree_depth     = max_depth,
                                            trees          = nrounds,
                                            learn_rate     = eta,
                                            mtry           = colsample_bytree,
                                            min_n          = min_child_weight,
                                            loss_reduction = gamma
    ) %>% 
      set_engine("auto_arima_xgboost") %>% 
      fit(Value ~ Date + as.numeric(Date) + factor(lubridate::month(Date), ordered = FALSE),
          data = train_data)
    
    modeltime_table_autoarima <- modeltime_table_autoarima %>% 
      add_modeltime_model(model_fit_autoarimaboost)
    
    print("auto_arima_xgboost model ok!")
    return(modeltime_table_autoarima)
    
  }else{
    print("auto_arima mdoel ok!")
    return(modeltime_table_autoarima)
    
  }
}
