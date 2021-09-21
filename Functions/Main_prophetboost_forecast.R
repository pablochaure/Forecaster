prophetboost_forecast <-  function(recipe){
  wflw_spec_prophetboost <- workflow() %>% 
    add_model(
      prophet_boost(seasonality_daily  = FALSE,
                    seasonality_weekly = FALSE,
                    seasonality_yearly = FALSE
      ) %>%
        set_engine("prophet_xgboost")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_prophetboost)
  
}


# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "prophetboost_forecast"
    ),
    
    file = "00_scripts/f_prophetboost_forecast.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "prophetboost_forecast"
    ),
    
    file = "00_scripts/f_prophetboost_forecast.R",
    append = FALSE)
}
