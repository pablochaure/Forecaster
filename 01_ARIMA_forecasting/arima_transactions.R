# EY Forecasting Tool

# ARIMA forecasting model

# 0_PACKAGES ----

# Core 
library(tidyverse)
library(timetk)
library(lubridate)
library(plotly)

# EDA
library(DataExplorer)

# Time Series Machine Learning
library(tidymodels)
library(modeltime)

library(tidyquant)


# 1_DATA INPUT----
transactions_tbl <- read_rds("00_data/transactions_weekly.rds") %>%
  purrr::set_names(c("Date", "Value"))

transactions_tbl

horizon <- 13

plot_time_series(transactions_tbl,
                 .date_var = Date,
                 .value = Value)

# 2_DATA TRANSFORMATION----
transactions_trans_tbl <- transactions_tbl %>%
  mutate(Value = log1p(Value)) %>%
  mutate(Value = standardize_vec((Value)))

plot_time_series(transactions_trans_tbl,
                 .date_var = Date,
                 .value = Value)

std_mean <- 11.2910425517621
std_sd <- 0.655408027721517

plot_acf_diagnostics(transactions_trans_tbl,
                     Date,
                     diff_vec(Value))

#3_ DATA EXTENSION ----
transactions_trans_full_tbl <- transactions_trans_tbl %>%
  bind_rows(
    future_frame(.data = ., .date_var = Date, .length_out = horizon)
  )

trans_actual_tbl <- transactions_trans_full_tbl %>%
  filter(!is.na(Value))

trans_future_tbl <- transactions_trans_full_tbl %>%
  filter(is.na(Value))

# 4_TRAIN/TEST SPLIT ----
splits <- time_series_split(data       = transactions_trans_tbl,
                            date_var   = Date,
                            assess     = horizon,
                            cumulative = TRUE)

splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(Date, Value)

#5_ MODELLING----

##1/7 Models----
##*1.Basic ARIMA ----
model_fit_1_arima_basic <- arima_reg() %>%
  set_engine("auto_arima") %>%
  fit(Value ~ Date, training(splits))

model_fit_1_arima_basic

##*2.SARIMA(4) ----
model_fit_2_sarima <- arima_reg(
  seasonal_period = 4
  ) %>% 
  set_engine("auto_arima") %>% 
  fit(Value ~ Date,
      data = training(splits))

model_fit_2_sarima

##*3.Fourier ARIMA----
model_fit_3_fourier_arima <- arima_reg() %>% 
  set_engine("auto_arima") %>% 
  fit(Value ~ Date
      + fourier_vec(Date, period = c(1,3,4), K = 2),
      data = training(splits))
model_fit_3_fourier_arima

##*3.Fourier ARIMA----
model_fit_4_fourier_arima <- arima_reg() %>% 
  set_engine("auto_arima") %>% 
  fit(Value ~ Date
      + fourier_vec(Date, period = c(4), K = 2),
      data = training(splits))
model_fit_4_fourier_arima

##2/7 Modeltime table----
model_tbl_arima <- modeltime_table(
  model_fit_1_arima_basic,
  model_fit_2_sarima,
  model_fit_3_fourier_arima,
  model_fit_4_fourier_arima
)
model_tbl_arima

## 3/7 Calibration----
calibration_tbl <- model_tbl_arima %>%
  modeltime_calibrate(testing(splits))
calibration_tbl

## 4/7 Accuracy----
accuracy_tbl <- calibration_tbl %>% 
  modeltime_accuracy()
accuracy_tbl

## 5/7 Test Forecast----
forecast_tbl <- calibration_tbl %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = trans_actual_tbl
  )
forecast_tbl %>% 
  plot_modeltime_forecast()

## 6/7 Refitting to full dataset----
refit_tbl <-  calibration_tbl %>% 
  modeltime_refit(data = trans_actual_tbl
  )

## 7/7 Forecast future horizon----
future_forecast_tbl <- refit_tbl %>% 
  modeltime_forecast(new_data    = trans_future_tbl,
                     actual_data = trans_actual_tbl
  )

future_forecast_tbl %>%
  plot_modeltime_forecast()

## 8/7 Inverting transformations ----
refit_tbl %>%
  modeltime_forecast(new_data    = trans_future_tbl,
                     actual_data = trans_actual_tbl) %>%
  # Invert Transformation
  mutate(across(.value:.conf_hi, .fns = ~ standardize_inv_vec(
    x    = .,
    mean = std_mean,
    sd   = std_sd
  ))) %>%
  mutate(across(.value:.conf_hi, .fns = expm1)) %>%
  
  plot_modeltime_forecast()

