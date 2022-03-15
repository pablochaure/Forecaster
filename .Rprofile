# This file configures the virtualenv and Python paths differently depending on
# the environment the app is running in (local vs remote server).

# Edit this name if desired when starting a new app
VIRTUALENV_NAME = 'forecaster'

# ------------------------- Settings (Edit local settings to match your system) -------------------------- #

if (Sys.info()[['user']] == 'shiny'){
  
  # Running on shinyapps.io
  Sys.setenv(PYTHON_PATH = 'python3')
  Sys.setenv(VIRTUALENV_NAME = VIRTUALENV_NAME)
  print(Sys.getenv("RETICULATE_PYTHON"))
  Sys.setenv(RETICULATE_PYTHON = '/home/shiny/.virtualenvs/forecaster/bin/python3')
  print(Sys.getenv("RETICULATE_PYTHON"))
  
} else if (Sys.info()[['user']] == 'rstudio-connect'){
  
  # Running on remote server
  Sys.setenv(PYTHON_PATH = '/opt/python/3.7.1/bin/python3')
  Sys.setenv(VIRTUALENV_NAME = paste0(VIRTUALENV_NAME, '/')) # include '/' => installs into rstudio-connect/apps/
  Sys.setenv(RETICULATE_PYTHON = paste0(VIRTUALENV_NAME, '/bin/python'))
  
} else {
  
  # Running locally
  options(shiny.port = 7450)
  Sys.setenv(PYTHON_PATH = 'C:\\Users\\RA135GG\\AppData\\Local\\r-miniconda\\envs\\forecaster\\pyhton.exe')
  Sys.setenv(VIRTUALENV_NAME = VIRTUALENV_NAME) # exclude '/' => installs into ~/.virtualenvs/
  # RETICULATE_PYTHON is not required locally, RStudio infers it based on the ~/.virtualenvs path
}
