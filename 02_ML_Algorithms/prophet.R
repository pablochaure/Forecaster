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

# transforming forecasting value to log and standardizing
transactions_trans_tbl <- transactions_tbl %>%
  mutate(Value = log(Value)) %>%
  mutate(Value = standardize_vec((Value)))

plot_time_series(transactions_trans_tbl,
                 .date_var = Date,
                 .value = Value)

std_mean <- 11.2910425517621
std_sd   <- 0.655408027721517
horizon  <- 20

transactions_trans_full_tbl <- transactions_trans_tbl %>%
  bind_rows(
    future_frame(.data = ., .date_var = Date, .length_out = horizon)
  )

trans_actual_tbl <- transactions_trans_full_tbl %>%
  filter(!is.na(Value))

trans_future_tbl <- transactions_trans_full_tbl %>%
  filter(is.na(Value))

# 2_TRAIN/TEST SPLIT ----
splits <- time_series_split(data       = transactions_trans_tbl,
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
  step_mutate(Date_week = factor(Date_week,ordered = TRUE)) %>% 
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

# * Calibration ----

calibration_tbl <- modeltime_table(
  p_model_fit_prophet,
  w_model_fit_prophet
) %>%
  modeltime_calibrate(testing(splits))

# * Forecast Test ----

calibration_tbl %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = transactions_trans_tbl
  ) %>%
  plot_modeltime_forecast()

# * Accuracy Test ----

calibration_tbl %>% modeltime_accuracy()


# * Refit ----

refit_tbl <- calibration_tbl %>%
  modeltime_refit(data = transactions_trans_tbl)

forecast_tbl <- refit_tbl %>%
  modeltime_forecast(
    new_data = trans_future_tbl,
    actual_data = transactions_trans_tbl
  ) 

forecast_tbl %>%
  pivot_longer(cols = c(.value, .conf_lo, .conf_hi)) %>%
  plot_time_series(.date_var = .index,.value = value, .color_var = name, .smooth = FALSE)

forecast_tbl %>%
  pivot_longer(cols = c(.value, .conf_lo, .conf_hi)) %>%
  plot_time_series(
    .index, 
    expm1(standardize_inv_vec(value, mean = std_mean, sd = std_sd)),
    .color_var = name,
    .smooth = FALSE
  )

#RESIDUALS ----
### (errors)

residuals_out_tbl <- calibration_tbl %>%
  modeltime_residuals()

residuals_in_tbl <- calibration_tbl %>%
  modeltime_residuals(
    training(splits) %>% drop_na()
  )

# Out-of-Sample 
residuals_out_tbl %>% 
  plot_modeltime_residuals(
    .y_intercept = 0,
    .y_intercept_color = "blue"
  )

# In-Sample 
residuals_in_tbl %>% plot_modeltime_residuals

# * ACF Plot ----
### You want to see minimal autocorrelation in residuals.
# Out-of-Sample 
residuals_out_tbl %>%
  plot_modeltime_residuals(
    .type = "acf"
  )

# In-Sample
residuals_in_tbl %>%
  plot_modeltime_residuals(
    .type = "acf"
  )

# PROPHET CONCEPTS ----

# * Extract model ----

prophet_model <- p_model_fit_prophet$fit$models$model_1

prophet_fcst <- predict(prophet_model, 
                        newdata = training(splits) %>% rename(ds = 1, y = 2))

# * Visualize prophet model ----

plot(prophet_model, prophet_fcst) +
  add_changepoints_to_plot(prophet_model)

# * Visualize Additive Components ----

prophet_plot_components(prophet_model, prophet_fcst)











