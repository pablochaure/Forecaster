count_rangeselector <-
function(freq){
  if(freq == "minute"){
    count <-  60
  }else{
    count <- 1
  }
  return(count)
}
