accuracy_metrics <- function(input){
  metrics_strings <- c()
  
  for (metric in input) {
    if(metric == "MAE"){
      metric <- tolower(metric)
    }else if(metric == "MAPE"){
      metric <- tolower(metric)
    }else if(metric == "MASE"){
      metric <- tolower(metric)
    }else if(metric == "SMAPE"){
      metric <- tolower(metric)
    }else if(metric == "MAAPE"){
      metric <- tolower(metric)
    }else if(metric == "MSE"){
      metric <- tolower(metric)
    }else if(metric == "MPE"){
      metric <- tolower(metric)
    }else if(metric == "RMSE"){
      metric <- tolower(metric)
    }else if(metric == "RSquared"){
      metric <- "rsq"
    }
    
    metrics_strings <- metrics_strings %>% append(metric)
  }
  
  return(metrics_strings)
}


accuracy_metrics(c("MAE", "MAPE", "MASE", "SMAPE", "RMSE", "RSquared", "MPE", "MSE","MAAPE"))

# Folder Creation
if(dir.exists("01_source/00_accuracy_metrics")){
  dump(
    list = c(
      "accuracy_metrics"
    ),
    
    file = "01_source/00_accuracy_metrics/f_accuracy_metrics.R",
    append = FALSE)
}else{
  dir_create("01_source/00_accuracy_metrics")
  dump(
    list = c(
      "accuracy_metrics"
    ),
    
    file = "01_source/00_accuracy_metrics/f_accuracy_metrics.R",
    append = FALSE)
}