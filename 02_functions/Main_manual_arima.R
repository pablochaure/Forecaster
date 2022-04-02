### MANUAL ARIMA ###
arima_manual <- function(p = 0, q = 0, d = 0, s = 1, P = 0, D = 0, Q = 0, train_data, input){
  
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




# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "arima_manual"
    ),
    
    file = "01_source/f_manual_arima.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "arima_manual"
    ),
    
    file = "01_source/f_manual_arima.R",
    append = FALSE)
}
