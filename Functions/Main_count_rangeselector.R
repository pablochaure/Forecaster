count_rangeselector <- function(freq){
  if(freq == "minute"){
    count <-  60
  }else{
    count <- 1
  }
  return(count)
}

# Folder Creation
if(dir.exists("00_scripts")){
  dump(
    list = c(
      "count_rangeselector"
    ),
    
    file = "00_scripts/f_count_rangeselector.R",
    append = FALSE)
}else{
  dir_create("00_scripts")
  dump(
    list = c(
      "count_rangeselector"
    ),
    
    file = "00_scripts/f_count_rangeselector.R",
    append = FALSE)
}





freq <-  "week"

getSymbols(Symbols = c("AAPL", "MSFT"), from = '2018-01-01', to = '2019-01-01', src = "yahoo")

ds <- data.frame(Date = index(AAPL), AAPL[,6], MSFT[,6])

fig <- plot_ly(m750, x = ~date)
fig <- fig %>% add_lines(y = ~value, name = "Value")
fig <- fig %>% layout(
  title = "Stock Prices",
  xaxis = list(
    rangeselector = list(
      buttons = list(
        list(
          count = 3,
          label = "3 mo",
          step = "month",
          stepmode = "backward"),
        list(
          count = 6,
          label = "6 mo",
          step = "month",
          stepmode = "backward"),
        list(
          count = 1,
          label = "1 yr",
          step = "year",
          stepmode = "backward"),
        list(
          count = 1,
          label = "YTD",
          step = "year",
          stepmode = "todate"),
        list(step = "all"))),
    
    rangeslider = list(type = "date")),
  
  yaxis = list(title = "Price"))

fig
