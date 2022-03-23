randomforest_forecast <-  function(recipe){
  wflw_spec_rf <- workflow() %>% 
    add_model(
      rand_forest() %>% set_engine("ranger")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_rf)
}

# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "randomforest_forecast"
    ),
    
    file = "01_source/f_randomforest_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "randomforest_forecast"
    ),
    
    file = "01_source/f_randomforest_forecast.R",
    append = FALSE)
}
