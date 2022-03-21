#Python environment setup

library(reticulate)

py_install(
  packages = c(
    "mxnet",
    "gluonts",
    "numpy",
    "pandas",
    "scikit-learn",
    "matplotlib",
    "seaborn",
    "pathlib",
    "neuralprophet",
    "pillow",
    "pytorch"
  ),
  envname = "forecastapp_env",
  method  = "conda",
  python_version = "3.7",
  pip     = TRUE
)
