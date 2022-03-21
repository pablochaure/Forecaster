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

# 1_DATA INPUT----
google_analytics_summary_tbl <- read_rds("00_data/google_analytics_summary_hourly.rds")
google_analytics_summary_tbl
horizon <- 24 * 7 *4 #One month

google_analytics_summary_tbl <- google_analytics_summary_tbl %>%
  mutate(date = ymd_h(dateHour)) %>%
  select(-dateHour)

## Time signature features
google_analytics_summary_signature_tbl <- google_analytics_summary_tbl %>%
  tk_augment_timeseries_signature(date) %>%
  select(-diff, -ends_with("iso"), -ends_with(".xts"),
         -contains("hour"), -contains("minute"), -contains("second"), -contains("am.pm"))

google_analytics_summary_extended_tbl <- google_analytics_summary_signature_tbl %>%
  bind_rows(
    future_frame(.data = ., .date_var = date, .length_out = horizon)
  )

google_analytics_summary_actual_tbl <- google_analytics_summary_extended_tbl %>%
  filter(!is.na(across(pageViews:sessions)))

google_analytics_summary_forecast_tbl <- google_analytics_summary_extended_tbl %>%
  filter(is.na(across(pageViews:sessions)))


### Data for visualizations
google_analytics_summary_long_tbl <- google_analytics_summary_tbl %>%
  pivot_longer(-date) %>%
  group_by(name)


# 2_EXPLORATION ----
google_analytics_summary_long_tbl %>%
  plot_time_series(date, value)

google_analytics_summary_long_tbl %>%
  plot_acf_diagnostics(date, value)
### lags 24, 168, 336

google_analytics_summary_long_tbl %>%
  plot_seasonal_diagnostics(date, value)

google_analytics_summary_long_tbl %>%
  plot_anomaly_diagnostics(date, value)

google_analytics_summary_long_tbl %>%
  plot_stl_diagnostics(date, value)


#3_TRANSFORMATIONS ----

## Box-cox variance reduction
google_analytics_summary_long_tbl %>%
  plot_time_series(date, box_cox_vec(value, lambda = "auto"))



#4_TRAIN/TEST SPLIT ----
splits <- time_series_split(google_analytics_summary_actual_tbl, assess = horizon, cumulative = TRUE)

splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(date, pageViews)

train_tbl <- training(splits)

test_tbl <- testing(splits)

#5_MODEL ----

## AUTO_ARIMA
model_fit_auto_arima <- arima_reg() %>%
  set_engine("auto_arima") %>%
  fit(pageViews ~ date
       , 
      data = train_tbl)

model_fit_auto_arima

## Model tibble
models_tbl <- modeltime_table(
  model_fit_auto_arima
)

models_tbl

## Accuracy tibble
accuracy_tbl <- models_tbl %>%
  modeltime_calibrate(testing(splits))

accuracy_tbl

#6_FORECAST ----

## Forecast in test set
forecast_tbl <- models_tbl %>% 
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = google_analytics_summary_actual_tbl
  )

forecast_tbl

### plot
forecast_tbl %>%
  plot_modeltime_forecast()

### Accuracy in test set
accuracy_tbl %>% modeltime_accuracy()

#7_REFITTING ----

refit_tbl <- accuracy_tbl %>%
  modeltime_refit(google_analytics_summary_actual_tbl)

refit_tbl

forecast_refit_tbl <- refit_tbl %>%
  modeltime_forecast(
    new_data = google_analytics_summary_forecast_tbl,
    actual_data = google_analytics_summary_actual_tbl
  )

forecast_refit_tbl

forecast_refit_tbl %>%
  plot_modeltime_forecast()

