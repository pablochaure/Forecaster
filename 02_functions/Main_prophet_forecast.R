prophet_forecast <-  function(recipe){
  wflw_spec_prophet <- workflow() %>% 
    add_model(
      prophet_reg(seasonality_daily  = FALSE,
                  seasonality_weekly = FALSE,
                  seasonality_yearly = FALSE
      ) %>%
      set_engine("prophet")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_prophet)

}


# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "prophet_forecast"
    ),
    
    file = "01_source/f_prophet_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "prophet_forecast"
    ),
    
    file = "01_source/f_prophet_forecast.R",
    append = FALSE)
}
