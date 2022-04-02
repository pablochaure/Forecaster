xgboost_forecast <-  function(recipe){
  wflw_spec_xgboost <- workflow() %>% 
    add_model(boost_tree() %>% set_engine("xgboost")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_xgboost)
}

# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "xgboost_forecast"
    ),
    
    file = "01_source/f_xgboost_forecast.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "xgboost_forecast"
    ),
    
    file = "01_source/f_xgboost_forecast.R",
    append = FALSE)
}
