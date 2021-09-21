xgboost_forecast <-  function(recipe){
  wflw_spec_xgboost <- workflow() %>% 
    add_model(boost_tree() %>% set_engine("xgboost")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_xgboost)
}

# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "xgboost_forecast"
    ),
    
    file = "00_scripts/f_xgboost_forecast.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "xgboost_forecast"
    ),
    
    file = "00_scripts/f_xgboost_forecast.R",
    append = FALSE)
}
