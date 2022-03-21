randomforest_forecast <-
function(recipe){
  wflw_spec_rf <- workflow() %>% 
    add_model(
      rand_forest() %>% set_engine("ranger")
    ) %>% 
    add_recipe(recipe)
  
  return(wflw_spec_rf)
}
