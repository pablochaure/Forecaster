library(parsnip)
library(forecast)
library(rsample)
library(modeltime)
library(tidyverse)
library(timetk)
library(rlang)
library(tidymodels)
library(modeltime.ensemble)
library(lubridate)
interactive <- FALSE


m750 <- m4_monthly %>% filter(id == "M750")

m750 %>% plot_time_series(date, value, .interactive = interactive, .title="M750 data")

horizon  <- 20

## EXTENDING data ----
trans_fun     <- log1p
trans_fun_inv <- expm1

# print(rv$data)
full_data_tbl <- m750 %>%

  # Remove missing values
  na.omit() %>%
  
  # Apply transformation
  mutate(value = ifelse(value < 0, 0, value)) %>%
  mutate(value = trans_fun(value)) %>%
  
  future_frame(
    .date_var   = date,
    .length_out = horizon,
    .bind_data  = TRUE
  ) %>%
  
  ungroup()

# Data Prepared
actual_data <- full_data_tbl %>%
  filter(!is.na(value))

data_prepared_tbl <- actual_data %>%
  drop_na()

data_prepared_tbl %>% plot_time_series(date, value, .interactive = interactive, .title="M750 data")

future_tbl <- full_data_tbl %>%
  filter(is.na(value))

## SPLITTING data----
splits <- data_prepared_tbl %>%
  time_series_split(
    date_var   = date,
    assess     = horizon,
    cumulative = TRUE
  )

recipe_spec_1 <- recipe(formula = value ~ .,
                        data    = training(splits)) %>%
  step_timeseries_signature(date) %>%
  step_rm(matches("(.iso$)|(.xts$)|(day)|(hour)|(minute)|(second)|(am.pm)")) %>%
  step_normalize(matches("(_index.num$)|(_year$)")) %>%
  step_mutate(date_week = factor(date_week, ordered = TRUE)) %>% 
  step_dummy(all_nominal(), one_hot = TRUE)

recipe_spec_1 %>% prep() %>% juice() %>% glimpse()

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

model_spec_prophetboost <- prophet_boost() %>% 
  set_engine("prophet_xgboost")

w_model_fit_prophetboost <- workflow() %>% 
  add_recipe(recipe_spec_1) %>%
  add_model(model_spec_prophetboost) %>%
  fit(training(splits))


calibration_tbl <- modeltime_table(
  w_model_fit_prophet,
  w_model_fit_prophetboost
) %>%
  modeltime_calibrate(
    new_data = testing(splits))

calibration_tbl %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = data_prepared_tbl
  ) %>%
  mutate(
    across(.cols = c(.value, .conf_lo, .conf_hi),
           .fns  = function(x) trans_fun_inv(x))
  ) %>% 
  plot_modeltime_forecast()

accuracy_tbl <- calibration_tbl %>% 
  mutate(.calibration_data = map(.calibration_data, .f = function(tbl){
    tbl %>% 
      mutate(
        .actual     = trans_fun_inv(.actual),
        .prediction = trans_fun_inv(.prediction),
        .residuals  = .actual - .prediction
      )
  })) %>% 
  modeltime_accuracy()

accuracy_tbl

refit_tbl <- calibration_tbl %>%
  modeltime_refit(data = data_prepared_tbl)

future_forecast_tbl <- refit_tbl %>%
  modeltime_forecast(
    new_data    = future_tbl,
    actual_data = data_prepared_tbl,
    keep_data   = TRUE
  ) %>% 
  mutate(
    across(.cols = c(.value, .conf_lo, .conf_hi),
           .fns  = function(x) trans_fun_inv(x))
  )

future_forecast_tbl %>% plot_modeltime_forecast()





##Ensemble----

ensemble_mean <- ensemble_average(object = calibration_tbl,
                                  type   = "mean")

ensemble_tbl <- modeltime_table()
ensemble_tbl <- ensemble_tbl %>% add_modeltime_model(model = ensemble_mean)

ensemble_calib_tbl <- ensemble_tbl %>% 
  modeltime_calibrate(new_data = testing(splits))

ensemble_calib_tbl

ensemble_accuracy_tbl <- ensemble_calib_tbl %>% 
  mutate(.calibration_data = map(.calibration_data, .f = function(tbl){
    tbl %>% 
      mutate(
        .actual     = trans_fun_inv(.actual),
        .prediction = trans_fun_inv(.prediction),
        .residuals  = .actual - .prediction
      )
  })) %>% 
  modeltime_accuracy()

ensemble_refit_tbl <- ensemble_calib_tbl %>% 
  modeltime_refit(data = data_prepared_tbl)

ensemble_refit_tbl

ensemble_future_forecast_tbl <- ensemble_refit_tbl %>% 
  modeltime_forecast(
    new_data    = future_tbl,
    actual_data = data_prepared_tbl,
    keep_data   = TRUE
  ) %>% 
  mutate(
    across(.cols = c(.value, .conf_lo, .conf_hi),
           .fns  = function(x) trans_fun_inv(x))
  )

ensemble_future_forecast_tbl %>% plot_modeltime_forecast()
