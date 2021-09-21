xgboost_forecast <-
function(recipe){
  wflw_spec_xgboost <- workflow() %>% 
    add_model(boost_tree() %>% set_engine("xgboost")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_xgboost)
}
