maape_vec <- function(truth, estimate, na_rm = TRUE, ...) {
  
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

maape <- function(data, ...) {
  UseMethod("maape")
}

maape <- yardstick::new_numeric_metric(maape, direction = "minimize")

maape.data.frame <- function(data, truth, estimate, na_rm = TRUE, ...) {
  
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

# Folder Creation
if(dir.exists("01_source/00_accuracy_metrics")){
  dump(
    list = c(
      "maape_vec",
      "maape",
      "maape.data.frame"
    ),
    
    file = "01_source/00_accuracy_metrics/f_maape.R",
    append = FALSE)
}else{
  dir_create("01_source/00_accuracy_metrics")
  dump(
    list = c(
      "maape_vec",
      "maape",
      "maape.data.frame"
    ),
    
    file = "01_source/00_accuracy_metrics/f_maape.R",
    append = FALSE)
}