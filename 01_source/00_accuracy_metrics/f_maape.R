maape_vec <-
function(truth, estimate, na_rm = TRUE, ...) {
  
  maape_impl <- function(truth, estimate) {
    TSrepr::maape(truth, estimate)
  }
  
  yardstick::metric_vec_template(
    metric_impl = maape_impl,
    truth = truth,
    estimate = estimate,
    na_rm = na_rm,
    cls = "numeric",
    ...
  )
  
}
maape <-
structure(function(data, ...) {
  UseMethod("maape")
}, direction = "minimize", class = c("numeric_metric", "metric", 
"function"))
maape.data.frame <-
function(data, truth, estimate, na_rm = TRUE, ...) {
  
  yardstick::metric_summarizer(
    metric_nm = "maape",
    metric_fn = maape_vec,
    data = data,
    truth = !! enquo(truth),
    estimate = !! enquo(estimate),
    na_rm = na_rm,
    ...
  )
  
}
