prophetboost_forecast <-
function(recipe){
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
