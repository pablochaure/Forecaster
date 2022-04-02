read_data <-
function(x){
  df <- read.csv(x$datapath, header = T, sep = ",", quote = "", dec = ".")
  df2 <- read.csv(x$datapath, header = T, sep = ";", quote = "", dec = ",")
  if(ncol(df2)<2 & ncol(df)<2){
    return(stop("FORMAT NOT VALID. Value separator must be ',' or ';'"))
  }else if(ncol(df2)<2){
    return(df)
  }else{
    return(df2)
  }
}
