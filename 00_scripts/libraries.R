####LIBRARIES FOR FORECAST APP####

libraries <-
  function(){
    suppressPackageStartupMessages({
      # Core
      if (!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
      if (!require("DataExplorer")) install.packages("DataExplorer"); library(DataExplorer)
      if (!require("berryFunctions")) install.packages("berryFunctions"); library(berryFunctions)
      if (!require("tools")) install.packages("tools"); library(tools)
      if (!require("reticulate")) install.packages("reticulate"); library(reticulate)
      if (!require("bit64")) install.packages("bit64"); library(bit64)
      
      # Data
      if (!require("readxl")) install.packages("readxl"); library(readxl)
      if (!require("tidyquant")) install.packages("tidyquant"); library(tidyquant)
      if (!require("data.table")) install.packages("data.table"); library(data.table)
      if (!require("DT")) install.packages("DT"); library(DT)
      if (!require("writexl")) install.packages("writexl"); library(writexl)
      if (!require("fs")) install.packages("fs"); library(fs)
      if (!require("rlist")) install.packages("rlist"); library(rlist)
      
      # Time series
      if (!require("timetk")) install.packages("timetk"); library(timetk)
      if (!require("lubridate")) install.packages("lubridate"); library(lubridate)
      if (!require("imputeTS")) install.packages("imputeTS"); library(imputeTS)
      
      
      # Modelling
      if (!require("tidymodels")) install.packages("tidymodels"); library(tidymodels)
      if (!require("modeltime")) install.packages("modeltime"); library(modeltime)
      if (!require("modeltime.ensemble")) install.packages("modeltime.ensemble"); library(modeltime.ensemble)
      if (!require("modeltime.resample")) install.packages("modeltime.resample"); library(modeltime.resample)
      if (!require("modeltime.gluonts")) remotes::install_github("business-science/modeltime.gluonts"); library(modeltime.gluonts)
      if (!require("modeltime.h2o")) install.packages("modeltime.h2o"); library(modeltime.h2o)
      if (!require("neuralprophet")) remotes::install_github("AlbertoAlmuinha/neuralprophet"); library(neuralprophet)
      
      # Plots
      if (!require("reactable")) install.packages("reactable"); library(reactable)
      if (!require("plotly")) install.packages("plotly"); library(plotly)
      if (!require("factoextra")) install.packages("factoextra"); library(factoextra)

      # Shiny
      if (!require("shiny")) install.packages("shiny"); library(shiny)
      if (!require("shinycssloaders")) install.packages("shinycssloaders"); library(shinycssloaders)
      if (!require("shinydashboard")) install.packages("shinydashboard"); library(shinydashboard)
      if (!require("shinydashboardPlus")) install.packages("shinydashboardPlus"); library(shinydashboardPlus)
      if (!require("shinyEffects")) install.packages("shinyEffects"); library(shinyEffects)
      if (!require("shinyWidgets")) install.packages("shinyWidgets"); library(shinyWidgets)
      if (!require("shinyalert")) install.packages("shinyalert"); library(shinyalert)
      if (!require("shinyjs")) install.packages("shinyjs"); library(shinyjs)
      if (!require("fresh")) install.packages("fresh"); library(fresh)
      
    })
  }
