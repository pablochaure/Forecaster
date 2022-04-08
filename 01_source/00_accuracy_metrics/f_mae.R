mae_vec <-
function(truth,
                    estimate,
                    na_rm = TRUE,
                    case_weights = NULL,
                    ...) {
  metric_vec_template(
    metric_impl = mae_impl,
    truth = truth,
    estimate = estimate,
    na_rm = na_rm,
    case_weights = case_weights,
    cls = "numeric"
  )
}
mae <-
structure(function(data, ...) {
  UseMethod("mae")
}, direction = "minimize", class = c("numeric_metric", "metric", 
"function"))
mae.data.frame <-
function(data,
                           truth,
                           estimate,
                           na_rm = TRUE,
                           case_weights = NULL,
                           ...) {
  metric_summarizer(
    metric_nm = "mae",
    metric_fn = mae_vec,
    data = data,
    truth = !!enquo(truth),
    estimate = !!enquo(estimate),
    na_rm = na_rm,
    case_weights = !!enquo(case_weights)
  )
}
mae_impl <-
function(truth, estimate, ..., case_weights = NULL) {
  ellipsis::check_dots_empty()
  errors <- abs(truth - estimate)
  yardstick_mean(errors, case_weights = case_weights)
}
yardstick_mean <-
function(x, ..., case_weights = NULL, na_remove = FALSE) {
  check_dots_empty()
  
  if (is.null(case_weights)) {
    mean(x, na.rm = na_remove)
  } else {
    stats::weighted.mean(x, w = case_weights, na.rm = na_remove)
  }
}
