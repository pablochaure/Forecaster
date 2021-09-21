ml_models <-  function(input, recipe_1, recipe_2){
   wflw_spec_list = list() 
  
  if ("Prophet" %in% input){
    wflw_spec_prophet <- prophet_forecast(recipe_1)
    wflw_spec_list <- wflw_spec_list %>% list.append(wflw_spec_prophet)
  }
  if ("XGBoost" %in% input){
    wflw_spec_xgboost <- xgboost_forecast(recipe_2)
    wflw_spec_list <- wflw_spec_list %>% list.append(wflw_spec_xgboost)
  }
  if ("Prophet Boost" %in% input){
    wflw_spec_prophetboost <- prophetboost_forecast(recipe_1)
    wflw_spec_list <- wflw_spec_list %>% list.append(wflw_spec_prophetboost)
  }
  if ("Random Forest" %in% input){
    wflw_spec_rf <- randomforest_forecast(recipe_2)
    wflw_spec_list <- wflw_spec_list %>% list.append(wflw_spec_rf)
  }
  
  spec_table <- tibble(
    wflw_spec = wflw_spec_list
  )
  return(spec_table)
}


# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "ml_models"
    ),
    
    file = "00_scripts/f_ml_models.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "ml_models"
    ),
    
    file = "00_scripts/f_ml_models.R",
    append = FALSE)
}
