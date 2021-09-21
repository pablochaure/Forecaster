frequency_to_pandas <-
function(freq){
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
