
exp_smoothing_custom<- function(mode = "regression", seasonal_period = NULL,
                          error = NULL, trend = NULL, season = NULL, damping = NULL,
                          smooth_level = NULL, smooth_trend = NULL, smooth_seasonal = NULL
) {
  
  args <- list(
    seasonal_period   = rlang::enquo(seasonal_period),
    error             = rlang::enquo(error),
    trend             = rlang::enquo(trend),
    season            = rlang::enquo(season),
    damping           = rlang::enquo(damping),
    smooth_level      = rlang::enquo(smooth_level),
    smooth_trend      = rlang::enquo(smooth_trend),
    smooth_seasonal   = rlang::enquo(smooth_seasonal)
  )
  
  parsnip::new_model_spec(
    "exp_smoothing",
    args     = args,
    eng_args = NULL,
    mode     = mode,
    method   = NULL,
    engine   = NULL
  )
  
}

#' @export
print.exp_smoothing <- function(x, ...) {
  cat("Exponential Smoothing State Space Model Specification (", x$mode, ")\n\n", sep = "")
  parsnip::model_printer(x, ...)
  
  if(!is.null(x$method$fit$args)) {
    cat("Model fit template:\n")
    print(parsnip::show_call(x))
  }
  
  invisible(x)
}

#' @export
#' @importFrom stats update
update.exp_smoothing <- function(object, parameters = NULL,
                                 seasonal_period = NULL,
                                 error = NULL, trend = NULL, season = NULL, damping = NULL,
                                 smooth_level = NULL, smooth_trend = NULL, smooth_seasonal = NULL,
                                 fresh = FALSE, ...) {
  
  parsnip::update_dot_check(...)
  
  if (!is.null(parameters)) {
    parameters <- parsnip::check_final_param(parameters)
  }
  
  args <- list(
    seasonal_period   = rlang::enquo(seasonal_period),
    error             = rlang::enquo(error),
    trend             = rlang::enquo(trend),
    season            = rlang::enquo(season),
    damping           = rlang::enquo(damping),
    smooth_level      = rlang::enquo(smooth_level),
    smooth_trend      = rlang::enquo(smooth_trend),
    smooth_seasonal   = rlang::enquo(smooth_seasonal)
  )
  
  args <- parsnip::update_main_parameters(args, parameters)
  
  if (fresh) {
    object$args <- args
  } else {
    null_args <- purrr::map_lgl(args, parsnip::null_value)
    if (any(null_args))
      args <- args[!null_args]
    if (length(args) > 0)
      object$args[names(args)] <- args
  }
  
  parsnip::new_model_spec(
    "exp_smoothing",
    args     = object$args,
    eng_args = object$eng_args,
    mode     = object$mode,
    method   = NULL,
    engine   = object$engine
  )
}


#' @export
#' @importFrom parsnip translate
translate.exp_smoothing <- function(x, engine = x$engine, ...) {
  if (is.null(engine)) {
    message("Used `engine = 'ets'` for translation.")
    engine <- "ets"
  }
  x <- parsnip::translate.default(x, engine, ...)
  
  x
}


# ETS -----

