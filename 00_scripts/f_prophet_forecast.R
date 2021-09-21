prophet_forecast <-
function(recipe){
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
