mse_vec <- function(truth, estimate, na_rm = TRUE, ...) {
  
  mse_impl <- function(truth, estimate) {
    mean((truth - estimate) ^ 2)
  }
  
  metric_vec_template(
    metric_impl = mse_impl,
    truth = truth, 
    estimate = estimate,
    na_rm = na_rm,
    cls = "numeric",
    ...
  )
  
}

mse <- function(data, ...) {
  UseMethod("mse")
}

mse <- new_numeric_metric(mse, direction = "minimize")

mse.data.frame <- function(data, truth, estimate, na_rm = TRUE, ...) {
  
  metric_summarizer(
    metric_nm = "mse",
    metric_fn = mse_vec,
    data = data,
    truth = !! enquo(truth),
    estimate = !! enquo(estimate), 
    na_rm = na_rm,
    ...
  )
  
}


# Folder Creation
if(dir.exists("01_source/00_accuracy_metrics")){
  dump(
    list = c(
      "mse_vec",
      "mse",
      "mse.data.frame"
    ),
    
    file = "01_source/00_accuracy_metrics/f_mse.R",
    append = FALSE)
}else{
  dir_create("01_source/00_accuracy_metrics")
  dump(
    list = c(
      "mse_vec",
      "mse",
      "mse.data.frame"
    ),
    
    file = "01_source/00_accuracy_metrics/f_mse.R",
    append = FALSE)
}