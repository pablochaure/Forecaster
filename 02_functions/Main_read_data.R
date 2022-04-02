### READING CSV FILES ###

read_data <- function(x){
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



# Folder Creation
if(dir.exists("01_source")){
  dump(
    list = c(
      "read_data"
    ),
    
    file = "01_source/f_read_data.R",
    append = FALSE)
}else{
  dir_create("01_source")
  dump(
    list = c(
      "read_data"
    ),
    
    file = "01_source/f_read_data.R",
    append = FALSE)
}
