arima_manual <-
function(p = 0, q = 0, d = 0, s = 1, P = 0, D = 0, Q = 0, train_data, input){
  
  if(input$sarima_checkbox == FALSE){
    model <- arima_reg(non_seasonal_ar          = p,
                       non_seasonal_differences = d,
                       non_seasonal_ma          = q ) %>%
      set_engine("arima") %>%
      fit(Value ~ Date,
          data = train_data)
    return(model)
    
  }else if(input$sarima_checkbox != FALSE){
    model <- arima_reg(non_seasonal_ar          = p,
                       non_seasonal_differences = d,
                       non_seasonal_ma          = q,
                       seasonal_period          = s,
                       seasonal_ar              = P,
                       seasonal_differences     = D,
                       seasonal_ma              = Q
    ) %>%
    set_engine("arima") %>%
    fit(Value ~ Date,
        data = train_data)
    return(model)
    
  }
}
