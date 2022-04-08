mape <-
structure(function(data, ...) {
  UseMethod("mape")
}, direction = "minimize", class = c("numeric_metric", "metric", 
"function"))
mape.data.frame <-
function(data,
                            truth,
                            estimate,
                            na_rm = TRUE,
                            case_weights = NULL,
                            ...) {
  metric_summarizer(
    metric_nm = "mape",
    metric_fn = mape_vec,
    data = data,
    truth = !!enquo(truth),
    estimate = !!enquo(estimate),
    na_rm = na_rm,
    case_weights = !!enquo(case_weights)
  )
}
mape_vec <-
function(truth,
                     estimate,
                     na_rm = TRUE,
                     case_weights = NULL,
                     ...) {
  metric_vec_template(
    metric_impl = mape_impl,
    truth = truth,
    estimate = estimate,
    na_rm = na_rm,
    case_weights = case_weights,
    cls = "numeric"
  )
}
mape_impl <-
function(truth, estimate, ..., case_weights = NULL) {
  errors <- abs((truth - estimate) / truth)
  out <- yardstick_mean(errors, case_weights = case_weights)
  out <- out * 100
  out
}
