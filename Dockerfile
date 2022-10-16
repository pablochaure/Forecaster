# get shiny serves plus tidyverse packages image
FROM rocker/shiny-verse:latest

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

# install R packages required 
# (change it dependeing on the packages you need)
RUN R -e 'install.packages(c(\
              "tidyverse", \
              "DataExplorer", \
              "berryFunctions", \
              "tools", \
              "bit64", \
              "remotes", \
              "rlang", \
              "ellipsis", \
              "readxl", \
              "tidyquant", \
              "data.table", \
              "DT", \
              "writexl", \
              "fs", \
              "rlist", \
              "timetk", \
              "lubridate", \
              "imputeTS", \
              "smooth", \
              "urca", \
              "forecast", \
              "tidymodels", \
              "modeltime", \
              "modeltime.ensemble", \
              "modeltime.resample", \
              "modeltime.gluonts", \
              "modeltime.h2o", \
              "ranger", \
              "TSrepr", \
              "yardstick", \
              "reactable", \
              "plotly", \
              "factoextra", \
              "shiny", \
              "shinycssloaders", \
              "shinydashboard", \
              "shinydashboardPlus", \
              "dashboardthemes", \
              "shinyEffects", \
              "shinyWidgets", \
              "shinyalert", \
              "shinyjs", \
              "fresh" \
            ), \
            repos="https://packagemanager.rstudio.com/cran/__linux__/focal/2021-04-23"\
          )'

# copy the app directory into the image
COPY Forecaster /srv/shiny-server/Forecaster

# copy the app to the image
COPY Forecaster.Rproj /srv/shiny-server/Forecaster
COPY app.R /srv/shiny-server/Forecaster
COPY source /srv/shiny-server/Forecaster/01_source

# select port
EXPOSE 3838

RUN sudo chown -R shiny:shiny /srv/shiny-server/Forecaster

# run app
CMD ["/usr/bin/shiny-server.sh"]