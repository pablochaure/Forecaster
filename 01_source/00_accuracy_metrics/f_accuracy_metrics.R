accuracy_metrics <-
function(input){
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
