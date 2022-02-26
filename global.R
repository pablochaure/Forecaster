if (!Sys.info()[['user']] == 'RA135GG'){
  # When running on shinyapps.io, create a virtualenv 
  envs<-reticulate::virtualenv_list()
  if(!'forecaster_app' %in% envs)
  {
    reticulate::virtualenv_create(envname = 'forecaster_app', 
                                  python  = 'python3')
    reticulate::virtualenv_install('forecaster_app', 
                                   packages = c('numpy',
                                                'python-xbrl',
                                                'pandas',
                                                'loguru',
                                                'xmltodict',
                                                'xlsxwriter',
                                                'bs4'))
  }
}