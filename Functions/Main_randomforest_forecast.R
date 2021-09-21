randomforest_forecast <-  function(recipe){
  wflw_spec_rf <- workflow() %>% 
    add_model(
      rand_forest() %>% set_engine("ranger")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_rf)
}

# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "randomforest_forecast"
    ),
    
    file = "00_scripts/f_randomforest_forecast.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "randomforest_forecast"
    ),
    
    file = "00_scripts/f_randomforest_forecast.R",
    append = FALSE)
}
