##Setting up a Python environment
  library(reticulate)
  library(tidyverse)

reticulate::conda_list()

# py_install(
#   packages = c(
#     "mxnet",
#     "gluonts",
#     "numpy",
#     "pandas",
#     "pathlib"
#   ),
#   envname = "gluonts_forecastapp",
#   method  = "conda",
#   python_version = "3.6",
#   pip     = TRUE
# )


env_path <- reticulate::conda_list() %>%
  filter(name == "r-gluonts") %>%
  pull(python)

Sys.setenv(GLUONTS_PYTHON = env_path)

Sys.getenv("GLUONTS_PYTHON") 

reticulate::py_discover_config()
reticulate::use_condaenv("r-gluonts")
library(modeltime.gluonts)
install_gluonts()

modeltime.gluonts::is_gluonts_activated()
