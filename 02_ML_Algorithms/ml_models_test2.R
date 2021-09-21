#### PROPHET MODEL:

# LIBRARIES ----
library(modeltime)
library(tidymodels)
library(timetk)
library(plotly)
library(prophet)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(rlist)

# 1_DATA INPUT----
transactions_tbl <- read_rds("00_data/transactions_weekly.rds") %>%
  purrr::set_names(c("Date", "Value"))

transactions_tbl

plot_time_series(transactions_tbl,
                 .date_var = Date,
                 .value = Value)
horizon  <- 20

transactions_full_tbl <- transactions_tbl %>%
  bind_rows(
    future_frame(.data = ., .date_var = Date, .length_out = horizon)
  )

trans_actual_tbl <- transactions_full_tbl %>%
  filter(!is.na(Value))

trans_future_tbl <- transactions_full_tbl %>%
  filter(is.na(Value))

# 2_TRAIN/TEST SPLIT ----
splits <- time_series_split(data       = transactions_tbl,
                            date_var   = Date,
                            assess     = horizon,
                            cumulative = TRUE)

splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(Date, Value)

# 3_PREPROCESSOR ----
recipe_spec_1 <- recipe(formula = Value ~ .,
                        data = training(splits)) %>%
  step_timeseries_signature(Date) %>%
  step_rm(matches("(.iso$)|(.xts$)|(day)|(hour)|(minute)|(second)|(am.pm)")) %>%
  step_normalize(matches("(index.num)|(year)")) %>%
  step_mutate(Date_week = factor(Date_week, ordered = TRUE)) %>% 
  step_dummy(all_nominal(), one_hot = TRUE)

recipe_spec_1 %>% prep() %>% juice() %>% glimpse()

recipe_spec_2 <- recipe_spec_1 %>% 
  update_role(Date,new_role = "ID")

recipe_spec_2 %>% prep() %>% juice() %>% glimpse()

# 4_MODEL ----

##parsnip model ----
p_model_fit_prophet <- prophet_reg(
  changepoint_num    = 25,
  changepoint_range  = 0.8,
  seasonality_yearly = TRUE,
  seasonality_weekly = TRUE) %>%
  
  set_engine("prophet") %>%
  
  fit(Value ~ Date, data = training(splits))

## Workflow model ----
model_spec_prophet <- prophet_reg(changepoint_num    = 25,
                                  changepoint_range  = 0.8,
                                  seasonality_yearly = TRUE,
                                  seasonality_weekly = TRUE) %>%
  set_engine("prophet")

w_model_fit_prophet <- workflow() %>%
  add_recipe(recipe_spec_1) %>%
  add_model(model_spec_prophet) %>%
  fit(training(splits))

w_model_fit_prophet

##Prophet boost----
w_model_fit_prophetboot <- workflow() %>% 
  add_model(prophet_boost() %>%
            set_engine("prophet_xgboost")) %>% 
  add_recipe(recipe_spec_1) %>% 
  fit(training(splits))
  
##xgboost----
w_model_fit_xgboost <-  workflow() %>% 
  add_model(boost_tree() %>% 
              set_engine("xgboost")) %>% 
  add_recipe(recipe_spec_2) %>% 
  fit(training(splits))

# * Calibration ----

calibration_tbl <- modeltime_table(
  p_model_fit_prophet,
  w_model_fit_prophet,
  w_model_fit_prophetboot,
  w_model_fit_xgboost
) %>%
  modeltime_calibrate(testing(splits))

# * Forecast Test ----

calibration_tbl %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = transactions_tbl
  ) %>%
  plot_modeltime_forecast()

# * Accuracy Test ----

calibration_tbl %>% modeltime_accuracy()


# * Refit ----

refit_tbl <- calibration_tbl %>%
  modeltime_refit(data = transactions_full_tbl)

future_forecast_tbl <- refit_tbl %>% 
  modeltime_forecast(new_data = trans_future_tbl, actual_data = trans_actual_tbl,keep_data = TRUE)