#' Low-Level Exponential Smoothing function for translating modeltime to forecast
#'
#' @inheritParams exp_smoothing
#' @inheritParams ets_custom
#' @param x A dataframe of xreg (exogenous regressors)
#' @param y A numeric vector of values to fit
#' @param period A seasonal frequency. Uses "auto" by default. A character phrase
#'  of "auto" or time-based phrase of "2 weeks" can be used if a date or date-time variable is provided.
#' @param ... Additional arguments passed to `ets_custom`
#'
#' @keywords internal
#' @export
ets_fit_impl <- function(x, y, period = "auto",
                         error = "auto", trend = "auto",
                         season = "auto", damping = "auto",
                         alpha = NULL, beta = NULL, gamma = NULL, ...) {
  
  # X & Y
  # Expect outcomes  = vector
  # Expect predictor = data.frame
  outcome    <- y
  predictor  <- x
  
  # INDEX & PERIOD
  # Determine Period, Index Col, and Index
  index_tbl <- parse_index_from_data(predictor)
  period    <- parse_period_from_index(index_tbl, period)
  idx_col   <- names(index_tbl)
  idx       <- timetk::tk_index(index_tbl)
  
  outcome   <- stats::ts(outcome, frequency = period)
  
  error  <- tolower(error)
  trend  <- tolower(trend)
  season <- tolower(season)
  
  # CHECK PARAMS
  if (!error %in% c("auto", "additive", "multiplicative")) {
    rlang::abort("'error' must be one of 'auto', 'additive', or 'multiplicative'.")
  }
  if (!trend %in% c("auto", "additive", "multiplicative", "none")) {
    rlang::abort("'trend' must be one of 'auto', 'additive', 'multiplicative', or 'none'.")
  }
  if (!season %in% c("auto", "additive", "multiplicative", "none")) {
    rlang::abort("'season' must be one of 'auto', 'additive', 'multiplicative', or 'none'.")
  }
  if (!damping %in% c("auto", "damped", "none")) {
    rlang::abort("'damping' must be one of 'auto', 'damped', or 'none'.")
  }
  
  # CONVERT PARAMS
  error_ets <- switch(
    error,
    "auto"           = "Z",
    "additive"       = "A",
    "multiplicative" = "M"
  )
  trend_ets <- switch(
    trend,
    "auto"           = "Z",
    "additive"       = "A",
    "multiplicative" = "M",
    "none"           = "N"
  )
  season_ets <- switch(
    season,
    "auto"           = "Z",
    "additive"       = "A",
    "multiplicative" = "M",
    "none"           = "N"
  )
  damping_ets <- switch(
    damping,
    "auto"           = NULL,
    "damped"         = TRUE,
    "none"           = FALSE
  )
  
  model_ets <- stringr::str_c(error_ets, trend_ets, season_ets)
  
  # XREGS - NOT USED FOR ets_custom()
  
  # FIT
  fit_ets <- ets_custom(outcome, model = model_ets, damped = damping_ets,
                           alpha = alpha, beta = beta, gamma = gamma, ...)
  
  # RETURN
  new_modeltime_bridge(
    class = "ets_fit_impl",
    
    # Models
    models = list(
      model_1 = fit_ets
    ),
    
    # Data - Date column (matches original), .actual, .fitted, and .residuals columns
    data = tibble::tibble(
      !! idx_col  := idx,
      .actual      =  as.numeric(fit_ets$x),
      .fitted      =  as.numeric(fit_ets$fitted),
      .residuals   =  as.numeric(fit_ets$residuals)
    ),
    
    # Preprocessing Recipe (prepped) - Used in predict method
    extras = NULL,
    
    # Description
    desc = fit_ets$method[1]
  )
  
}

#' @export
print.ets_fit_impl <- function(x, ...) {
  print(x$models$model_1)
  invisible(x)
}



#' @export
predict.ets_fit_impl <- function(object, new_data, ...) {
  ets_predict_impl(object, new_data, ...)
}

#' Bridge prediction function for Exponential Smoothing models
#'
#' @inheritParams parsnip::predict.model_fit
#' @param ... Additional arguments passed to `ets_custom()`
#'
#' @keywords internal
#' @export
ets_predict_impl <- function(object, new_data, ...) {
  
  # PREPARE INPUTS
  model       <- object$models$model_1
  idx_train   <- object$data %>% timetk::tk_index()
  h_horizon   <- nrow(new_data)
  
  # XREG
  # - No xregs for ets_custom()
  
  # PREDICTIONS
  preds_forecast <- forecast::forecast(model, h = h_horizon, ...)
  
  # Return predictions as numeric vector
  preds <- tibble::as_tibble(preds_forecast) %>% purrr::pluck(1)
  
  return(preds)
  
}

# SMOOTH -----

