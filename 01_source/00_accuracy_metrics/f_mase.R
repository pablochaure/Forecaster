mase <-
structure(function(data, ...) {
  UseMethod("mase")
}, direction = "minimize", class = c("numeric_metric", "metric", 
"function"))
mase.data.frame <-
function(data,
                            truth,
                            estimate,
                            m = 1L,
                            mae_train = NULL,
                            na_rm = TRUE,
                            case_weights = NULL,
                            ...) {
  metric_summarizer(
    metric_nm = "mase",
    metric_fn = mase_vec,
    data = data,
    truth = !!enquo(truth),
    estimate = !!enquo(estimate),
    na_rm = na_rm,
    case_weights = !!enquo(case_weights),
    # Extra argument for mase_impl()
    metric_fn_options = list(mae_train = mae_train, m = m)
  )
}
mase_vec <-
function(truth,
                     estimate,
                     m = 1L,
                     mae_train = NULL,
                     na_rm = TRUE,
                     case_weights = NULL,
                     ...) {
  metric_vec_template(
    metric_impl = mase_impl,
    truth = truth,
    estimate = estimate,
    na_rm = na_rm,
    case_weights = case_weights,
    cls = "numeric",
    mae_train = mae_train,
    m = m
  )
}
mase_impl <-
function(truth,
                      estimate,
                      ...,
                      m = 1L,
                      mae_train = NULL,
                      case_weights = NULL) {
  check_dots_empty()
  validate_m(m)
  validate_mae_train(mae_train)
  
  if (is.null(mae_train)) {
    validate_truth_m(truth, m)
  }
  
  # Use out-of-sample snaive if mae_train is not provided
  if (is.null(mae_train)) {
    truth_lag <- dplyr::lag(truth, m)
    naive_error <- truth - truth_lag
    mae_denom <- mean(abs(naive_error), na.rm = TRUE)
  } else {
    mae_denom <- mae_train
  }
  
  error <- truth - estimate
  error <- error / mae_denom
  error <- abs(error)
  
  out <- yardstick_mean(error, case_weights = case_weights)
  
  out
}
validate_m <-
function(m) {
  abort_msg <- "`m` must be a single positive integer value."
  
  if (!rlang::is_integerish(m, n = 1L)) {
    abort(abort_msg)
  }
  
  if (!(m > 0)) {
    abort(abort_msg)
  }
  
  invisible(m)
}
validate_mae_train <-
function(mae_train) {
  if (is.null(mae_train)) {
    return(invisible(mae_train))
  }
  
  is_single_numeric <- rlang::is_bare_numeric(mae_train, n = 1L)
  abort_msg <- "`mae_train` must be a single positive numeric value."
  
  if (!is_single_numeric) {
    abort(abort_msg)
  }
  
  if (!(mae_train > 0)) {
    abort(abort_msg)
  }
  
  invisible(mae_train)
}
validate_truth_m <-
function(truth, m) {
  if (length(truth) <= m) {
    abort(paste0(
      "`truth` must have a length greater than `m` ",
      "to compute the out-of-sample naive mean absolute error."
    ))
  }
  
  invisible(truth)
}
