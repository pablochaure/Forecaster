select_data <-
function(data = vars_data(), input){
  if (input$id_checkbox == 0){
    vars_data <- subset(data, select = c(input$date_var, input$value_var)) %>% 
      purrr::set_names(c("Date", "Value")) %>% 
      dplyr::mutate(Date = as.Date(Date)) %>% 
      dplyr::as_tibble()
  }
  else if (input$id_checkbox == 1){
    vars_data <- subset(data, select = c(input$date_var, input$value_var, input$id_var)) %>% 
      purrr::set_names(c("Date", "Value", "ID")) %>% 
      dplyr::mutate(Date = as.Date(Date)) %>% 
      dplyr::as_tibble()
  }
  return(vars_data)
}