#' Low-Level Exponential Smoothing function for translating modeltime to forecast
#'
#' @inheritParams exp_smoothing
#' @inheritParams ets_custom
#' @param x A dataframe of xreg (exogenous regressors)
#' @param y A numeric vector of values to fit
#' @param period A seasonal frequency. Uses "auto" by default. A character phrase
#'  of "auto" or time-based phrase of "2 weeks" can be used if a date or date-time variable is provided.
#' @param ... Additional arguments passed to `smooth::es`
#'
#' @keywords internal
#' @export
smooth_fit_impl <- function(x, y, period = "auto",
                            error = "auto", trend = "auto",
                            season = "auto", damping = NULL,
                            alpha = NULL, beta = NULL, gamma = NULL, ...) {
  
  args <- list(...)
  
  # X & Y
  # Expect outcomes  = vector
  # Expect predictor = data.frame
  outcome    <- y
  predictor  <- x
  
  # INDEX & PERIOD
  # Determine Period, Index Col, and Index
  index_tbl <- parse_index_from_data(predictor)
  period    <- parse_period_from_index(index_tbl, period)
  idx_col   <- names(index_tbl)
  idx       <- timetk::tk_index(index_tbl)
  
  # XREGS
  # Clean names, get xreg recipe, process predictors
  xreg_recipe <- create_xreg_recipe(predictor, prepare = TRUE)
  xreg_matrix <- juice_xreg_recipe(xreg_recipe, format = "matrix")
  
  outcome   <- stats::ts(outcome, frequency = period)
  
  error  <- tolower(error)
  trend  <- tolower(trend)
  season <- tolower(season)
  
  # CHECK PARAMS
  if (!error %in% c("auto", "additive", "multiplicative")) {
    rlang::abort("'error' must be one of 'auto', 'additive', or 'multiplicative'.")
  }
  if (!trend %in% c("auto", "additive", "multiplicative", "none", "additive_damped", "multiplicative_damped")) {
    rlang::abort("'trend' must be one of 'auto', 'additive', 'multiplicative', 'none', 'additive_damped' or 'multiplicative_damped'.")
  }
  if (!season %in% c("auto", "additive", "multiplicative", "none")) {
    rlang::abort("'season' must be one of 'auto', 'additive', 'multiplicative', or 'none'.")
  }
  
  # CONVERT PARAMS
  error_ets <- switch(
    error,
    "auto"           = "Z",
    "additive"       = "A",
    "multiplicative" = "M"
  )
  trend_ets <- switch(
    trend,
    "auto"                  = "Z",
    "additive"              = "A",
    "multiplicative"        = "M",
    "none"                  = "N",
    "additive_damped"       = "Ad",
    "multiplicative_damped" = "Md"
  )
  season_ets <- switch(
    season,
    "auto"           = "Z",
    "additive"       = "A",
    "multiplicative" = "M",
    "none"           = "N"
  )
  
  
  model_ets <- stringr::str_c(error_ets, trend_ets, season_ets)
  
  #If the model is passed through set_engine, we use this option (this is because there are 30 options
  #and not all of them are included in the "standard" options).
  if (any(names(args) == "model")){
    model_ets <- args$model
    args$model <- NULL
  }
  
  persistence <- c(alpha, beta, gamma)
  
  # FIT
  
  if (!is.null(xreg_matrix)){
    fit_ets <- smooth::es(outcome,
                          model = model_ets,
                          persistence = persistence,
                          phi = damping,
                          xreg = xreg_matrix,
                          ...)
  } else {
    fit_ets <- smooth::es(outcome,
                          model = model_ets,
                          persistence = persistence,
                          phi = damping,
                          ...)
  }
  
  # RETURN
  new_modeltime_bridge(
    class = "smooth_fit_impl",
    
    # Models
    models = list(
      model_1 = fit_ets
    ),
    
    # Data - Date column (matches original), .actual, .fitted, and .residuals columns
    data = tibble::tibble(
      !! idx_col  := idx,
      .actual      =  as.numeric(fit_ets$y),
      .fitted      =  as.numeric(fit_ets$fitted),
      .residuals   =  as.numeric(fit_ets$residuals)
    ),
    
    # Preprocessing Recipe (prepped) - Used in predict method
    extras = list(xreg_matrix = xreg_matrix,
                  xreg_recipe = xreg_recipe),
    
    # Description
    desc = fit_ets$model
    
  )
  
}

