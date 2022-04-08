smape <- function(data, ...) {
  UseMethod("smape")
}
smape <- new_numeric_metric(
  smape,
  direction = "minimize"
)

smape.data.frame <- function(data,
                             truth,
                             estimate,
                             na_rm = TRUE,
                             case_weights = NULL,
                             ...) {
  metric_summarizer(
    metric_nm = "smape",
    metric_fn = smape_vec,
    data = data,
    truth = !!enquo(truth),
    estimate = !!enquo(estimate),
    na_rm = na_rm,
    case_weights = !!enquo(case_weights)
  )
}

smape_vec <- function(truth,
                      estimate,
                      na_rm = TRUE,
                      case_weights = NULL,
                      ...) {
  metric_vec_template(
    metric_impl = smape_impl,
    truth = truth,
    estimate = estimate,
    na_rm = na_rm,
    case_weights = case_weights,
    cls = "numeric"
  )
}

smape_impl <- function(truth,
                       estimate,
                       ...,
                       case_weights = NULL) {
  check_dots_empty()
  
  numer <- abs(estimate - truth)
  denom <- (abs(truth) + abs(estimate)) / 2
  error <- numer / denom
  
  out <- yardstick_mean(error, case_weights = case_weights)
  out <- out * 100
  
  out
}

# Folder Creation
if(dir.exists("01_source/00_accuracy_metrics")){
  dump(
    list = c(
      "smape",
      "smape.data.frame",
      "smape_vec",
      "smape_impl"
    ),
    
    file = "01_source/00_accuracy_metrics/f_smape.R",
    append = FALSE)
}else{
  dir_create("01_source/00_accuracy_metrics")
  dump(
    list = c(
      "smape",
      "smape.data.frame",
      "smape_vec",
      "smape_impl"
    ),
    
    file = "01_source/00_accuracy_metrics/f_smape.R",
    append = FALSE)
}