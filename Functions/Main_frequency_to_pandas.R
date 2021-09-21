frequency_to_pandas <- function(freq){
  freq_trans <- NULL
  if(freq == "minute"){
    freq_trans <- "T"
  }else if(freq == "hour"){
    freq_trans <- "H"
  }else if(freq == "day"){
    freq_trans <- "D"
  }else if(freq == "week"){
    freq_trans <- "W"
  }else if(freq == "month"){
    freq_trans <- "M"
  }else if(freq == "quarter"){
    freq_trans <- "Q"
  }else if(freq == "year"){
    freq_trans <- "A"
  }
  return(freq_trans)
}

# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "frequency_to_pandas"
    ),
    
    file = "00_scripts/f_frequency_to_pandas.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "frequency_to_pandas"
    ),
    
    file = "00_scripts/f_frequency_to_pandas.R",
    append = FALSE)
}


# frequency_to_pandas(tk_get_timeseries_summary(transactions_tbl$purchased_at)$scale)