#' @export
print.smooth_fit_impl <- function(x, ...) {
  print(x$models$model_1)
  invisible(x)
}


#' @export
predict.smooth_fit_impl <- function(object, new_data, ...) {
  smooth_predict_impl(object, new_data, ...)
}

#' Bridge prediction function for Exponential Smoothing models
#'
#' @inheritParams parsnip::predict.model_fit
#' @param ... Additional arguments passed to `smooth::es()`
#'
#' @keywords internal
#' @export
smooth_predict_impl <- function(object, new_data, ...) {
  
  # PREPARE INPUTS
  model       <- object$models$model_1
  idx_train   <- object$data %>% timetk::tk_index()
  h_horizon   <- nrow(new_data)
  xreg_recipe <- object$models$extras$xreg_recipe
  
  #PREDICTIONS
  
  if (is.null(xreg_recipe)){
    preds <- as.numeric(greybox::forecast(model, h = h_horizon, ...)$mean)
  } else {
    xreg_matrix <- bake_xreg_recipe(xreg_recipe, new_data, format = "matrix")
    preds <- as.numeric(greybox::forecast(model, h = h_horizon, newdata = xreg_matrix, ...)$mean)
  }
  
  return(preds)
  
}

# CROSTON ----

#' Low-Level Exponential Smoothing function for translating modeltime to forecast
#'
#' @inheritParams exp_smoothing
#' @inheritParams forecast::croston
#' @param x A dataframe of xreg (exogenous regressors)
#' @param y A numeric vector of values to fit
#' @param ... Additional arguments passed to `ets_custom`
#'
#' @keywords internal
#' @export
croston_fit_impl <- function(x, y, alpha = 0.1, ...){
  
  others <- list(...)
  
  outcome    <- y # Comes in as a vector
  predictors <- x # Comes in as a data.frame (dates and possible xregs)
  
  fit_croston <- forecast::croston(y = outcome, h = length(outcome), alpha = alpha, ...)
  
  # 2. Predictors - Handle Dates
  index_tbl <- modeltime::parse_index_from_data(predictors)
  idx_col   <- names(index_tbl)
  idx       <- timetk::tk_index(index_tbl)
  
  modeltime::new_modeltime_bridge(
    
    class  = "croston_fit_impl",
    
    models = list(model_1 = fit_croston),
    
    data   = tibble::tibble(
      !! idx_col := idx,
      .actual    = as.numeric(fit_croston$x),
      .fitted    = as.numeric(fit_croston$fitted),
      .residuals = as.numeric(fit_croston$residuals)
    ),
    
    extras = list(
      outcome = outcome,
      alpha   = alpha,
      others  = others
    ), # Can add xreg preprocessors here
    desc   = stringr::str_c("Croston Method")
  )
}

#' @export
print.croston_fit_impl <- function(x, ...) {
  if (!is.null(x$desc)) cat(paste0(x$desc,"\n"))
  cat("---\n")
  invisible(x)
}

#' @export
predict.croston_fit_impl <- function(object, new_data, ...) {
  croston_predict_impl(object, new_data, ...)
}

#' Bridge prediction function for CROSTON models
#'
#' @inheritParams parsnip::predict.model_fit
#' @param ... Additional arguments passed to `stats::predict()`
#'
#' @keywords internal
#' @export
croston_predict_impl <- function(object, new_data, ...) {
  # PREPARE INPUTS
  model         <- object$models$model_1
  outcome       <- object$extras$outcome
  alpha         <- object$extras$alpha
  others        <- object$extras$others
  
  h_horizon      <- nrow(new_data)
  
  preds <- tryCatch({
    
    pred_forecast <- forecast::forecast(model, h = h_horizon)
    
    as.numeric(pred_forecast$mean)
    
  }, error = function(e) {
    fit <- forecast::croston(y = outcome, h = h_horizon, alpha = alpha)
    
    as.numeric(fit$mean)
    
  })
  
  return(preds)
}


# THETA ----

