#Neuralprophet Python environment setup

remotes::install_github("AlbertoAlmuinha/neuralprophet")

install_nprophet()

#Check if Neural Prophet (Python) is available
reticulate::py_module_available("neuralprophet")

##Troubleshooting
#Check if Conda is available
reticulate::conda_version()
  #If no version is returned:
reticulate::install_miniconda()
install_gluonts()


