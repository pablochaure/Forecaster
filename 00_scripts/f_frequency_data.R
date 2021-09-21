frequency_data <-
function(x){
  Frequency_Data <- as_tibble(x) %>%
    column_to_rownames(var = "Date") %>%
    as.xts() %>%
    PerformanceAnalytics::Frequency()
  
  if(Frequency_Data > 200){
    Frequency_Label = "Daily"
    return(Frequency_Label)
  }else if(Frequency_Data < 200 & Frequency_Data > 20){
    Frequency_Label = "Weekly"
    return(Frequency_Label)
  }else{
    Frequency_Label = "Monthly"
    return(Frequency_Label)
  }
}