#' Low-Level Exponential Smoothing function for translating modeltime to forecast
#'
#' @param x A dataframe of xreg (exogenous regressors)
#' @param y A numeric vector of values to fit
#' @param ... Additional arguments passed to `ets_custom`
#'
#' @keywords internal
#' @export
theta_fit_impl <- function(x, y, ...){
  
  others <- list(...)
  
  outcome    <- y # Comes in as a vector
  predictors <- x # Comes in as a data.frame (dates and possible xregs)
  
  fit_theta <- forecast::thetaf(y = outcome, h = length(outcome), ...)
  
  # 2. Predictors - Handle Dates
  index_tbl <- modeltime::parse_index_from_data(predictors)
  idx_col   <- names(index_tbl)
  idx       <- timetk::tk_index(index_tbl)
  
  modeltime::new_modeltime_bridge(
    
    class  = "theta_fit_impl",
    
    models = list(model_1 = fit_theta),
    
    data   = tibble::tibble(
      !! idx_col := idx,
      .actual    = as.numeric(fit_theta$x),
      .fitted    = as.numeric(fit_theta$fitted),
      .residuals = as.numeric(fit_theta$residuals)
    ),
    
    extras = list(
      outcome = outcome,
      others  = others
    ), # Can add xreg preprocessors here
    desc   = stringr::str_c("Theta Method")
  )
}

#' @export
print.theta_fit_impl <- function(x, ...) {
  if (!is.null(x$desc)) cat(paste0(x$desc,"\n"))
  cat("---\n")
  # print(tibble::as_tibble(x$models$model_1))
  invisible(x)
}

#' @export
predict.theta_fit_impl <- function(object, new_data, ...) {
  theta_predict_impl(object, new_data, ...)
}

#' Bridge prediction function for THETA models
#'
#' @inheritParams parsnip::predict.model_fit
#' @param ... Additional arguments passed to `stats::predict()`
#'
#' @keywords internal
#' @export
theta_predict_impl <- function(object, new_data, ...) {
  # PREPARE INPUTS
  model         <- object$models$model_1
  outcome       <- object$extras$outcome
  others        <- object$extras$others
  
  h_horizon      <- nrow(new_data)
  
  preds <- tryCatch({
    
    pred_forecast <- forecast::forecast(model, h = h_horizon)
    
    as.numeric(pred_forecast$mean)
    
  }, error = function(e) {
    fit <- forecast::thetaf(y = outcome, h = h_horizon)
    
    as.numeric(fit$mean)
    
  })
  
  return(preds)
}

# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "exp_smoothing_custom",
      "print.exp_smoothing",
      "update.exp_smoothing",
      "translate.exp_smoothing",
      "ets_fit_impl",
      "print.ets_fit_impl",
      "predict.ets_fit_impl",
      "ets_predict_impl",
      "smooth_fit_impl",
      "print.smooth_fit_impl",
      "predict.smooth_fit_impl",
      "smooth_predict_impl",
      "croston_fit_impl",
      "print.croston_fit_impl",
      "predict.croston_fit_impl",
      "croston_predict_impl",
      "theta_fit_impl",
      "print.theta_fit_impl",
      "predict.theta_fit_impl",
      "theta_predict_impl"
    ),
    file = "01_source/f_exp_smoothing_custom.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "exp_smoothing_custom",
      "print.exp_smoothing",
      "update.exp_smoothing",
      "translate.exp_smoothing",
      "ets_fit_impl",
      "print.ets_fit_impl",
      "predict.ets_fit_impl",
      "ets_predict_impl",
      "smooth_fit_impl",
      "print.smooth_fit_impl",
      "predict.smooth_fit_impl",
      "smooth_predict_impl",
      "croston_fit_impl",
      "print.croston_fit_impl",
      "predict.croston_fit_impl",
      "croston_predict_impl",
      "theta_fit_impl",
      "print.theta_fit_impl",
      "predict.theta_fit_impl",
      "theta_predict_impl"
    ),
    file = "01_source/f_exp_smoothing_custom.R",
    append = FALSE)
}
