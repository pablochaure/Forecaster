mape <- function(data, ...) {
  UseMethod("mape")
}
mape <- new_numeric_metric(
  mape,
  direction = "minimize"
)


mape.data.frame <- function(data,
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


mape_vec <- function(truth,
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

mape_impl <- function(truth, estimate, ..., case_weights = NULL) {
  errors <- abs((truth - estimate) / truth)
  out <- yardstick_mean(errors, case_weights = case_weights)
  out <- out * 100
  out
}


# Folder Creation
if(dir.exists("01_source/00_accuracy_metrics")){
  dump(
    list = c(
      "mape",
      "mape.data.frame",
      "mape_vec",
      "mape_impl"
    ),
    
    file = "01_source/00_accuracy_metrics/f_mape.R",
    append = FALSE)
}else{
  dir_create("01_source/00_accuracy_metrics")
  dump(
    list = c(
      "mape",
      "mape.data.frame",
      "mape_vec",
      "mape_impl"
    ),
    
    file = "01_source/00_accuracy_metrics/f_mape.R",
    append = FALSE)
}