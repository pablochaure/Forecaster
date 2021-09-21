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

# Variable
dataset <- "archivo"
q
p
i



# 1_DATA INPUT----
transactions_tbl <- read_rds("00_data/transactions_weekly.rds") %>%
  purrr::set_names(c("Date", "Value"))

transactions_tbl

horizon <- 13 #One full quarter

# transactions_actual_signature_tbl <- transactions_tbl %>%
#   tk_augment_timeseries_signature(Date) %>%
#   select(-diff, -ends_with("iso"), -ends_with(".xts"),
#          -contains("hour"), -contains("minute"), -contains("second"), -contains("am.pm"))

transactions_full_tbl <- transactions_tbl %>%
  bind_rows(
    future_frame(.data = ., .date_var = Date, .length_out = horizon)
  )

actual_tbl <- transactions_full_tbl %>%
  filter(!is.na(Value))

future_tbl <- transactions_full_tbl %>%
  filter(is.na(Value))




# 2_EXPLORATION ----
actual_tbl %>%
  plot_time_series(Date, Value)

actual_tbl %>%
  plot_acf_diagnostics(Date, Value)

actual_tbl %>%
  plot_seasonal_diagnostics(Date, Value)

actual_tbl %>%
  plot_anomaly_diagnostics(Date, Value)

transactions_tbl %>%
  plot_stl_diagnostics(
    .date_var    = Date,
    .value       = Value,
    .title       = FALSE,
    .interactive = TRUE)

#3_TRANSFORMATIONS ----


#4_TRAIN/TEST SPLIT ----
splits <- time_series_split(actual_tbl,
                            assess = horizon,
                            cumulative = TRUE)

splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(Date, Value)

train_tbl <- training(splits)

test_tbl <- testing(splits)

#5_MODEL ----

#Preprocessor

recipe_spec_1 <- recipe(Value ~ ., training(splits)) %>%
  step_timeseries_signature(Date) %>%
  step_rm(matches("(.iso$)|(.xts$)|(day)|(hour)|(minute)|(second)|(am.pm)|(.lbl$)|(index)")) %>% 
  step_normalize(Date_year) 
  # step_mutate(Date_week = factor(Date_week, ordered = TRUE)) 
  # step_zv(all_predictors()) %>%
  # step_fourier(Date, period = c(4,8,12), K = 2) %>%
  # step_dummy(all_nominal(), one_hot = TRUE)

recipe_spec_1 %>% prep() %>% juice() %>% glimpse()
View(recipe_spec_1 %>% prep() %>% juice())
recipe_spec_1 %>% prep() %>% summary()

# a <-  recipe_spec_1 %>% prep() %>% juice()
# apply(X = a, MARGIN = 2, FUN = unique)

## AUTO_ARIMA
# if(cliente seleccion q, p ,i){
#   arima()
# }else{
transactions_model_fit_auto_arima <- arima_reg() %>%
    set_engine("auto_arima") %>%
    fit(Value ~ Date
        # + fourier_vec(Date, period = 4)
        # + fourier_vec(Date, period = 8)
        # + fourier_vec(Date, period = 12)
        + splines::ns(Date, df = 3),
        data = training(splits))
# }
transactions_model_fit_auto_arima

wflw_fit_autoarima <- workflow() %>%
  add_model(arima_reg() %>% set_engine("auto_arima")) %>%
  add_recipe(recipe_spec_1) %>%
  fit(training(splits))
  
    



## Model tibble
transactions_models_tbl <- modeltime_table(
  transactions_model_fit_auto_arima
)

transactions_models_tbl

## Accuracy tibble
transactions_accuracy_tbl <- transactions_models_tbl %>%
  modeltime_calibrate(testing(splits))

transactions_accuracy_tbl

#6_FORECAST ----

## Forecast in test set
forecast_tbl <- transactions_models_tbl %>% 
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = actual_tbl
  )

forecast_tbl

### plot
forecast_tbl %>%
  plot_modeltime_forecast()

### Accuracy in test set
transactions_accuracy_tbl %>% modeltime_accuracy()

#7_REFITTING ----

transactions_refit_tbl <- transactions_accuracy_tbl %>%
  modeltime_refit(actual_tbl)

transactions_forecast_refit_tbl <- transactions_refit_tbl %>%
  modeltime_forecast(
    new_data = future_tbl,
    actual_data = actual_tbl
  )

transactions_forecast_refit_tbl %>%
  plot_modeltime_forecast()

