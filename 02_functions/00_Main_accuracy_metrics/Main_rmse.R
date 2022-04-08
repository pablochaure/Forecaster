rmse <- function(data, ...) {
  UseMethod("rmse")
}
rmse <- new_numeric_metric(
  rmse,
  direction = "minimize"
)

rmse.data.frame <- function(data,
                            truth,
                            estimate,
                            na_rm = TRUE,
                            case_weights = NULL,
                            ...) {
  metric_summarizer(
    metric_nm = "rmse",
    metric_fn = rmse_vec,
    data = data,
    truth = !!enquo(truth),
    estimate = !!enquo(estimate),
    na_rm = na_rm,
    case_weights = !!enquo(case_weights)
  )
}

rmse_vec <- function(truth,
                     estimate,
                     na_rm = TRUE,
                     case_weights = NULL,
                     ...) {
  metric_vec_template(
    metric_impl = rmse_impl,
    truth = truth,
    estimate = estimate,
    na_rm = na_rm,
    case_weights = case_weights,
    cls = "numeric"
  )
}

rmse_impl <- function(truth, estimate, ..., case_weights = NULL) {
  check_dots_empty()
  errors <- (truth - estimate) ^ 2
  sqrt(yardstick_mean(errors, case_weights = case_weights))
}

# Folder Creation
if(dir.exists("01_source/00_accuracy_metrics")){
  dump(
    list = c(
      "rmse",
      "rmse.data.frame",
      "rmse_vec",
      "rmse_impl"
    ),
    
    file = "01_source/00_accuracy_metrics/f_rmse.R",
    append = FALSE)
}else{
  dir_create("01_source/00_accuracy_metrics")
  dump(
    list = c(
      "rmse",
      "rmse.data.frame",
      "rmse_vec",
      "rmse_impl"
    ),
    
    file = "01_source/00_accuracy_metrics/f_rmse.R",
    append = FALSE)
}