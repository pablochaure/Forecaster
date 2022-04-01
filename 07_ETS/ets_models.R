data <- read_csv("00_data/m750.csv")

plot_time_series(data,.date_var = date,.value = value)

split <- data %>% 
  timetk::time_series_split(date   = date,
                                   assess     = 60,
                                   cumulative = TRUE)

split %>% 
  timetk::tk_time_series_cv_plan() %>% 
  timetk::plot_time_series_cv_plan(.date_var = date,.value = value)

data %>% timetk::plot_stl_diagnostics(.date_var = date,.value = value)

model_table <- modeltime_table()


# SIMPLE ----
# simple additive - model_fit_ANN----
model_fit_ANN <- exp_smoothing(error = "additive",
                               trend = "none",
                               season = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_ANN
model_table <- model_table %>% add_modeltime_model(model_fit_ANN)


# simple multiplicative - model_fit_MNN----
model_fit_MNN <- exp_smoothing(error = "multiplicative",
                               trend = "none",
                               season = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MNN
model_table <- model_table %>% add_modeltime_model(model_fit_MNN)

# simple auto (multiplicative) - model_fit_AutoNN----
model_fit_AutoNN <- exp_smoothing(error = "auto",
                                  trend = "none",
                                  season = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AutoNN
model_table <- model_table %>% add_modeltime_model(model_fit_AutoNN)

# For each method there exist two models: one with additive errors and one with multiplicative errors.
# The point forecasts produced by the models are identical if they use the same smoothing parameter values.
# They will, however, generate different prediction intervals.

# ..................................................................----
# DOUBLE ----
# double additive - model_fit_AAN----
model_fit_AAN <- exp_smoothing(error = "additive",
                               trend = "additive",
                               season = "none",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AAN
model_table <- model_table %>% add_modeltime_model(model_fit_AAN)

# double additive damped - model_fit_AAdN----
model_fit_AAdN <- exp_smoothing(error = "additive",
                               trend = "additive",
                               season = "none",
                               damping = "damped") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AAdN
model_table <- model_table %>% add_modeltime_model(model_fit_AAdN)

# double additive autodamped (not damped) - model_fit_AADN----
model_fit_AADN <- exp_smoothing(error = "additive",
                                trend = "additive",
                                season = "none",
                                damping = "auto") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AADN
model_table <- model_table %>% add_modeltime_model(model_fit_AADN)

# ***FORBIDDEN double multiplicative model_fit_AMN----
model_fit_AMN <- exp_smoothing(error = "additive",
                               trend = "multiplicative",
                               season = "none",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AMN
model_table <- model_table %>% add_modeltime_model(model_fit_AMN)

# ***FORBIDDEN double multiplicative damped model_fit_AMdN ----
model_fit_AMdN <- exp_smoothing(error = "additive",
                               trend = "multiplicative",
                               season = "none",
                               damping = "damped") %>%
  set_engine("ets",allow.multiplicative.trend = TRUE) %>%
  fit(value ~ date,
      data = training(split))
model_fit_AMdN
model_table <- model_table %>% add_modeltime_model(model_fit_AMdN)

# Holt models do not work with multiplicative trend
# ets() allow.multiplicative.trend does not work
# ets(forecast::wineind, model = "AMA", allow.multiplicative.trend = TRUE)

# double additive - model_fit_MAN----
model_fit_MAN <- exp_smoothing(error = "multiplicative",
                               trend = "additive",
                               season = "none",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MAN
model_table <- model_table %>% add_modeltime_model(model_fit_MAN)

# double additive damped - model_fit_MAdN----
model_fit_MAdN <- exp_smoothing(error = "multiplicative",
                               trend = "additive",
                               season = "none",
                               damping = "damped") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MAdN
model_table <- model_table %>% add_modeltime_model(model_fit_MAdN)

# double additive autodamped (not damped) - model_fit_MADN----
model_fit_MADN <- exp_smoothing(error = "multiplicative",
                               trend = "additive",
                               season = "none",
                               damping = "auto") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MADN
model_table <- model_table %>% add_modeltime_model(model_fit_MADN)

# double multiplicative - model_fit_MMN----
model_fit_MMN <- exp_smoothing(error = "multiplicative",
                               trend = "multiplicative",
                               season = "none",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMN
model_table <- model_table %>% add_modeltime_model(model_fit_MMN)

# double multiplicative damped - model_fit_MMdN----
model_fit_MMdN <- exp_smoothing(error = "multiplicative",
                               trend = "multiplicative",
                               season = "none",
                               damping = "damped") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMdN
model_table <- model_table %>% add_modeltime_model(model_fit_MMdN)

# double multiplicative autodamped (not damped) - model_fit_MMDN----
model_fit_MMDN <- exp_smoothing(error = "multiplicative",
                                trend = "multiplicative",
                                season = "none",
                                damping = "auto") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMDN
model_table <- model_table %>% add_modeltime_model(model_fit_MMDN)

# ..................................................................----
# HOLT-WINTERS'----
# Additive Holt-Winters’ - model_fit_AAA----
model_fit_AAA <- exp_smoothing(error = "additive",
                               trend = "additive",
                               season = "additive",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AAA
model_table <- model_table %>% add_modeltime_model(model_fit_AAA)

# ***FOREBIDDEN Multiplicative Holt-Winters’ - model_fit_AAM----
model_fit_AAM <- exp_smoothing(error = "additive",
                               trend = "additive",
                               season = "multiplicative",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AAM
model_table <- model_table %>% add_modeltime_model(model_fit_AAM)

# ***FOREBIDDEN  Holt-Winters’ - model_fit_AMA----
model_fit_AMA <- exp_smoothing(error = "additive",
                               trend = "multiplicative",
                               season = "additive",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AMA
model_table <- model_table %>% add_modeltime_model(model_fit_AMA)

# Holt-Winters’ - model_fit_MAA----
model_fit_MAA <- exp_smoothing(error = "multiplicative",
                               trend = "additive",
                               season = "additive",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MAA
model_table <- model_table %>% add_modeltime_model(model_fit_MAA)

# Multiplicative Holt-Winters’ - model_fit_MAM----
model_fit_MAM <- exp_smoothing(error = "multiplicative",
                               trend = "additive",
                               season = "multiplicative",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MAM
model_table <- model_table %>% add_modeltime_model(model_fit_MAM)

# Multiplicative damped Holt-Winters’ - model_fit_MAdM----
model_fit_MAdM <- exp_smoothing(error = "multiplicative",
                               trend = "additive",
                               season = "multiplicative",
                               damping = "damped") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MAdM
model_table <- model_table %>% add_modeltime_model(model_fit_MAdM)

# Multiplicative autodamped (not damped) Holt-Winters’ - model_fit_MADM----
model_fit_MADM <- exp_smoothing(error = "multiplicative",
                                trend = "additive",
                                season = "multiplicative",
                                damping = "auto") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MADM
model_table <- model_table %>% add_modeltime_model(model_fit_MADM)

# ***FOREBIDDEN  Holt-Winters’ - model_fit_AMM----
model_fit_AMM <- exp_smoothing(error = "additive",
                               trend = "multiplicative",
                               season = "multiplicative",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_AMM
model_table <- model_table %>% add_modeltime_model(model_fit_AMM)

# ***FOREBIDDEN  Holt-Winters’ - model_fit_MMA----
model_fit_MMA <- exp_smoothing(error = "multiplicative",
                               trend = "multiplicative",
                               season = "additive",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMA
model_table <- model_table %>% add_modeltime_model(model_fit_MMA)

# Holt-Winters’ - model_fit_MMM----
model_fit_MMM <- exp_smoothing(error = "multiplicative",
                               trend = "multiplicative",
                               season = "multiplicative",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMM
model_table <- model_table %>% add_modeltime_model(model_fit_MMM)

# Holt-Winters’ - model_fit_MMdM----
model_fit_MMdM <- exp_smoothing(error = "multiplicative",
                               trend = "multiplicative",
                               season = "multiplicative",
                               damping = "damped") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMdM
model_table <- model_table %>% add_modeltime_model(model_fit_MMdM)

# Holt-Winters’ autodamped (not damped) - model_fit_MMDM----
model_fit_MMDM <- exp_smoothing(error = "multiplicative",
                                trend = "multiplicative",
                                season = "multiplicative",
                                damping = "auto") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MMDM
model_table <- model_table %>% add_modeltime_model(model_fit_MMDM)

# Holt-Winters’ - model_fit_ANA----
model_fit_ANA <- exp_smoothing(error = "additive",
                               trend = "none",
                               season = "additive",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_ANA
model_table <- model_table %>% add_modeltime_model(model_fit_ANA)

# Holt-Winters’ - model_fit_MNA----
model_fit_MNA <- exp_smoothing(error = "multiplicative",
                               trend = "none",
                               season = "additive",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_MNA
model_table <- model_table %>% add_modeltime_model(model_fit_MNA)

# ***FOREBIDDEN Holt-Winters’ - model_fit_ANM----
model_fit_ANM <- exp_smoothing(error = "additive",
                               trend = "none",
                               season = "multiplicative",
                               damping = "none") %>%
  set_engine("ets") %>%
  fit(value ~ date,
      data = training(split))
model_fit_ANM
model_table <- model_table %>% add_modeltime_model(model_fit_ANM)

# ..................................................................----
# FULL AUTO ----
model_fit_auto <- exp_smoothing() %>% 
  set_engine("ets") %>% 
  fit(value ~ date,
      data = training(split))
model_fit_auto
model_table <- model_table %>% add_modeltime_model(model_fit_auto)

# ..................................................................----
#MODELTIME_TABLE ----
model_table #23 models in total

calibration_tbl <- model_table %>% modeltime_calibrate(new_data = testing(split))

accuracy_tbl <- calibration_tbl %>% modeltime_accuracy()

reactable(accuracy_tbl)

forecast_tbl <- calibration_tbl %>% modeltime_forecast(new_data = testing(split),
                                                       actual_data = data)
plot_modeltime_forecast(forecast_tbl)

# ..................................................................----
# CUSTOM FUNCITONS ----
m4 <- read_csv("00_data/m4_monthly.csv") %>% 
  purrr::set_names(c("Date", "Value")) %>% 
  dplyr::mutate(Date = as.Date(Date)) %>% 
  dplyr::as_tibble()

plot_time_series(m4,.date_var = Date,.value = Value)

split <- m4 %>% 
  timetk::time_series_split(date   = Date,
                            assess     = 60,
                            cumulative = TRUE)

model_fit_auto_m4<- exp_smoothing() %>% 
  set_engine("ets") %>% 
  fit(Value ~ Date,
      data = training(split))
model_fit_auto_m4

model_fit_auto_m4_custom <- exp_smoothing_custom() %>% 
  set_engine("ets") %>% 
  fit(Value ~ Date,
      data = training(split))
model_fit_auto_m4_custom












