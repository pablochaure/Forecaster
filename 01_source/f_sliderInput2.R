sliderInput2 <-
function(inputId, label, min, max, value, step=NULL, from_min, from_max){
  x <- sliderInput(inputId,
                   label,
                   min,
                   max,
                   value,
                   step)
  x$children[[2]]$attribs <- c(x$children[[2]]$attribs, 
                               "data-from-min" = from_min, 
                               "data-from-max" = from_max, 
                               "data-from-shadow" = TRUE)
  x
}
