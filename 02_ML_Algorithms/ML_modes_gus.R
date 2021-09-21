library(parsnip)
library(forecast)
library(rsample)
library(modeltime)
library(tidyverse)
library(timetk)
library(rlang)
library(tidymodels)
library(lubridate)
interactive <- FALSE


# Data
m750 <- m4_monthly %>% filter(id == "M750")

eur <- read_csv("00_data/eurusd.csv")
vix <- read_csv("00_data/vix.csv")
sin <- read_csv("00_data/sin.csv")
transactions <- read_csv(file = "00_data/transactions_weekly.csv")
transactions$value <- transactions$revenue
transactions$date <- transactions$purchased_at

eur$value <- eur$close
vix$value <- vix$close

m750 %>% plot_time_series(date, value, .interactive = interactive, .title="M750 data")
eur %>% plot_time_series(date, value, .interactive = interactive, .title="EURUSD data")
vix %>% plot_time_series(date, value, .interactive = interactive, .title="VIX data")
sin %>% plot_time_series(date, value, .interactive = interactive, .title="Sin data")


fit_plot_model <- function(input_data, interactive=FALSE, dif=FALSE, title){
  # Data processing
  input_data <- input_data %>% drop_na()
  
  if (dif){
    lista_datos <- input_data %>% pull(value) %>% diff
    input_data$diff <- c(0, lista_datos)
    # input_data[2:dim(input_data)[1],]
    
    input_data$value <- input_data$diff
  }
  
  splits <- initial_time_split(input_data, prop = 0.8)
  
  # Models
  model_fit_arima_no_boost <- arima_reg() %>%
    set_engine(engine = "auto_arima") %>%
    fit(value ~ date,
        data = training(splits))

  model_fit_arima_boosted <- arima_boost(
    min_n = 2,
    learn_rate = 0.015) %>%
    set_engine(engine = "auto_arima_xgboost") %>%
    fit(value ~ date + as.numeric(date) + factor(month(date), ordered = FALSE),
        data = training(splits))

  model_fit_prophet <- prophet_reg() %>%
    set_engine(engine = "prophet") %>%
    fit(value ~ date,
        data = training(splits))

  model_fit_prophet_boost <- prophet_boost() %>%
    set_engine(engine = "prophet_xgboost") %>%
    fit(value ~ date,
        data = training(splits))
  
  model_fit_lm <- linear_reg() %>%
    set_engine("lm") %>%
    fit(value ~ as.numeric(date) + factor(month(date), ordered = FALSE),
        data = training(splits))
  
  model_fit_ets <- exp_smoothing() %>%
    set_engine("ets") %>%
    fit(value ~ date,
        data = training(splits))
  
  model_fit_tbats <- seasonal_reg() %>%
    set_engine("tbats") %>%
    fit(value ~ date,
        data = training(splits))
  
  model_fit_nnetar <- nnetar_reg() %>%
    set_engine("nnetar") %>%
    fit(value ~ date,
        data = training(splits))
  
  model_fit_stlm_ets <- seasonal_reg() %>%
    set_engine("stlm_ets") %>%
    fit(value ~ date,
        data = training(splits))
  
  model_fit_stlm_arima <- seasonal_reg() %>%
    set_engine("stlm_arima") %>%
    fit(value ~ date,
        data = training(splits))
  
  model_spec_mars <- mars(mode = "regression") %>%
    set_engine("earth") 
  
  recipe_spec <- recipe(value ~ date, data = training(splits)) %>%
    step_date(date, features = "month", ordinal = FALSE) %>%
    step_mutate(date_num = as.numeric(date)) %>%
    step_normalize(date_num) %>%
    step_rm(date)
  
  wflw_fit_mars <- workflow() %>%
    add_recipe(recipe_spec) %>%
    add_model(model_spec_mars) %>%
    fit(training(splits))
  
  # Wrapping models
  models_tbl <- modeltime_table(
    model_fit_arima_no_boost,
    model_fit_arima_boosted,
    model_fit_prophet,
    model_fit_prophet_boost,
    model_fit_lm,
    model_fit_ets,
    model_fit_tbats,
    model_fit_nnetar,
    model_fit_stlm_ets,
    model_fit_stlm_arima,
    wflw_fit_mars
  )
  
  
  calibration_tbl <- models_tbl %>%
    modeltime_calibrate(new_data = testing(splits))
  
  return(calibration_tbl %>%
    modeltime_forecast(
      new_data    = testing(splits),
      actual_data = input_data
    ) %>%
    plot_modeltime_forecast(
      .legend_max_width = 25, # For mobile screens
      .interactive      = interactive,
      .title            = title
    )
  )
}

fit_plot_model(m750, interactive=TRUE, dif=FALSE, title="M750 Forecast - Original Serie")
fit_plot_model(eur, interactive=TRUE, dif=FALSE, title="EURUSD Forecast - Original Serie")
fit_plot_model(vix, interactive=TRUE, dif=FALSE, title="VIX Forecast - Original Serie")
fit_plot_model(sin, interactive=TRUE, dif=FALSE, title="SIN Forecast - Original Serie")
fit_plot_model(transactions,interactive = TRUE, dif = FALSE, title = "transactions- original")

fit_plot_model(transactions,interactive = TRUE, dif = TRUE, title = "transactions- diff")
fit_plot_model(m750, interactive=TRUE, dif=TRUE, title="M750 Forecast - Diff Serie")
fit_plot_model(eur, interactive=TRUE, dif=TRUE, title="EURUSD Forecast - Diff Serie")
fit_plot_model(vix, interactive=TRUE, dif=TRUE, title="VIX Forecast - Diff Serie")
fit_plot_model(sin, interactive=TRUE, dif=TRUE, title="SIN Forecast - Diff Serie")
