mse_vec <-
function(truth, estimate, na_rm = TRUE, ...) {
  
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
mse <-
structure(function(data, ...) {
  UseMethod("mse")
}, direction = "minimize", class = c("numeric_metric", "metric", 
"function"))
mse.data.frame <-
function(data, truth, estimate, na_rm = TRUE, ...) {
  
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
