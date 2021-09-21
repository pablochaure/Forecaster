########### EY FORECASTING APP #################

# LIBRARIES ----
source(file = "00_scripts/libraries.R")
libraries()

# FUNCTIONS ----
source(file = "00_scripts/f_frequency_data.R")
source(file = "00_scripts/f_sliderInput2.R")
source(file = "00_scripts/f_read_data.R")
source(file = "00_scripts/f_select_data.R")
source(file = "00_scripts/f_count_rangeselector.R")
source(file = "00_scripts/f_plot_acf.R")
source(file = "00_scripts/f_manual_arima.R")
source(file = "00_scripts/f_auto_arima.R")
source(file = "00_scripts/f_prophet_forecast.R")
source(file = "00_scripts/f_prophetboost_forecast.R")
source(file = "00_scripts/f_randomforest_forecast.R")
source(file = "00_scripts/f_xgboost_forecast.R")
source(file = "00_scripts/f_ml_models.R")
source(file = "00_scripts/f_get_loadings.R")
source(file = "00_scripts/f_ensemble_calibration.R")
source(file = "00_scripts/f_frequency_to_pandas.R")
source(file = "00_scripts/f_deepar_forecast.R")
source(file = "00_scripts/f_nbeats_forecast.R")
source(file = "00_scripts/f_DL_models.R")

# # PYTHON FUNCTIONS ----
# reticulate::source_python(file = "00_Python_code/DLTSForecast.py")

# Shiny settings ----
options(shiny.maxRequestSize=30*1024^2) 


# UI ELEMENTS ----

## 1. Header ----
header <- dashboardHeader(
    title = div(
        span(img(src    = "EY_Logo_Beam_RGB_White_Yellow.png",
                 width  = "12%",
                 height = "12%",
                 style = "vertical-align: top; margin-top: 2px;"
             )),
        span(tags$b("FORECASTING TOOL"),
                    style = "font-size: 21px; font-family: EYInterstate, sans-serif; padding-bottom: 50px"
        )
    ),
    titleWidth = 300
)

## 2. Sidebar ----
sidebar <- dashboardSidebar(width = 300, 
    
    sidebarMenu(
        menuItem(text     = tags$b("APP Description"),
                 tabName  = "app_description",
                 selected = TRUE,
                 icon     = icon("readme")
        ),
        menuItem(text     = tags$b("Load Data"),
                 tabName  = "app_load",
                 icon     = icon("file-upload")
        ),
        menuItem(text     = tags$b("Data Exploration"),
                 tabName  = "app_exploration",
                 icon     = icon("search")
        ),
        
        menuItem(text     = tags$b("ARIMA forecast"),
                 tabName  = "arima",
                 icon     = icon("chart-line"),
                 menuSubItem(text    = "Description",
                             tabName = "arima_readme"
                 ),
                 menuSubItem(text    = "Forecasting model",
                             tabName = "arima_model"
                 )
        ),
        menuItem(text     = tags$b("ML forecast"),
                 tabName  = "ml",
                 icon     = icon("user-cog"),
                 menuSubItem(text    = "Description",
                             tabName = "ml_readme"
                 ),
                 menuSubItem(text    = "Forecasting model",
                             tabName = "ml_model"
                 )
        ),
        menuItem(text     = tags$b("DL forecast"),
                 tabName  = "dl",
                 icon     = icon("brain"),
                 menuSubItem(text    = "Description",
                             tabName = "dl_readme"
                 ),
                 menuSubItem(text    = "Forecasting model",
                             tabName = "dl_model"
                 )
        )
    )
)

## 3. Control Bar ----
controlbar <- dashboardControlbar(
    disable = TRUE
)

## 4. Body ----
body <- dashboardBody(
    
    shinyjs::useShinyjs(),
    
    useShinyalert(),
    
    chooseSliderSkin(
        skin = c("Flat"),
        color = "#ffe600"
    ),

    # * CSS ----
    tags$head(tags$style(HTML('/* logo */
                               .skin-blue .main-header .logo {background-color: #333333;}
                                
                               /* body */ 
                               .content-wrapper, .right-side {background-color: #f0f0f0;}

                               /* navbar (rest of the header) */
                               .skin-blue .main-header .navbar {background-color: #333333;}

                               /* main sidebar */
                               .skin-blue .main-sidebar {background-color: #333333;}
                              
                               .box.box-solid.box-primary>.box-header {background: #333333}

                               .box.box-solid.box-primary{background: #ffffff}
                              
                               div.box {
                                        text-align: left;
                                        border-style: solid;
                                        border-bottom-color: #ffffff;
                                        border-left-color:  #ffffff;
                                        border-right-color:#ffffff;
                                        border-top-color: #ffffff;
                                        border-bottom-width:5px;
                                        border-top-width:5px;
                                        border-left-width:5px;
                                        border-right-width:5px;
                               }
                               
                              .skin-blue .sidebar-menu>li.active>a {
                                border-left-color: #ffe600;}
                                
                              .skin-blue .sidebar-menu .treeview-menu>li>a {
                                color: #b0ac8b;}
                              
                              .skin-blue .sidebar-menu .treeview-menu>li.active>a, .skin-blue .sidebar-menu .treeview-menu>li>a:hover {
                                color: #ffe600;
                              }
                              
                              .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li.menu-open>a, .skin-blue .sidebar-menu>li:hover>a {
                                color: #ffe600;
                                background: #1e282c;
                              }
                                
                                
                              .navbar {
                                height: 60px;
                                min-height:25px !important;
                              }
                                
                              .navbar-nav > li > a, .navbar-brand {
                                padding-top:5px !important; 
                                padding-bottom:5px !important;
                                height: 25px;
                              }
                              
                              /* Switch */
                              .bootstrap-switch .bootstrap-switch-handle-off.bootstrap-switch-success,
                              .bootstrap-switch .bootstrap-switch-handle-on.bootstrap-switch-success {
                                background: #ffe600;
                                color: #2e2e38;
                              }
                              
                              /* Download handlers */
                              .download_button{
                                background-color: #ffe600;
                              }
                              
                              /* AppButton */
                              .btn-default .badge{
                                background-color:#ffe600!important;
                                color:#2e2e38!important;
                              }
                              .btn-app{
                                border: 1px solid #ffe600;
                              }
                              
                              /** Active tabs **/
                              /* Tabs */
                              .nav-tabs-custom>.nav-tabs>li.active {
                                border-top-color: #ffe600;
                              }
                              
                              a {
                                color: #2e2e38;
                              }
                              
                              .nav-tabs>li.active>a, .nav-tabs>li.active>a:focus, .nav-tabs>li.active>a:hover {
                                color: #ffd900;
                                cursor: default;
                                background-color: #fff;
                                border: 1px solid #ffd900;
                                border-bottom-color: transparent;
                              }
                              
                              .pretty input:checked~.state.p-warning .icon,
                              .pretty input:checked~.state.p-warning .svg,
                              .pretty.p-toggle .state.p-warning .icon, .pretty.p-toggle .state.p-warning .svg {
                                background-color: #ffe600;
                              }
                              
                              /* width log_trans label */
                              .logtrans_label {
                                width: 181px;
                              }
                              
                              /* width log_trans label */
                              .smoother_label{
                                padding-left: 120px;
                              }
                                
                              /* sliders */
                              .irs--flat .irs-from, .irs--flat .irs-to, .irs--flat .irs-single {
                                color: black;
                                font-size: 11px;
                                background-color: #ffe600;
                              }
                              .irs-bar-edge, .irs-bar, .irs-single:after, .irs-from:after, .irs-to:after, .irs-slider {
                              filter: hue-rotate(-299.566563467492deg) saturate(64.1350210970464%) brightness(159.693626%);
                              }
                              
                              /* Progress bar */
                              .progress-bar{
                                background-color: #ffe600;
                              }
                              .shiny-notification{
                                border: 3px solid #ffe600;
                                border-radius: 9px;
                              }
                              
                              /* VerbatimTextOutput */
                              code, kbd, pre, samp {
                                font-family: EYInterstate, sans-serif;
                                font-weight: 400;
                              }
                              
                              .seasonality_plot_titles{
                                margin-left: 60px;
                                margin-bottom: 0px;
                              }
                              
                              .box-header.with-border {
                                border-bottom: 1px solid #ffe600;
                              }
                              
                              /* External/documentation links */
                              .ref_link{
                                color: #e6bc00
                              }'
                          )
             )
    ),
    
    includeCSS("www/style.css"),
    
    tabItems(
        ### 4.1 app_description tab content ----
        tabItem(
            tabName = "app_description",
            class   = "container",
            
            fluidRow(
                div(
                    wellPanel(
                        style = "background-color: white;",
                        fluidRow(
                            column(
                                width = 12,
                                tags$h1(tags$img(src    = "EY_Logo_Beam_RGB-OffBlack-Yellow.png",
                                                 width  = "5%",
                                                 height = "5%",
                                                 style  = "vertical-align: bottom; padding-bottom: 7px"),
                                         tags$b("FORECASTING TOOL")
                                ),
                                br(),
                                p(HTML("The EY Forecasting Tool is an interactive user interface to explore, visualize and forecast time series data with a wide range of models at your disposal.")),
                                p(HTML("This application is designed with the idea that the user will navigate through it with the help of the side menu. The only requisite for the good functioning of its forecasting abbilities is to load the data and then select the preferred forecasting framework.")),
                                br(),
                                tags$h3(tags$b("LOAD DATA:")),
                                p(HTML("The user can upload a CSV file with one or multiple (grouped) time series data. The minimum requirements for the file to be correctly accepted by the application are:<br/>
                                       &nbsp&nbsp&nbsp- Must be a .csv file.<br/>
                                       &nbsp&nbsp&nbsp- The only accepted separators between values are: , and ;<br/>
                                       &nbsp&nbsp&nbsp- Must contain at least two variables: a date feature, with an appropriate date format, and the value to be forecasted by the models.<br/>
                                       &nbsp&nbsp- For hierarchical or groupped time series forecasting, there must be an id column contained in the dataset to identify the different time series.<br/>
                                       The date, value and, optionally, the id variables must be selected by the user prior to continuing to the modelling stage.<br/>
                                       Variable formats are shown for the user to see what they have inputted as well as the frequency of the date variable.")),
                                br(),
                                tags$h3(tags$b("EXPLORE DATA:")),
                                p(HTML("The tool provides many descriptive and interactive visualizations for exploring the uploaded data. The included features are:<br/>
                                       &nbsp&nbsp&nbsp- Data table to inspect the inputted values.<br/>
                                       &nbsp&nbsp&nbsp- Summary of the date variable, including: start/end dates, frequency and units of the data.<br/>
                                       &nbsp&nbsp&nbsp- Time series plot.<br/>
                                       &nbsp&nbsp&nbsp- ACF and PACF plots.<br/>
                                       &nbsp&nbsp&nbsp- Time series breakdown: seasonality, trend and errors plots.<br/>
                                       &nbsp&nbsp&nbsp- Seasonality plots dependent on the frequency of the time series.<br/>
                                       &nbsp&nbsp&nbsp- Anomaly detection plot.<br/>
                                       <b>Beware</b> that the time series breakdown and anomaly detection plots are not available for time series with missing values.")),
                                br(),
                                tags$h3(tags$b("FORECASTING MODELS:")),
                                p(HTML("The interface allows the user to compare different fitted time series models and their forecasts with the following algorithms:<br/>
                                       &nbsp&nbsp&nbsp- ARIMA: autoARIMA, ARIMABoost (with xgboost) and manual ARIMA.<br/>
                                       &nbsp&nbsp&nbsp- ML modelling: Prophet, ProphetBoost, xgboost, Random Forest.<br/>
                                       &nbsp&nbsp&nbsp- ML ensemble of the previously trained ML models.<br/>
                                       &nbsp&nbsp&nbsp- AutoML, powered by H2O.ai.<br/>
                                       &nbsp&nbsp&nbsp- Deep Learning: DeepAR and NBeats Ensemble.<br/>")),
                                p(HTML("To each model, the user must provide a horizon for the future predictions. This amount will correspond to a number of periods in the same frequecny as the date variable. This horizon period will also be used to split the data between the training and test set.<br/>")),
                                p(HTML("Each of the forecasting model menu items is subdivided into three tabs:<br/>
                                       &nbsp&nbsp&nbsp<b>1. Model training:</b><br/>
                                       &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- Includes input selectors for the corresponding parameters for each of the algorithms.<br/>
                                       &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- Forecast visualization on the testing set. Including median values and 95% confidence intervals.<br/>
                                       &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- An interactive table is displayed including the accuracy metrics for the forecast on the testing set to assess the fit of the model to the data. Read more about forecasting accuracy metrics"),
                                  tags$a("here", href = "Forecast_KPIs.pdf", target="_blank", class = "accuracy_link"),
                                  HTML(".<br/>&nbsp&nbsp&nbsp<b>2. Forecast plot:</b><br/>
                                       &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- Forecast visualization with the refitted model to the full dataset (train + test).<br/>
                                       &nbsp&nbsp&nbsp<b>3. Forecast table:</b><br/>
                                       &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- Interactive table with all the trained models' predictions and their correspondent confidence intervals (95%).<br/>
                                       &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- Forecast table downloader. The user is offered the possibility of downloading a CSV file with the forecasted values for all trained models. The file name is constructed as follows:"),
                                  tags$p("{forecast horizon periods}_{arima/ml/dl}_forecast_{original file name}.csv", style = "text-align:center;")
                                ),
                                style = "text-align:justify; font-size: 20px"
                            )
                        )
                    )
                )
            )
        ),
        
        ### 4.2 app_load tab content ----
        tabItem(tabName = "app_load",
                class = "fluid-container",
                fluidRow(
                    box(title="Upload data",width = 12,
                        column(width = 4,
                               fileInput(
                                   inputId  = "file_main",
                                   label    = "Upload time series dataset (.csv)",
                                   multiple = FALSE,
                                   accept   = c(".csv",
                                                'text/csv',
                                                'text/comma-separated-values')
                               )
                        ),
                        column(width = 6,offset = 2,
                               fluidRow(
                                       uiOutput("date_dropdown")
                                   ),
                                   fluidRow(
                                       uiOutput("value_dropdown")
                                   ),
                                   
                                   fluidRow(
                                       shinyWidgets::prettyCheckbox(
                                           inputId = "id_checkbox",
                                           label = "Do you have multiple time series in your data?", 
                                           value = FALSE,
                                           status = "warning",
                                           icon   = icon("check")
                                       ),
                                       
                                       uiOutput("id_dropdown")
                                   ),
                                   
                                   fluidRow(
                                       appButton(inputId = "explore",
                                                 label = "Load variables",
                                                 class = "pull-right",
                                                 icon = icon("database"),
                                                 dashboardBadge("Start",
                                                                color = "yellow")
                                       )
                                   )
                       )
                   ),
                   
                   # column(width = 4,
                   #        box(width= NULL,
                   #            title="Missing values in the data",
                   #            verbatimTextOutput("text_missing")
                   #        )
                   #  )
                ),
                
                fluidRow(
                    column(width = 4,
                           box(width       =NULL,
                               title       ="Data preview",
                               collapsible = TRUE,
                               reactableOutput(outputId = "table_original")
                           )
                    ),
                    
                    column(width = 4,
                           box(width       = NULL,
                               title       = "Data summary",
                               collapsible = TRUE,
                               verbatimTextOutput("text_str"),
                               verbatimTextOutput("text_summary")
                           )
                    ),
                    
                    column(width = 4,
                           box(width       = NULL,
                               title       = "Date variable frequency",
                               collapsible = TRUE,
                               verbatimTextOutput("text_frequency")
                           )
                    )
                )
        ),
        
        ### 4.3 app_exploration tab content ----
        tabItem(tabName = "app_exploration",
                class = "fluid-container",
                fluidRow(
                    column(
                        width =12,
                        tabBox(width=NULL,
                               title="Data Exploration",
                               tabPanel(title = "Data table + Summary",
                                        
                                        wellPanel(style = "background-color: white;",
                                                  fluidRow(
                                                      reactableOutput(outputId = "ts_summary")
                                                  )
                                        ),
                                        br(), br(),
                                        
                                        wellPanel(style = "background-color: white;",
                                                  fluidRow(
                                                      reactableOutput(outputId = "table_ts")
                                                  )
                                        )
                               ),
                               
                               tabPanel(title = "Time series plot",
                                        wellPanel(
                                            style = "background: white",
                                            fluidRow(
                                                # box(width = 6,
                                                column(width = 2,
                                                       helpText("Logarithmic Transformation",
                                                                class = "logtrans_label")
                                                       
                                                ),
                                                column(width = 2,
                                                       shinyWidgets::switchInput(
                                                           inputId    = "ts_plot_log_trans",
                                                           onStatus   = "success",
                                                           offStatus  = "danger",
                                                           value      = FALSE,
                                                           width      = "auto"
                                                       )
                                                ),
                                                column(width = 2,
                                                       helpText("Smoother",
                                                                class = "smoother_label")
                                                ),
                                                column(width = 2,
                                                       shinyWidgets::switchInput(
                                                           inputId    = "ts_plot_smooth",
                                                           onStatus   = "success",
                                                           offStatus  = "danger",
                                                           value      = TRUE,
                                                           width      = "auto"
                                                       )
                                                ),
                                                column(width = 4,
                                                       shiny::sliderInput(
                                                           inputId = "ts_plot_smooth_span",
                                                           label   = "Smooth Span",
                                                           value   = 0.75,
                                                           min     = 0.05,
                                                           max     = 1,
                                                           ticks   = FALSE
                                                       )
                                                )
                                            ),
                                            fluidRow(
                                                plotlyOutput(outputId = "ts_plot")
                                            )
                                        )
                               ),
                               
                               tabPanel(title = "ACF/PACF",
                                        wellPanel(
                                            style = "background-color: white;",
                                            fluidRow(
                                                tags$h3("ACF",
                                                        class = "seasonality_plot_titles"),
                                                plotlyOutput(outputId = "ts_ACF")
                                            ),
                                            
                                            fluidRow(
                                                tags$h3("PACF",
                                                        class = "seasonality_plot_titles"),
                                                plotlyOutput(outputId = "ts_PACF")
                                            )
                                        )
                               ),
                               
                               tabPanel(title = "Time series breakdown",
                                        wellPanel(style = "background-color: white;",
                                                  fluidRow(
                                                      tags$h3("Seasonality",
                                                              class = "seasonality_plot_titles"),
                                                      plotlyOutput(outputId = "ts_season")
                                                  ),
                                                  
                                                  fluidRow(
                                                      tags$h3("Trend",
                                                              class = "seasonality_plot_titles"),
                                                      plotlyOutput(outputId = "ts_trend")
                                                  ),
                                                  
                                                  fluidRow(
                                                      tags$h3("Errors",
                                                              class = "seasonality_plot_titles"),
                                                      plotlyOutput(outputId = "ts_remainder")
                                                  )
                                        )
                               ),
                               
                               tabPanel(title = "Seasonality plot",
                                        uiOutput(outputId = "ts_seasonality")
                               ),
                               
                               tabPanel(title = "Anomaly detection",
                                        plotlyOutput(outputId = "ts_anomaly")
                               )
                        )
                    )
                )
        ),
        
        ### 4.4 ARIMA----
        ##### 4.4.1 arima_readme tab content ----
        tabItem(
            tabName = "arima_readme",
            class   = "container",
            
            fluidRow(
                div(
                    wellPanel(
                        style = "background-color: white;",
                        fluidRow(
                            column(
                                width = 12,
                                tags$h2(tags$b("ARIMA MODELLING")),
                                p(),
                                p(HTML("ARIMA models are, in theory, the most general class of models for forecasting a time series. ARIMA models are a subset of linear regression models that attempt to use the past observations of the target variable to predict its future values. ARIMA models are represented as <b>ARIMA(p,d,q)</b>. ")),
                                p(),
                                p(HTML("ARIMA models are based on <b>three parts</b> that give it its name:<br/>
                                       &nbsp&nbsp&nbsp <b>1.- AutoRegressive</b> part: A model that uses the dependent relationship between an observation and some number of lagged observations.<br/>
                                       &nbsp&nbsp&nbsp <b>2.- Integration</b> part: A model that applies a differencing step to the raw observations. Differencing is a transformation applied to time-series data in order to make it stationary. This process makes the main statistical properties to not depend on the time that the sample was taken, thus eliminating trend and seasonality and stabilizing the mean and variance of the time series for a more robust model.<br/>
                                       &nbsp&nbsp&nbsp <b>3.- Moving Average</b> part: A model that uses the dependency between an observation and a residual error from a moving average model applied to lagged observations. MA forecasts the target values using the model’s past errors, being these independent and approximately normally distributed (error is a random variable).")),
                                p(HTML("<b>Parameters:</b><br/>
                                       &nbsp&nbsp&nbsp- <b>p:</b> AR order. Number of lagged observations included in the model as predictors.<br/>
                                       &nbsp&nbsp- <b>d:</b> Degree of differencing. Number of times that the raw observations are differenced to make the time series stationary.<br/>
                                       &nbsp&nbsp&nbsp- <b>q:</b> MA order. Size of the moving average window or, in other words, the number of lagged forecast errors.<b")),
                                tags$h3(tags$b("Seasonal ARIMA(SARIMA)")),
                                p(HTML("One issue with ARIMA models is that it does not support seasonality. For time series with definded seasonality, SARIMA models are more appropriate as they use seasonal differencing. In this case, instead of subtracting consecutive terms, the value from the previous season is substracted. SARIMA models are represented as <b>SARIMA(p,d,q)x(P,D,Q)</b>.")),
                                p(HTML("<b>Parameters:</b><br/>
                                       &nbsp&nbsp&nbsp- <b>P:</b> SAR order.<br/>
                                       &nbsp&nbsp&nbsp- <b>D:</b> degree of seasonal differencing.<br/>
                                       &nbsp&nbsp&nbsp- <b>Q:</b> SMA order.<br/>
                                       &nbsp&nbsp&nbsp- <b>x:</b> Frequency of the time series (number of observations per year).")),
                                tags$h3(tags$b("Auto ARIMA")),
                                p(HTML("With the Auto Arima function, we let the system select the best p, q and d values (without human intervention) depending on the statisitcal properties of the time series. This is an automatic way of defining the best ARIMA Model by choosing the one with the lowest Akaike Information Criterion. By not using this feature, the user must provide the p, d and q values based on several statistical techniques: performing the difference (d) to eliminate the non-stationarity and plotting ACF and PACF graphs for selecting the most appropriate AR and MA orders.")),
                                tags$h3(tags$b("Auto ARIMA + xgboost")),
                                p(HTML("In this tool, an additional hybrid model is available to the user to improve forecast prediction. It uses a combination of ARIMA and xgboost to perform better on time series with weekly, daily and more frequent data by using boosting to improve modelling errors.")),
                                p(HTML("<b>Parameters:</b><br/>
                                       &nbsp&nbsp&nbsp- <b>mtry:</b> The number of predictors that will be randomly sampled at each split when creating the tree models.<br/>
                                       &nbsp&nbsp&nbsp- <b>trees:</b> The number of trees contained in the ensemble.<br/>
                                       &nbsp&nbsp&nbsp- <b>min_n:</b> The minimum number of data points in a node that are required for the node to be split further.<br/>
                                       &nbsp&nbsp&nbsp- <b>tree_depth:</b> The maximum depth of the tree (i.e. number of splits).<br/>
                                       &nbsp&nbsp&nbsp- <b>learn_rate:</b> The rate at which the boosting algorithm adapts from iteration-to-iteration.<br/>
                                       &nbsp&nbsp&nbsp- <b>loss_reduction:</b> The reduction in the loss function required to split further.<br/>")),
                                style = "text-align:justify; font-size: 20px"
                            )
                        )
                    )
                )
            )
        ),
        
        ##### 4.4.2 arima_model tab content ----
        tabItem(tabName = "arima_model",
                class = "fluid-container",
                fluidRow(
                    column(
                        width =12,
                        tabBox(width=NULL,
                               title = "ARIMA Forecast",
                               tabPanel(title = "1. Model Training",
                                        sidebarLayout(
                                            sidebarPanel(width = 4,
                                                         style = "background:  #f2f2f2",
                                                         tabsetPanel(
                                                             ###### 4.4.2.1 AutoARIMA ----
                                                             tabPanel(title = "Auto ARIMA",
                                                                      br(), br(),
                                                                      
                                                                      # uiOutput("train_test"
                                                                      # ),
                                                                      # 
                                                                      # shinyWidgets::progressBar(
                                                                      #     id          = "progress_train_test",
                                                                      #     value       = 80,
                                                                      #     display_pct = TRUE,
                                                                      #     status      = "warning",
                                                                      #     striped     = TRUE
                                                                      # ),
                                                                      
                                                                      shinyWidgets::prettyCheckbox(
                                                                          inputId = "arima_boost_checkbox",
                                                                          label = "Advanced Hybrid model", 
                                                                          value = FALSE,
                                                                          status = "warning",
                                                                          icon   = icon("check")
                                                                      ),
                                                                      
                                                                      uiOutput(
                                                                          outputId = "arima_boost"
                                                                      ),
                                                                      
                                                                      hr(),
                                                                      
                                                                      uiOutput(outputId = "arima_horizon"
                                                                      ),
                                                                      
                                                                      textOutput(
                                                                          outputId = "auto_arima_horizon_recommended"
                                                                      ),
                                                                      
                                                                      br(),
                                                                      
                                                                      shinydashboardPlus::appButton(
                                                                          inputId = "run_auto",
                                                                          label   = "Run Forecast",
                                                                          class   = "pull-right",
                                                                          icon    = icon("play"),
                                                                          dashboardBadge("Let's Go!",
                                                                                         color = "yellow",
                                                                                         class = "appbuttonbadge")
                                                                      ),
                                                                      
                                                                      br(),br(),br()
                                                             ),
                                                             ###### 4.4.2.2 Manual ARIMA ----
                                                             tabPanel(title = "Manual ARIMA",
                                                                      br(),
                                                                      
                                                                      numericInput(inputId = "ar",
                                                                                   label   = "AR order (p)",
                                                                                   min     = 0,
                                                                                   max     = 5,
                                                                                   value   = 0
                                                                      ),
                                                                      
                                                                      numericInput(inputId = "i",
                                                                                   label   = "Differencing degree (d)",
                                                                                   min     = 0,
                                                                                   max     = 5,
                                                                                   value   = 0
                                                                      ),
                                                                      
                                                                      numericInput(inputId = "ma",
                                                                                   label   = "MA order (q)",
                                                                                   min     = 0,
                                                                                   max     = 5,
                                                                                   value   = 0
                                                                      ),
                                                                      
                                                                      shinyWidgets::prettyCheckbox(
                                                                          inputId = "sarima_checkbox",
                                                                          label   = "Do you want seasonality in your model (SARIMA)?",
                                                                          value = FALSE,
                                                                          status = "warning",
                                                                          icon   = icon("check")
                                                                      ),
                                                                      
                                                                      uiOutput(outputId = "sarima"
                                                                      ),

                                                                      # uiOutput("train_test"
                                                                      # ),
                                                                      #
                                                                      # progressBar(id = "progress_train_test",
                                                                      #             value = 80,
                                                                      #             display_pct = TRUE,
                                                                      #             status = "warning",
                                                                      #             striped = TRUE
                                                                      # ),

                                                                      uiOutput(outputId = "arima_manual_horizon"
                                                                      ),
                                                                      
                                                                      textOutput(
                                                                          outputId = "manual_arima_horizon_recommended"
                                                                      ),
                                                                      
                                                                      appButton(
                                                                          inputId = "run_manual",
                                                                          label   = "Run Forecast",
                                                                          class   = "pull-right",
                                                                          icon    = icon("play"),
                                                                          dashboardBadge("Let's Go!", color = "yellow")
                                                                      ),
                                                                      br(),br(),br()
                                                             )
                                                         )
                                            ),
                                            mainPanel(
                                                wellPanel(
                                                    style = "background: white",
                                                    fluidRow(
                                                        plotlyOutput(outputId = "arima_test_plot")
                                                    ),
                                                    fluidRow(
                                                        reactableOutput(outputId = "arima_table_accuracy")
                                                    ),
                                                    tags$h5("Read more about forecasting accuracy metrics", a("here",
                                                                                                              href   = "Forecast_KPIs.pdf",
                                                                                                              target = "_blank",
                                                                                                              class  = "ref_link")
                                                    )
                                                )
                                            )
                                        )
                                ),
                               tabPanel(title = "2. Forecast plot",
                                        wellPanel(
                                            style = "background: white",
                                            fluidRow(
                                                column(width = 3,
                                                       shinyWidgets::switchInput(
                                                           inputId    = "arima_forecast_plot_legend",
                                                           label      = "Legend",
                                                           onStatus   = "success", 
                                                           offStatus  = "danger",
                                                           value      = TRUE,
                                                           labelWidth = "80px",
                                                           width      = "auto"
                                                       )
                                                ),
                                                column(width = 3,
                                                       shinyWidgets::switchInput(
                                                           inputId    = "arima_forecast_plot_conf",
                                                           label      = "Confidence",
                                                           onStatus   = "success", 
                                                           offStatus  = "danger",
                                                           value      = FALSE,
                                                           labelWidth = "80px",
                                                           width      = "auto"
                                                       )
                                                )
                                            ),
                                            fluidRow(
                                                plotlyOutput(outputId = "arima_forecast_plot")
                                            )
                                        )   
                               ),
                               tabPanel(title = "3. Forecast table",
                                        wellPanel(
                                            style = "background: white",
                                            fluidRow(
                                                reactableOutput(outputId = "arima_table_forecast")
                                            ),
                                            fluidRow(
                                                downloadButton(outputId = "arima_download_forecast",
                                                               label    = "Download ARIMA Forecasted Values (.csv)",
                                                               class    = "download_button"
                                                )
                                            )
                                        ) 
                               )
                        )
                    )
                )
        ),
    
        ### 4.5 ML----
        ##### 4.5.1 ml_readme tab content ----
         tabItem(
             tabName = "ml_readme",
             class   = "container",
        
             fluidRow(
                 div(
                     wellPanel(
                         style = "background-color: white;",
                         fluidRow(
                             column(
                                 width = 12,
                                 tags$h2(tags$b("MACHINE LEARNING MODELLING")),
                                 p(),
                                 p(HTML("This application offers several Machine Learning algorithms and techniques available to the user for forecasting the uploaded time series with the high performance this predictive modelling can offer.")),
                                 p(),
                                 p(HTML("The different algorithms' functioning will not be detailed exhaustively due to the many intricacies each of them has. For the user to find out more, the documentation for each of the algorithms is available through the linked resource.<br/>
                                       Algorithm parameter tuning has been left aside from the application scope and the results obtained herein may be of advisory nature with room for improvement.<br/>
                                       When training the models, the date variable is decomposed into a collection of time-based external regressors that give an advanced predictive cappability to the algorithm in use.<br/>
                                       This modelling section is divided into three tabs containing different frameworks in the Machine Learning domain.")),
                                 tags$h3(tags$b("1. ML Models:")),
                                 p(HTML("In the current version of the tool, four algorithms are available to be chosen by the user for their training:")),
                                 tags$h4(tags$b("- Prophet:")),
                                 p(HTML("This is an algorithm developed by Facebook for time series forecasting that is desgined to handle the common features of business time series data. It is a decomposable time series model with three main model components: trend, seasonality and holidays. They are combined in the following equation:"),
                                   tags$p("y(t) =g(t) +s(t) +h(t) +ε", style = "text-align:center;"),
                                   HTML("Here, g(t) is the trend function which models non-periodic changes in the value of the time series, s(t)  represents  periodic  changes  (e.g.,  weekly  and  yearly  seasonality) and h(t) represents the effects of holidays which occur on potentially irregular schedules over one or more days.  The error term ε represents any idiosyncratic changes which are not accommodated  by  the  model.<br/>
                                       You may find the Prophet documentation"),
                                   a("here", href = "https://facebook.github.io/prophet/", target = "_blank", class = "ref_link")
                                 ),
                                 tags$h4(tags$b("- XGBoost:")),
                                 p(HTML("XGBoost is short for e<b>X</b>treme <b>G</b>radient <b>Boost</b>ing package. It is an optimized distributed gradient boosting library that implements machine learning algorithms under the Gradient Boosting framework. XGBoost provides a parallel tree boosting (also known as GBDT, GBM) that solve many data science problems in a fast and accurate way.<br/>
                                        You may find the XGBoost documentation"),
                                   a("here", href = "https://xgboost.readthedocs.io/en/latest/index.html", target = "_blank", class = "ref_link")
                                 ),
                                 tags$h4(tags$b("- Prophet Boost:")),
                                 p(HTML("This is a special technique for increasing modelling accuracy of the Prophet algorithm. It combines an algorithm that performs really well on seasonal variation and external regressors, XGBoost, with Prophet for predicting the trend. With this technique, the issue of XGBoost incorrectly modeling trend is prevented by combining its power with the Prophet algorithm and leveraging XGBoost's ability to model residual errors.")),
                                 tags$h4(tags$b("- Random Forest:")),
                                 p(HTML("It is a tree-based algorithm that uses Bagging to combine many decision trees into a single prediction. Its strength is that it can model seasonality really well, but it is not able to predict beyond the max/min target value (e.g. increasing/decreasing trend). This Random Forest model is trained using the Ranger package, which is a fast implementation of random forests or recursive partitioning.<br/>
                                        You may find the Ranger documentation"),
                                   a("here", href = "https://www.jstatsoft.org/article/view/v077i01", target = "_blank", class = "ref_link")
                                 ),
                                 tags$h3(tags$b("2. Ensemble Models:")),
                                 p(HTML("With the previously selected and trained models, the user may harness the predictive power of these by combining their strengths into a single better model by using this modelling technique called ensembling. <br/>
                                        Currently, three ensembling strategies are available:<br/>
                                        &nbsp&nbsp<b>- Mean and median average ensemble:</b> this techniques take a simple average of the sub-models predictions, mean or median average. Therefore, all models in the ensemble will be awarded the same loading/weight. Beware that if there are extremely bad models in the input, the ensemble performance will be greatly affected because this model will pull the average.<br/>
                                        &nbsp&nbsp<b>- Weighted average ensemble:</b> it works the same way as the average ensembles, but each model now gets a different loading. These loadings are based on a simple ranking of all the inputted models which are awarded a weight relative to their position in said ranking.")),
                                 p(HTML("Mean and median average are fast and good approaches, but weighted average ensembles can, potentially, perform much better as it gives more value to the best performing stand-alone model.<br/>
                                        In the near future, stacked ensembles will be introduced to this section of the tool."
                                 )),
                                 tags$h3(tags$b("3. Auto ML:")),
                                 p(HTML("This feature allows the user to train many Machine Learning models using"),
                                   a("H2O.ai", href = "http://h20.ai/", target = "_blank", class = "ref_link"),
                                   HTML("'s proprietary algorithm (H2O AutoML). Automatic Machine Learning is the process of automating algorithm selection, feature generation, hyperparameter tuning, iterative modeling, and model assessment. AutoML make it easy to train and evaluate machine learning models for the forecasting task at hand.<br/>
                                        From the trained models in the specified time, the best performing ones are selected using a grid search for hyperparameter tuning. Furthermore, after all the models are trained, the algorithm creates two stacked ensemble models: one that combines all models and another with the best models of each algorithm family.<br/>
                                        You may find the H2O  AutoML documentation"),
                                   a("here", href = "http://docs.h2o.ai/h2o/latest-stable/h2o-docs/automl.html", target = "_blank", class = "ref_link")
                                 ),
                                 style = "text-align:justify; font-size: 20px"
                             )
                         )
                     )
                 )
             )
         ),

        ##### 4.5.2 ml_model tab content ----
         tabItem(tabName = "ml_model",
                 class = "fluid-container",
                 fluidRow(
                     column(
                         width =12,
                         tabBox(width=NULL,
                                title = "Machine Learning Models Forecast",
                                tabPanel(title = "1. Model Training",
                                         sidebarLayout(
                                             sidebarPanel(width = 4,
                                                          style = "background:  #f2f2f2",
                                                          tabsetPanel(
                                                              ###### 4.5.2.1 ML models ----
                                                              tabPanel(title = "1. ML models",
                                                                       br(),
                                                                       
                                                                       shinyWidgets::pickerInput(
                                                                           inputId  = "ml_model_selection",
                                                                           label    = "Select the models you wish to train:", 
                                                                           choices  = c("Prophet", "XGBoost","Prophet Boost", "Random Forest"),
                                                                           options  = list('actions-box' = TRUE),
                                                                           multiple = TRUE
                                                                       ),
                                                                       
                                                                       hr(),
                                                                       
                                                                       uiOutput(outputId = "ml_horizon"
                                                                       ),
                                                                       
                                                                       textOutput(
                                                                           outputId = "ml_horizon_recommended"),
                                                                       
                                                                       br(),
                                                                       # uiOutput("train_test"
                                                                       # ),
                                                                       #
                                                                       # shinyWidgets::progressBar(
                                                                       #     id          = "progress_train_test",
                                                                       #     value       = 80,
                                                                       #     display_pct = TRUE,
                                                                       #     status      = "warning",
                                                                       #     striped     = TRUE
                                                                       # )
                                                                       shinydashboardPlus::appButton(
                                                                           inputId = "run_ml",
                                                                           label   = "Run Forecast",
                                                                           class   = "pull-right",
                                                                           icon    = icon("play"),
                                                                           dashboardBadge("Let's Go!",
                                                                                          color = "yellow",
                                                                                          class = "appbuttonbadge")
                                                                       ),
                                                                       
                                                                       br(),br(),br()
                                                              ),
                                                              ###### 4.5.2.2 Ensemble model ----
                                                              tabPanel(title = "2. Ensemble",
                                                                       br(),
                                                                       
                                                                       shinyWidgets::pickerInput(
                                                                           inputId  = "ensemble_selection",
                                                                           label    = "Select the ensemble technique you wish to use:", 
                                                                           choices  = c("Mean average", "Median average", "Weighted average"),
                                                                           options  = list('actions-box' = TRUE),
                                                                           multiple = TRUE
                                                                       ),
                                                                       
                                                                       uiOutput(outputId = "ensemble_horizon"
                                                                       ),
                                                                       
                                                                       textOutput(
                                                                           outputId = "ensemble_horizon_recommended"),
                                                                       
                                                                       br(),
                                                                       # uiOutput("train_test"
                                                                       # ),
                                                                       #
                                                                       # shinyWidgets::progressBar(
                                                                       #     id          = "progress_train_test",
                                                                       #     value       = 80,
                                                                       #     display_pct = TRUE,
                                                                       #     status      = "warning",
                                                                       #     striped     = TRUE
                                                                       # )
                                                                       shinydashboardPlus::appButton(
                                                                           inputId = "run_ensemble",
                                                                           label   = "Run Forecast",
                                                                           class   = "pull-right",
                                                                           icon    = icon("play"),
                                                                           dashboardBadge("Let's Go!",
                                                                                          color = "yellow",
                                                                                          class = "appbuttonbadge")
                                                                       ),
                                                                       
                                                                       br(),br(),br()
                                                              ),
                                                              ###### 4.5.2.3 AutoML ----
                                                              tabPanel(title = "3. AutoML",
                                                                       br(),
                                                                       
                                                                       numericInput(inputId = "auto_time",
                                                                                    label   = "Maximum training runtime (seconds):",
                                                                                    min     = 0,
                                                                                    max     = 600,
                                                                                    value   = 30
                                                                       ),
                                                                       numericInput(inputId = "auto_model_time",
                                                                                    label   = "Maximum training runtime per model (seconds):",
                                                                                    min     = 0,
                                                                                    max     = 600,
                                                                                    value   = 10
                                                                       ),
                                                                       
                                                                       sliderInput(
                                                                           inputId = "auto_max_models",
                                                                           label   = "Maximum number of models:",
                                                                           min     = 1,
                                                                           max     = 200,
                                                                           value   = 30
                                                                       ),
                                                                       
                                                                       shinyWidgets::prettyCheckbox(
                                                                           inputId = "auto_nfolds_checkbox",
                                                                           label = "K-fold cross-validation", 
                                                                           value = TRUE,
                                                                           status = "warning",
                                                                           icon   = icon("check")
                                                                       ),
                                                                       
                                                                       uiOutput(
                                                                           outputId = "auto_nfolds"
                                                                       ),
                                                                       
                                                                       hr(),
                                                                       
                                                                       uiOutput(outputId = "auto_horizon"
                                                                       ),
                                                                       
                                                                       textOutput(
                                                                           outputId = "auto_horizon_recommended"),
                                                                       
                                                                       br(),
                                                                       shinydashboardPlus::appButton(
                                                                           inputId = "run_automl",
                                                                           label   = "Run Forecast",
                                                                           class   = "pull-right",
                                                                           icon    = icon("play"),
                                                                           dashboardBadge("Let's Go!",
                                                                                          color = "yellow",
                                                                                          class = "appbuttonbadge")
                                                                       ),
                                                                       
                                                                       br(),br(),br()
                                                              )
                                                          )
                                             ),
                                             mainPanel(
                                                 wellPanel(
                                                     style = "background: white",
                                                     fluidRow(
                                                         plotlyOutput(outputId = "ml_test_plot")
                                                     ),
                                                     fluidRow(
                                                         reactableOutput(outputId = "ml_table_accuracy")
                                                     ),
                                                     tags$h5("Read more about forecasting accuracy metrics", a("here",
                                                                                                               href   = "Forecast_KPIs.pdf",
                                                                                                               target = "_blank",
                                                                                                               class  = "ref_link")
                                                     )
                                                 )
                                             )
                                         )
                                ),
                                tabPanel(title = "2. Forecast plot",
                                         wellPanel(
                                             style = "background: white",
                                             fluidRow(
                                                 column(width = 3,
                                                        shinyWidgets::switchInput(
                                                            inputId    = "ml_forecast_plot_legend",
                                                            label      = "Legend",
                                                            onStatus   = "success",
                                                            offStatus  = "danger",
                                                            value      = TRUE,
                                                            labelWidth = "80px",
                                                            width      = "auto"
                                                        )
                                                 ),
                                                 column(width = 3,
                                                        shinyWidgets::switchInput(
                                                            inputId    = "ml_forecast_plot_conf",
                                                            label      = "Confidence",
                                                            onStatus   = "success",
                                                            offStatus  = "danger",
                                                            value      = FALSE,
                                                            labelWidth = "80px",
                                                            width      = "auto"
                                                        )
                                                 )
                                             ),
                                             fluidRow(
                                                 plotlyOutput(outputId = "ml_forecast_plot")
                                             )
                                         )
                                ),
                                tabPanel(title = "3. Forecast table",
                                         wellPanel(
                                             style = "background: white",
                                             fluidRow(
                                                 reactableOutput(outputId = "ml_table_forecast")
                                             ),
                                             fluidRow(
                                                 downloadButton(outputId = "ml_download_forecast",
                                                                label    = "Download ML Forecasted Values (.csv)",
                                                                class    = "download_button"
                                                 )
                                             )
                                         )
                                )
                         )
                     )
                 )
         ),
        ### 4.6 DL----
        #### 4.6.1 dl_readme tab content ----
        tabItem(
            tabName = "dl_readme",
            class   = "container",
            
            fluidRow(
                div(
                    wellPanel(
                        style = "background-color: white;",
                        fluidRow(
                            column(
                                width = 12,
                                tags$h2("DEEP LEARNING MODELLING"),
                                p(),
                                p("NBeats, DeepAR"),
                                p(),
                                p(HTML("ARIMA models are based on three parts that give it its name:<br/>
                                            &nbsp&nbsp&nbsp1.This model is very good, but can be expensive (long-running) due to the number of models that are being created. The number of models follows the formula: length(lookback_length) x length(loss_function) x meta_bagging_size <br/>
                                            &nbsp&nbsp&nbsp2.- Integration part: A model that applies a differencing step to the raw observations. Differencing is a transformation applied to time-series data in order to make it stationary. This process makes the main statistical properties to not depend on the time that the sample was taken, thus eliminating trend and seasonality and stabilizing the mean and variance of the time series for a more robust model.<br/>
                                            &nbsp&nbsp&nbsp3.- Moving Average part: A model that uses the dependency between an observation and a residual error from a moving average model applied to lagged observations. A model that forecasts the target values using the model’s past errors, being these independent and approximately normally distributed (error is a random variable).")),
                                style = "text-align:justify; font-size: 15px"
                            )
                        )
                    )
                )
            )
        ),
        #### 4.6.2 dl_model tab content ----
        tabItem(tabName = "dl_model",
                class = "fluid-container",
                fluidRow(
                    column(
                        width =12,
                        tabBox(width=NULL,
                               title = "Deep Learning Models Forecast",
                               tabPanel(title = "1. Model Training",
                                        sidebarLayout(
                                            sidebarPanel(width = 4,
                                                         style = "background:  #f2f2f2",
                                                         tabsetPanel(
                                                             tabPanel(title = "DL models",
                                                                      br(),
                                                                      
                                                                      shinyWidgets::pickerInput(
                                                                          inputId  = "dl_model_selection",
                                                                          label    = "Select the models you wish to train:", 
                                                                          choices  = c("Deep AR", "NBeats Ensemble"),
                                                                          options  = list('actions-box' = TRUE),
                                                                          multiple = TRUE
                                                                      ),
                                                                      
                                                                      numericInput(
                                                                          inputId = "dl_epochs",
                                                                          label   = "Number of epochs:",
                                                                          value   = 20,
                                                                          min     = 1,
                                                                          max     = 100,
                                                                          step    = 1   
                                                                      ),
                                                                      
                                                                      # shinyWidgets::prettyCheckbox(
                                                                      #     inputId = "dl_epochs_checkbox",
                                                                      #     label = "Epochs automatic optimization.",
                                                                      #     value = FALSE,
                                                                      #     status = "warning",
                                                                      #     icon   = icon("check")
                                                                      # ),
                                                                      
                                                                      # uiOutput(
                                                                      #     outputId = "dl_lookback"
                                                                      # ),
                                                                      
                                                                      uiOutput(
                                                                          outputId = "dl_deepar_inputs"
                                                                      ),
                                                                      
                                                                      uiOutput(
                                                                          outputId = "dl_nbeats_inputs"
                                                                      ),
                                                                      
                                                                      hr(),
                                                                      
                                                                      uiOutput(
                                                                          outputId = "dl_horizon"
                                                                      ),
                                                                      
                                                                      textOutput(
                                                                          outputId = "dl_horizon_recommended"),
                                                                      
                                                                      br(),

                                                                      shinydashboardPlus::appButton(
                                                                          inputId = "run_dl",
                                                                          label   = "Run Forecast",
                                                                          class   = "pull-right",
                                                                          icon    = icon("play"),
                                                                          dashboardBadge("Let's Go!",
                                                                                         color = "yellow",
                                                                                         class = "appbuttonbadge")
                                                                      ),
                                                                      
                                                                      br(),br(),br()
                                                             )
                                                         )
                                            ),
                                            mainPanel(
                                                wellPanel(
                                                    style = "background: white",
                                                    fluidRow(
                                                        plotlyOutput(outputId = "dl_test_plot")
                                                    ),
                                                    fluidRow(
                                                        reactableOutput(outputId = "dl_table_accuracy")
                                                    ),
                                                    tags$h5("Read more about forecasting accuracy metrics", a("here",
                                                                                                              href   = "Forecast_KPIs.pdf",
                                                                                                              target = "_blank",
                                                                                                              class  = "ref_link")
                                                    )
                                                )
                                            )
                                        )
                               ),
                               tabPanel(title = "2. Forecast plot",
                                        wellPanel(
                                            style = "background: white",
                                            fluidRow(
                                                column(width = 3,
                                                       shinyWidgets::switchInput(
                                                           inputId    = "dl_forecast_plot_legend",
                                                           label      = "Legend",
                                                           onStatus   = "success",
                                                           offStatus  = "danger",
                                                           value      = TRUE,
                                                           labelWidth = "80px",
                                                           width      = "auto"
                                                       )
                                                ),
                                                column(width = 3,
                                                       shinyWidgets::switchInput(
                                                           inputId    = "dl_forecast_plot_conf",
                                                           label      = "Confidence",
                                                           onStatus   = "success",
                                                           offStatus  = "danger",
                                                           value      = FALSE,
                                                           labelWidth = "80px",
                                                           width      = "auto"
                                                       )
                                                )
                                            ),
                                            fluidRow(
                                                plotlyOutput(outputId = "dl_forecast_plot")
                                            )
                                        )
                               ),
                               tabPanel(title = "3. Forecast table",
                                        wellPanel(
                                            style = "background: white",
                                            fluidRow(
                                                reactableOutput(outputId = "dl_table_forecast")
                                            ),
                                            fluidRow(
                                                downloadButton(outputId = "dl_download_forecast",
                                                               label    = "Download DL Forecasted Values (.csv)",
                                                               class    = "download_button"
                                                )
                                            )
                                        )
                               )
                        )
                    )
                )
        )
    )
)


## 5. Footer ----
footer <-  dashboardFooter(
    left = div(img(src="ey-wavespace-logo-png-transparent-png_small.png")
           ),
    right = "2021"
)

# UI ----
ui <- dashboardPage(header, sidebar, body, controlbar, footer)

# SERVER ----
server <- function(session, input, output) { 
    #____________________________________----
    #4.2 app_load TAB ----
    
    ##Reading dataset (main_data())----
    main_data <- reactive({
        req(input$file_main)
        if(is.error(expr = read_data(input$file_main))){
            sendSweetAlert(session = session,
                           title      = "Oops",
                           btn_labels = "OK",
                           text       = HTML("The delimiter of your .csv file is not permitted, permitted delimiters are: , and ;<br>Please submit a file with the appropriate format."),
                           type       = "error",
                           html       = TRUE,
                           showCloseButton = TRUE)
        }else{
            read_data(input$file_main)
        }
    })
    
    ##Date variable (date_var)----
    output$date_dropdown <- renderUI({
        selectInput(inputId   = "date_var",
                    label     = "Select the date/time variable:",
                    selected  = colnames(main_data())[1],
                    choices   = colnames(main_data()),
                    selectize = TRUE
        )
    })
    
    ##Value variable (value_var)----
    output$value_dropdown <- renderUI({
        selectInput(inputId   = "value_var",
                    label     = "Select the variable to be forecasted:",
                    selected  = colnames(main_data())[2],
                    choices   = colnames(main_data()),
                    selectize = TRUE
        )
    })
    
    ##ID variable (id_var)----
    output$id_dropdown <- renderUI({
        if(input$id_checkbox == 0){
            return(NULL)
        }
        
        else if(input$id_checkbox == 1){
            list(
                selectInput(
                    inputId   = "id_var",
                    label     = "Select the ID variable:",
                    choices   = colnames(main_data()),
                    selectize = TRUE
                )
            )
        }
    })
    
    ##Missing data (text_missing)----
    output$text_missing <- renderPrint({
        req(vars_data())
        statsNA(rv$data$Value)
    })
    
    ##Data Overview (table_original) ----
    output$table_original <-  renderReactable({
        req(main_data())
        rect_data <- reactable(main_data(),
                               defaultPageSize     = 5,
                               pageSizeOptions     = c(5, 10, 20, 50),
                               showPageSizeOptions = TRUE,
                               minRows             = 1,
                               sortable            = TRUE,
                               highlight           = TRUE,
                               defaultColDef       = colDef(
                                   footer = function(values, name) htmltools::div(name, style = list(fontWeight = 600))
                               )
        )
        return(rect_data)
    })
    
    ##Data Summary (text_summary)----
    output$text_summary <- renderPrint({
        req(main_data())
        summary(main_data())
    })
    
    output$text_str <- renderPrint({
        req(main_data())
        str(main_data())
    })
    
    ##Date frequency (text_frequency) ----
    output$text_frequency <- renderPrint({
        req(vars_data())
        rv$ts_scale
    })
    
    ##Modified data (vars_data()) ----
    vars_data <- eventReactive(input$explore,{
        req(main_data())
        if (is.error(select_data(data = main_data(), input = input))
            ){sendSweetAlert(session = session,
                             title      = "Oops",
                             btn_labels = "OK",
                             text       = HTML("The date variable you have selected is not in a date format.<br>Please select a valid date for forecasting."),
                             type       = "error",
                             html       = TRUE,
                             showCloseButton = TRUE)
        }else{
            df <- select_data(data = main_data(), input = input)
            
            return(df)
        }
    })
    
    ##Data RV ----
    rv <- reactiveValues()
    
    observeEvent(eventExpr = input$explore, {
        req(vars_data())
        ### Data+VARS----
        rv$data       <- vars_data()
        rv$date_name  <- colnames(vars_data())[1]

        rv$value_name <- colnames(vars_data())[2]
        
        rv$ts_summary_tbl <- rv$data %>%
            # group_by(!! rv$group_name_expr) %>%
            tk_summary_diagnostics()

        rv$ts_scale <- rv$ts_summary_tbl$scale[[1]]

        print(rv$ts_scale)

        rv$median_nobs <- rv$ts_summary_tbl %>%
            pull(n.obs) %>%
            median()

        rv$lag_limit <- rv$median_nobs %>%
            `*`(0.4) %>%
            round()

        rv$horizon_recommended <- round(0.18 * rv$median_nobs)
        
    }, ignoreNULL = FALSE)
    
    ##Modelling RV----
    
    observeEvent(eventExpr = input$explore, {
        # ARIMA tibbles
        rv$arima_data_prepared_tbl       <- NULL
        rv$arima_future_tbl              <- NULL
        
        rv$arima_calibration_tbl         <- NULL
        rv$arima_accuracy_tbl            <- NULL
        rv$arima_forecast_tbl            <- NULL
        
        rv$arima_refit_tbl               <- NULL
        rv$arima_future_forecast_tbl     <- NULL
        
        # ML tibbles (for the outputs)
        rv$ml_accuracy_tbl               <- NULL
        rv$ml_forecast_tbl               <- NULL
        rv$ml_future_forecast_tbl        <- NULL
        
        #Submodels tibbles
        rv$ml_data_prepared_tbl          <- NULL
        rv$ml_future_tbl                 <- NULL
        
        rv$submodels_calibration_tbl     <- NULL
        rv$submodels_accuracy_tbl        <- NULL
        rv$submodels_forecast_tbl        <- NULL
        
        rv$submodels_refit_tbl           <- NULL
        rv$submodels_future_forecast_tbl <- NULL
        
        # Ensemble tibbles
        rv$ensemble_data_prepared_tbl    <- NULL
        rv$ensemble_future_tbl           <- NULL
        
        rv$ensemble_calib_tbl            <- NULL
        rv$ensemble_accuracy_tbl         <- NULL
        rv$ensemble_forecast_tbl         <- NULL
        
        rv$ensemble_refit_tbl            <- NULL
        rv$ensemble_future_forecast_tbl  <- NULL
        
        # AutoML tibbles
        rv$automl_data_prepared_tbl      <- NULL
        rv$automl_future_tbl             <- NULL
        
        rv$automl_calib_tbl              <- NULL
        rv$automl_accuracy_tbl           <- NULL
        rv$automl_forecast_tbl           <- NULL
          
        rv$automl_refit_tbl              <- NULL
        rv$automl_future_forecast_tbl    <- NULL
        
        #Deep Learning tibbles
        rv$dl_data_prepared_tbl          <- NULL
        rv$dl_future_tbl                 <- NULL
        
        rv$dl_calibration_tbl            <- NULL
        rv$dl_accuracy_tbl               <- NULL
        rv$dl_forecast_tbl               <- NULL
        
        rv$dl_refit_tbl                  <- NULL
        rv$dl_future_forecast_tbl        <- NULL
        
        
    },ignoreNULL = FALSE)
    
    ## Recommended horizon (horizon_recommended) ----
    output$auto_arima_horizon_recommended <- output$manual_arima_horizon_recommended <- output$ml_horizon_recommended <- output$ensemble_horizon_recommended <- output$auto_horizon_recommended <- output$dl_horizon_recommended <- renderText(
        paste("We recommend forecasting at least", {rv$horizon_recommended}, "periods for a better performance.")
    )
    
    #____________________________________----
    #4.3 app_exploration TAB ----
    
    ##Summary table (ts_summary)----
    output$ts_summary <- renderReactable({
        req(vars_data())
        data <- vars_data() %>% tk_summary_diagnostics(.date_var = Date) %>% select(1:5)
        rect_data <- reactable(data      = data,
                               highlight = TRUE,
                               columns = list(
                                   n.obs = colDef(align  = "left",
                                                  name   = "Nº observations"),
                                   start = colDef(format = colFormat(date = TRUE),
                                                  name   = "Start"),
                                   end   = colDef(format = colFormat(date = TRUE),
                                                  name   = "End"),
                                   units = colDef(name   = "Units"),
                                   scale = colDef(name   = "Frequency")
                               )
        )

        return(rect_data)
    })
    
    ##Data table (table_ts)----
    output$table_ts <-  renderReactable({
        req(vars_data())
        rect_data <- reactable(vars_data(),
                               columns = list(
                                   Date = colDef(format = colFormat(date = TRUE),
                                                 align  = "left"),
                                   Value = colDef(format = colFormat(digits     = 2,
                                                                     separators = TRUE), 
                                                  align  = "left")
                               ),
                               defaultPageSize     = 10,
                               pageSizeOptions     = c(5, 10, 20, 50),
                               showPageSizeOptions = TRUE,
                               minRows             = 1,
                               searchable          = TRUE,
                               sortable            = TRUE,
                               highlight           = TRUE,
                               defaultColDef = colDef(
                                   footer = function(values, name) htmltools::div(name, style = list(fontWeight = 600))
                               )
        )
        return(rect_data)
    })
    
    
    ##Plot Time Series (ts_plot)----
    output$ts_plot <- renderPlotly({
        req(vars_data())
        df <- vars_data()
        # Log Transformation
        if (input$ts_plot_log_trans) {
            df <- df %>%
                mutate(Value := log1p(Value))
        }
        
        g  <- df %>%
            plot_time_series(
                .date_var     = Date,
                .value        = Value,
                .smooth       = input$ts_plot_smooth,
                .smooth_span  = input$ts_plot_smooth_span,
                .smooth_color = "deeppink3",
                .smooth_size  = 0.5,
                .title        = FALSE,
                .interactive  = FALSE) +
            geom_line(color = "cornflowerblue") +
            scale_y_continuous(labels = scales::comma_format())
        
        ggplotly(g, dynamicTicks = TRUE) %>% 
            plotly::layout(
                xaxis = list(
                    rangeselector = list(
                            buttons = list(
                                list(
                                    count    = 1 * count_rangeselector(freq = rv$ts_scale),
                                    label    = "1",
                                    step     = rv$ts_scale,
                                    stepmode = "backward"),
                                list(
                                    count    = 3 * count_rangeselector(freq = rv$ts_scale),
                                    label    = "3",
                                    step     = rv$ts_scale,
                                    stepmode = "backward"),
                                list(
                                    count    = 6 * count_rangeselector(freq = rv$ts_scale),
                                    label    = "6",
                                    step     = rv$ts_scale,
                                    stepmode = "backward"),
                                list(
                                    count = 12 * count_rangeselector(freq = rv$ts_scale),
                                    label = "12",
                                    step  = rv$ts_scale,
                                    stepmode = "backward"),
                                list(
                                    count = 1,
                                    label = "YTD",
                                    step  = "year",
                                    stepmode = "todate"),
                                list(
                                    step = "all"
                                )
                            ),
                            font = list(
                                family = "Arial",
                                color  = "#2E2E38"
                            ),
                            bgcolor     = "#f6f6fa",
                            activecolor = "#FFE600",
                            bordercolor = "#FFE600",
                            borderwidth = 1
                    ),
                    rangeslider = list(
                        type = "date"
                    )
                )
            )
        })

    ##Plot ACF/PACF (ts_ACF)----
    output$ts_ACF <- renderPlotly({
        req(vars_data())
        g <-   plot_acf(
                  .data                  = vars_data(),
                  .date_var              = Date,
                  .value                 = Value,
                  .show_white_noise_bars = TRUE,
                  .point_color           = "darkslateblue",
                  .title                 = FALSE,
                  .interactive           = FALSE,
                  .feature_set           = "acf") +
            geom_line(color = "cornflowerblue")
        
        ggplotly(g, dynamicTicks = TRUE) %>%
            rangeslider()

    })
    
    output$ts_PACF <- renderPlotly({
        req(vars_data())
        g <-   plot_acf(
            .data                  = vars_data(),
            .date_var              = Date,
            .value                 = Value,
            .show_white_noise_bars = TRUE,
            .point_color           = "darkslateblue",
            .title                 = FALSE,
            .interactive           = FALSE,
            .feature_set           = "pacf") +
            geom_line(color = "cornflowerblue")
        
        ggplotly(g, dynamicTicks = TRUE) %>%
            rangeslider()
            
            # plotly::layout(
            #     xaxis = list(
            #         rangeslider = list(autorange = TRUE)
            #     )
            # )
        
    })
    
    ##Plot stl diagnostics 3x(ts_stl)----
    output$ts_season <- renderPlotly({
        req(vars_data())
        result <- tryCatch(
            expr = {
                g <- plot_stl_diagnostics(
                    .data        = vars_data(),
                    .date_var    = Date,
                    .message     = FALSE,
                    .value       = Value,
                    .feature_set = c("season"),
                    .title       = FALSE,
                    .interactive = FALSE) +
                    geom_line(color = "cornflowerblue")
                return(ggplotly(g, dynamicTicks = TRUE))
                
            }, warning = function(cond){
                sendSweetAlert(session         = session,
                               title           = "Oops",
                               btn_labels      = "OK",
                               text            = HTML("This feature is not available for time series with missing values."),
                               type            = "error",
                               html            = TRUE,
                               showCloseButton = TRUE)
                
            }, error = function(cond){
                sendSweetAlert(session         = session,
                               title           = "Oops",
                               btn_labels      = "OK",
                               text            = HTML("This feature is not available for time series with missing values."),
                               type            = "error",
                               html            = TRUE,
                               showCloseButton = TRUE)
            }
        )
    })
         
    output$ts_trend <- renderPlotly({
        req(vars_data())
        result <- tryCatch(
            expr = {
                g <- plot_stl_diagnostics(
                    .data        = vars_data(),
                    .date_var    = Date,
                    .value       = Value,
                    .message     = FALSE,
                    .feature_set = c("trend"),
                    .title       = FALSE,
                    .interactive = FALSE) +
                    geom_line(color = "cornflowerblue")
                return(ggplotly(g, dynamicTicks = TRUE))
                
            }, warning = function(cond){
            }, error   = function(cond){
            }
        )
    })
    
    output$ts_remainder <- renderPlotly({
        req(vars_data())
        result <- tryCatch(
            expr = {
                g <- plot_stl_diagnostics(
                    .data        = vars_data(),
                    .date_var    = Date,
                    .value       = Value,
                    .message     = FALSE,
                    .feature_set = c("remainder"),
                    .title       = FALSE,
                    .interactive = FALSE) +
                    geom_line(color = "cornflowerblue") +
                    scale_y_continuous(labels = scales::comma_format())
                return(ggplotly(g, dynamicTicks = TRUE))
                
            }, warning = function(cond){
            }, error = function(cond){
            }
        )
    })
    
    ##Plot seasonalities (ts_seasonality)----
    output$ts_seasonality <- renderUI({
        req(vars_data())
        g <- plot_seasonal_diagnostics(.data               = vars_data(),
                                       .date_var           = Date,
                                       .value              = Value,
                                       .feature_set        = "auto")
        
        seasonal_panel = function(m){renderPlotly({m})}
        lapply(1:length(g$x$layout$annotations), function(i){
            seasonal_panel(
                ggplotly(plot_seasonal_diagnostics(.data               = vars_data(),
                                                   .date_var           = Date,
                                                   .value              = Value,
                                                   .feature_set        = g$x$layout$annotations[[i]]$text,
                                                   .geom_color         = "steelblue4",
                                                   .geom_outlier_color = "deeppink3",
                                                   .title              = FALSE,
                                                   .interactive        = FALSE
                        ) + scale_y_continuous(labels = scales::comma_format())

                )
            )
        })
    })

    ##Plot anomalies (ts_anomaly)----
    output$ts_anomaly <- renderPlotly({
        req(vars_data())
        result <- tryCatch(
            expr = {
                g <- plot_anomaly_diagnostics(
                    .data        = vars_data(),
                    .date_var    = Date,
                    .value       = Value,
                    .anom_color  = "deeppink3",
                    .title       = FALSE,
                    .legend_show = FALSE,
                    .interactive = FALSE) +
                geom_line(color = "cornflowerblue") +
                scale_y_continuous(labels = scales::comma_format())
                return(ggplotly(g, dynamicTicks = TRUE))
            
        }, warning = function(cond){
            sendSweetAlert(session         = session,
                           title           = "Oops",
                           btn_labels      = "OK",
                           text            = HTML("This feature is not available for time series with missing values."),
                           type            = "error",
                           html            = TRUE,
                           showCloseButton = TRUE)
        }, error = function(cond){
            sendSweetAlert(session         = session,
                           title           = "Oops",
                           btn_labels      = "OK",
                           text            = HTML("This feature is not available for time series with missing values."),
                           type            = "error",
                           html            = TRUE,
                           showCloseButton = TRUE)
        })
    })
    #____________________________________----
    #4.4.2 arima_model TAB ----
    
    output$arima_horizon <- renderUI({
        shinyWidgets::numericInputIcon(
            inputId = "arima_horizon",
            value   = rv$horizon_recommended,
            min     = 1,
            label   = "Enter a Forecast Horizon",
            icon    = icon("chart-line")
        )
    })
    
    output$arima_manual_horizon <- renderUI({
        shinyWidgets::numericInputIcon(
            inputId = "arima_manual_horizon",
            value   = rv$horizon_recommended,
            min     = 1,
            label   = "Enter a Forecast Horizon",
            icon    = icon("chart-line")
        )
    })
    
    ## TO DO Split slider (train_test)----
    # output$train_test <- renderUI({
    #     sliderInput2(
    #         inputId  = "train_test",
    #         label    = "Train/Test split",
    #         value    = 80,
    #         min      = 0,
    #         max      = 100,
    #         step     = 5,
    #         from_min = 50,
    #         from_max = 95
    #     )
    # })   
    # 
    # observeEvent(input$train_test, {
    #     shinyWidgets::updateProgressBar(session = session,
    #                                     id = "progress_train_test",
    #                                     value = input$train_test
    #     )
    # })
    
    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    ## AUTO ARIMA ----
    
    ###arima_boost inputs----
    output$arima_boost <- renderUI({
        if(input$arima_boost_checkbox == 0){
            return(NULL)
        }
        
        else if(input$arima_boost_checkbox == 1){
            list(
                numericInput(inputId = "tree_depth",
                             label   = "Maximum depth of the tree (number of splits)",
                             min     = 1,
                             max     = 10000,
                             step    = 1,
                             value   = 6
                ),
                numericInput(inputId = "trees",
                             label   = "Number of trees in the ensemble",
                             min     = 1,
                             max     = 10000,
                             value   = 15,
                             step    = 1
                ),
                numericInput(inputId = "learn_rate",
                             label   = "Learning rate of the boosting algorithm",
                             min     = 0,
                             max     = 1,
                             value   = 0.3,
                             step    = 0.01
                ),
                numericInput(inputId = "mtry",
                             label   = "Number of predictors sampled at each split",
                             min     = 0,
                             max     = 1,
                             value   = 1,
                             step    = 0.01
                ),
                numericInput(inputId = "min_n",
                             label   = "Minimum number of points for the node to split",
                             min     = 1,
                             max     = 100000,
                             value   = 1,
                             step    = 1
                ),
                numericInput(inputId = "loss_reduction",
                             label   = "Reduction in loss function to split further",
                             min     = 0,
                             max     = 10000,
                             value   = 0
                )
            )
        }
    })
    
    observeEvent(input$run_auto, {
        req(vars_data())
        
        print("Auto ARIMA modelling in progress")
        
        ### Progress bar ----
        progress <- shiny::Progress$new()
        on.exit(progress$close())
        progress$set(message = "ARIMA modelling in progress", value = 0)
        
        ### Text dialog ----
        showModal(
            modalDialog(
                title = "ARIMA modelling  in progress",
                "Training the ARIMA model. This will take a few moments, feel free to explore the time series in the meantime.",
                footer = modalButton("Dismiss"),
                easyClose = TRUE,
                fade = TRUE
            )
        )
        
        req(input$arima_horizon)
        
        ###Transformations ----
        rv$trans_fun     <- log1p
        rv$trans_fun_inv <- expm1
        
        ###DATA ENGINEERING ----
        
        #** Extend forecast window ----
        full_data_tbl <- rv$data %>%
            
            # Remove missing values
            drop_na() %>%
            
            # Apply transformation
            mutate(Value = ifelse(Value < 0, 0, Value)) %>%
            mutate(Value = rv$trans_fun(Value)) %>%
            
            future_frame(
                .date_var   = Date,
                .length_out = input$arima_horizon,
                .bind_data  = TRUE
            ) %>%
            
            ungroup()
        
        print(full_data_tbl)
        
        # Data Prepared
        actual_data <- full_data_tbl %>%
            filter(!is.na(Value))
        
        rv$arima_data_prepared_tbl <- actual_data %>%
            drop_na()
        
        rv$arima_future_tbl <- full_data_tbl %>%
            filter(is.na(Value))
        
        # ** SPLITTING ----
        rv$splits <- rv$arima_data_prepared_tbl %>%
            time_series_split(
                date_var   = Date,
                assess     = input$arima_horizon,
                cumulative = TRUE
            )

        ### 1/7 Models ----
    
        progress$inc(1/6, detail = percent(1/6,accuracy = 0.01))
        ### 2/7 Modeltime Table----
        model_tbl_arima <- auto_arima_table(max_depth        = input$tree_depth,
                                            nrounds          = input$trees,
                                            eta              = input$learn_rate,
                                            colsample_bytree = input$mtry,
                                            min_child_weight = input$min_n,
                                            gamma            = input$loss_reduction,
                                            
                                            train_data       = training(rv$splits),
                                            input            = input
        )
        
        progress$inc(1/6, detail = percent(2/6,accuracy = 0.01))
        ### 3/7 Calibration----
        rv$arima_calibration_tbl <- model_tbl_arima %>%
            modeltime_calibrate(testing(rv$splits))
        
        progress$inc(1/6, detail = percent(3/6,accuracy = 0.01))
        ### 4/7 Accuracy----
        rv$arima_accuracy_tbl <- rv$arima_calibration_tbl %>%
            mutate(.calibration_data = map(.calibration_data, .f = function(tbl) {
                tbl %>%
                    mutate(
                        .actual     = rv$trans_fun_inv(.actual),
                        .prediction = rv$trans_fun_inv(.prediction),
                        .residuals  = .actual - .prediction
                    )
            })) %>%
            modeltime_accuracy()
        
        progress$inc(1/6, detail = percent(4/6,accuracy = 0.01))
        ### 5/7 Test Forecast----
        rv$arima_forecast_tbl <- rv$arima_calibration_tbl %>%
            modeltime_forecast(
                new_data    = testing(rv$splits),
                actual_data = rv$arima_data_prepared_tbl
            ) %>%
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        progress$inc(1/6, detail = percent(5/6,accuracy = 0.01))
        ### 6/7 Refitting to full dataset----
        rv$arima_refit_tbl <-  rv$arima_calibration_tbl %>% 
            modeltime_refit(data = rv$arima_data_prepared_tbl
            )
        
        progress$inc(1/6, detail = percent(6/6,accuracy = 0.01))
        ### 7/7 Forecast future horizon----
        rv$arima_future_forecast_tbl <- rv$arima_refit_tbl %>%
            modeltime_forecast(
                new_data    = rv$arima_future_tbl,
                actual_data = rv$arima_data_prepared_tbl,
                keep_data   = TRUE
            ) %>%
            #Inverting transformation
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        removeModal()
        
        message("\n ARIMA Modelling Done!")
        
    }, ignoreNULL = TRUE)
    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    
    ##MANUAL ARIMA ----
    ###sarima inputs ----
    output$sarima <- renderUI({
        if(input$sarima_checkbox == 0){
            return(NULL)
        }
        
        else if(input$sarima_checkbox == 1){
            list(
                numericInput(inputId = "s",
                             label   = "Seasonality period (1<M>350)",
                             min     = 1,
                             max     = 350,
                             value   = 1

                ),
                numericInput(inputId = "sar",
                             label   = "Seasonal AR order (P)",
                             min     = 0,
                             max     = 5,
                             value   = 0
                ),
                numericInput(inputId = "si",
                             label   = "Seasonal differencing degree (D)",
                             min     = 0,
                             max     = 5,
                             value   = 0
                ),
                numericInput(inputId = "sma",
                             label   = "Seasonal MA order (Q)",
                             min     = 0,
                             max     = 5,
                             value   = 0
                )
            )
        }
    })
    
    
    observeEvent(input$run_manual, {
        
        req(input$arima_horizon)
        
        print("Manual ARIMA modelling in progress")
        
        ### Progress bar ----
        progress <- shiny::Progress$new()
        on.exit(progress$close())
        progress$set(message = "ARIMA modelling in progress", value = 0)
        
        ### Text dialog ----
        showModal(
            modalDialog(
                title = "ARIMA modelling  in progress",
                "Training the ARIMA model. This will take a few moments, feel free to explore the time series in the meantime.",
                footer = modalButton("Dismiss"),
                easyClose = TRUE,
                fade = TRUE
            )
        )
        
        ### Model Parameters ----
        rv$p <- input$ar
        rv$q <- input$ma
        rv$d <- input$i
        
        rv$s <- input$s
        
        rv$P <- input$sar
        rv$Q <- input$sma
        rv$D <- input$si
        
        ### Transformations ----
        rv$trans_fun     <- log1p
        rv$trans_fun_inv <- expm1
        
        ###DATA ENGINEERING ----
        
        #** EXTENDING forecast window ----
        full_data_tbl <- rv$data %>%
            
            # Remove missing values
            drop_na() %>%
            
            # Apply transformation
            mutate(Value = ifelse(Value < 0, 0, Value)) %>%
            mutate(Value = rv$trans_fun(Value)) %>%
            
            future_frame(
                .date_var   = Date,
                .length_out = input$arima_horizon,
                .bind_data  = TRUE
            ) %>%
            
            ungroup()
        
        print(full_data_tbl)

        # Data Prepared
        actual_data <- full_data_tbl %>%
            filter(!is.na(Value))
        
        rv$arima_data_prepared_tbl <- actual_data %>%
            drop_na()
        
        rv$arima_future_tbl <- full_data_tbl %>%
            filter(is.na(Value))
        
        # ** SPLITTING ----
        rv$splits <- rv$arima_data_prepared_tbl %>%
            time_series_split(
                date_var   = Date,
                assess     = input$arima_horizon,
                cumulative = TRUE
            )
        
        progress$inc(1/7, detail = percent(1/7,accuracy = 0.01))
        ### 1/7 Model ----
        model_fit_arima <- arima_manual(p          = rv$p,
                                        q          = rv$q,
                                        d          = rv$d,
                                        s          = rv$s,
                                        P          = rv$P,
                                        Q          = rv$Q,
                                        D          = rv$D,

                                        train_data = training(rv$splits),
                                        input      = input
        )
        
        print("manual model ok")
        
        ###2/7 Modeltime Table----
        progress$inc(1/7, detail = percent(2/7,accuracy = 0.01))
        
        model_tbl_arima <- modeltime_table(
            model_fit_arima
        )
        
        ### 3/7 Calibration----
        progress$inc(1/7, detail = percent(3/7,accuracy = 0.01))
        
        rv$arima_calibration_tbl <- model_tbl_arima %>%
            modeltime_calibrate(testing(rv$splits))
        
        ### 4/7 Accuracy----
        progress$inc(1/7, detail = percent(4/7,accuracy = 0.01))
        
        rv$arima_accuracy_tbl <- rv$arima_calibration_tbl %>%
            mutate(.calibration_data = map(.calibration_data, .f = function(tbl) {
                tbl %>%
                    mutate(
                        .actual     = rv$trans_fun_inv(.actual),
                        .prediction = rv$trans_fun_inv(.prediction),
                        .residuals  = .actual - .prediction
                    )
            })) %>%
            modeltime_accuracy()
        
        ### 5/7 Test Forecast----
        progress$inc(1/7, detail = percent(5/7,accuracy = 0.01))
        
        rv$arima_forecast_tbl <- rv$arima_calibration_tbl %>%
            modeltime_forecast(
                new_data    = testing(rv$splits),
                actual_data = rv$arima_data_prepared_tbl
            )%>%
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        ###6/7 Refitting to full dataset----
        progress$inc(1/7, detail = percent(6/7,accuracy = 0.01))
        
        rv$arima_refit_tbl <-  rv$arima_calibration_tbl %>% 
            modeltime_refit(data = rv$arima_data_prepared_tbl
            )
        
        ### 7/7 Forecast future horizon----
        progress$inc(1/7, detail = percent(7/7,accuracy = 0.01))
        
        rv$arima_future_forecast_tbl <- rv$arima_refit_tbl %>%
            modeltime_forecast(
                new_data    = rv$arima_future_tbl,
                actual_data = rv$arima_data_prepared_tbl,
                keep_data   = TRUE
            ) %>%
            #Inverting transformation
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        removeModal()
        
        message("\nModelling Done!")
        
    })
    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    ## Plot (arima_test_plot)----
    output$arima_test_plot <- renderPlotly({
        req(rv$arima_forecast_tbl)
        
        df <- rv$arima_forecast_tbl
        
        g <- df %>%
            plot_modeltime_forecast(
                .conf_interval_alpha = 0.2,
                .legend_show         = TRUE,
                .title               = NULL,
                .legend_max_width    = 25,
                .interactive         = FALSE
            )
        
        ggplotly(g, dynamicTicks = TRUE) %>%
            rangeslider()
    })
    
    ## Accuracy Table (arima_table_accuracy)----
    output$arima_table_accuracy <- renderReactable({
        req(rv$arima_accuracy_tbl)
        
        rect_data <- rv$arima_accuracy_tbl %>% 
            table_modeltime_accuracy(
                .searchable    = FALSE,
                .show_sortable = FALSE
        )
        return(rect_data)
    })
    
    ## Plot (arima_forecast_plot)----
    output$arima_forecast_plot <- renderPlotly({
        req(rv$arima_future_forecast_tbl)
        
        df <- rv$arima_future_forecast_tbl
        
        g <- df %>% 
            plot_modeltime_forecast(
                .conf_interval_alpha = 0.1,
                .conf_interval_show  = input$arima_forecast_plot_conf,
                .legend_show         = input$arima_forecast_plot_legend,
                .title               = NULL,
                .interactive         = FALSE
            )+
            scale_y_continuous(labels = scales::comma_format())
        
        ggplotly(g, dynamicTicks = TRUE) %>%
            rangeslider()
    })
    
    ## Forecast table (arima_table_forecast)----
    output$arima_table_forecast <- renderReactable({
        req(rv$arima_future_forecast_tbl)
        data <- rv$arima_future_forecast_tbl %>% 
            filter(.key =="prediction") %>% 
            select(-c(Value, .index))
        
        rect_data <- reactable(data,
                               defaultPageSize     = 5,
                               pageSizeOptions     = c(5, 10, 20),
                               groupBy             = ".model_desc",
                               showPageSizeOptions = TRUE,
                               minRows             = 1,
                               sortable            = TRUE,
                               highlight           = TRUE,
                               defaultColDef       = colDef(
                                   footer = function(values, name) htmltools::div(name, style = list(fontWeight = 600))
                               )
       )
    })
    
    ## Forecast table downloader (arima_download_forecast)----
    output$arima_download_forecast <- downloadHandler(
        filename = function() {
            paste({input$arima_horizon},"_arima_forecast_",{file_path_sans_ext(input$file_main)}, ".csv", sep = "")
        },
        
        content = function(file) {
            req(rv$arima_future_forecast_tbl)
            data <- rv$arima_future_forecast_tbl %>% 
                filter(.key =="prediction") %>% 
                select(-c(Value, .index))
            
            write.csv(data, file, row.names = FALSE)
        }
    )
    
    #____________________________________----
    #4.5.2 ml_model TAB ----
    
    output$ml_horizon <- output$ensemble_horizon <- output$auto_horizon <- renderUI({
        shinyWidgets::numericInputIcon(
            inputId = "ml_horizon",
            value   = rv$horizon_recommended,
            min     = 1,
            label   = "Enter a Forecast Horizon",
            icon    = icon("chart-line")
        )
    })
    
    ## .1 ML_models ----
    observeEvent(input$run_ml, {

        req(input$ml_horizon)
        req(input$ml_model_selection)
        req(rv$data)
        
        print("Machine Learning modelling in progress")
        
        ## Progress bar ----
        progress <- shiny::Progress$new()
        on.exit(progress$close())
        progress$set(message = "Machine Learning modelling in progress", value = 0)
        
        #Text dialog ----
        showModal(
            modalDialog(
                title = "Machine Learning modelling  in progress",
                "Training the chosen Machine Learning models. This will take a few moments, feel free to explore the time series in the meantime.",
                footer = modalButton("Dismiss"),
                easyClose = TRUE,
                fade = TRUE
            )
        )
        
        #EXTENDING data ----
        rv$trans_fun     <- log1p
        rv$trans_fun_inv <- expm1
        
        full_data_tbl <- rv$data %>%

            # Remove missing values
            na.omit() %>%
            
            # Apply transformation
            mutate(Value = ifelse(Value < 0, 0, Value)) %>%
            mutate(Value = rv$trans_fun(Value)) %>% 

            future_frame(
                .date_var   = Date,
                .length_out = input$ml_horizon,
                .bind_data  = TRUE
            )
        
        # Data Prepared
        actual_data <- full_data_tbl %>%
            filter(!is.na(Value))
        
        rv$ml_data_prepared_tbl <- actual_data %>%
            drop_na()
        
        rv$ml_future_tbl <- full_data_tbl %>%
            filter(is.na(Value))
        
        # SPLITTING data----
        rv$splits <- rv$ml_data_prepared_tbl %>%
            time_series_split(
                date_var   = Date,
                assess     = input$ml_horizon,
                cumulative = TRUE
            )
        
        # PREPROCESSOR ----
        
        form          <- formula(str_c(rv$value_name, " ~ ."))
        date_var_text <- rv$date_name
        
        # For Date
        rv$recipe_spec_1 <- recipe(formula = form,
                                   data    = training(rv$splits)) %>%
            step_timeseries_signature(all_of(date_var_text)) %>%
            step_rm(matches("(.iso$)|(.xts$)|(day)|(hour)|(minute)|(second)|(am.pm)")) %>%
            step_normalize(matches("(_index.num$)|(_year$)")) %>%
            step_mutate(Date_week = factor(Date_week, ordered = TRUE)) %>% 
            step_dummy(all_nominal(), one_hot = TRUE)
        
        rv$recipe_spec_1 %>% prep() %>% juice()
        
        rv$recipe_spec_2 <- rv$recipe_spec_1 %>%
            update_role(all_of(date_var_text), new_role = "ID")
        
        rv$recipe_spec_2 %>% prep() %>% juice() 
    
        
        #1/7 Models----
        progress$inc(1/7, detail = percent(1/7,accuracy = 0.01))
        
        spec_table <- ml_models(input    = input$ml_model_selection,
                                recipe_1 = rv$recipe_spec_1,
                                recipe_2 = rv$recipe_spec_2)
        ### SAFE FITTING ----
        message("Fitting Sub-Models")
        
        fitted_wflw_list <- map(spec_table$wflw_spec, .f = function(wflw) {
            res <- wflw %>% fit(training(rv$splits))
            return(res)
        })
        
        spec_fit_tbl <- spec_table %>%
            mutate(wflw_fit = fitted_wflw_list)
        
        print(spec_fit_tbl)
        
        ##2/7 Modeltime Table----
        progress$inc(1/7, detail = percent(2/7,accuracy = 0.01))
        
        rv$submodels_tbl <- as_modeltime_table(spec_fit_tbl$wflw_fit)
        
        # 3/7 Calibration----
        progress$inc(1/7, detail = percent(3/7,accuracy = 0.01))
        
        rv$submodels_calibration_tbl <- rv$submodels_tbl %>%
            modeltime_calibrate(new_data = testing(rv$splits))
        
        # 4/7 Accuracy----
        progress$inc(1/7, detail = percent(4/7,accuracy = 0.01))
        
        rv$submodels_accuracy_tbl <- rv$submodels_calibration_tbl %>%
            mutate(.calibration_data = map(.calibration_data, .f = function(tbl) {
                tbl %>%
                    mutate(
                        .actual     = rv$trans_fun_inv(.actual),
                        .prediction = rv$trans_fun_inv(.prediction),
                        .residuals  = .actual - .prediction
                    )
            })) %>%
            modeltime_accuracy()

        # 5/7 Test Forecast----
        progress$inc(1/7, detail = percent(5/7,accuracy = 0.01))
        
        rv$submodels_forecast_tbl <- rv$submodels_calibration_tbl %>%
            modeltime_forecast(
                new_data    = testing(rv$splits),
                actual_data = rv$ml_data_prepared_tbl
            )%>%
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            ) 
        
        #6/7 Refitting to full dataset----
        progress$inc(1/7, detail = percent(6/7,accuracy = 0.01))
        
        rv$submodels_refit_tbl <-  rv$submodels_calibration_tbl %>% 
            modeltime_refit(data = rv$ml_data_prepared_tbl
            )
        
        
        # 7/7 Forecast future horizon----
        progress$inc(1/7, detail = percent(7/7,accuracy = 0.01))
        
        rv$submodels_future_forecast_tbl <- rv$submodels_refit_tbl %>%
            modeltime_forecast(
                new_data    = rv$ml_future_tbl,
                actual_data = rv$ml_data_prepared_tbl,
                keep_data   = TRUE
            ) %>%
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        removeModal()
        
        message("\nML modelling Done!")
        
        rv$ml_forecast_tbl        <- rv$submodels_forecast_tbl
        rv$ml_accuracy_tbl        <- rv$submodels_accuracy_tbl
        rv$ml_future_forecast_tbl <- rv$submodels_future_forecast_tbl
        
    })
    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    ##.2 Ensemble models ----
    
    # output$ensemble_horizon <- renderUI({
    #     shinyWidgets::numericInputIcon(
    #         inputId = "ml_horizon",
    #         value   = rv$horizon_recommended,
    #         min     = 1,
    #         label   = "Enter a Forecast Horizon",
    #         icon    = icon("chart-line")
    #     )
    # })
    
    observeEvent(input$run_ensemble, {
        
        req(input$ml_horizon)
        req(rv$data)
        req(rv$submodels_calibration_tbl)
        
        print("Ensemble modelling in progress")
        
        ##Progress bar ----
        progress <- shiny::Progress$new()
        on.exit(progress$close())
        progress$set(message = "Ensemble modelling in progress", value = 0)
        
        #Text dialog ----
        showModal(
            modalDialog(
                title = "Machine Learning modelling  in progress",
                "Training the chosen ensemble models. This will take a few moments, feel free to explore the time series in the meantime.",
                footer = modalButton("Dismiss"),
                easyClose = TRUE,
                fade = TRUE
            )
        )
        
        #EXTENDING data ----
        rv$trans_fun     <- log1p
        rv$trans_fun_inv <- expm1
        
        full_data_tbl <- rv$data %>%
            
            # Remove missing values
            na.omit() %>%
            
            # Apply transformation
            mutate(Value = ifelse(Value < 0, 0, Value)) %>%
            mutate(Value = rv$trans_fun(Value)) %>% 
            
            future_frame(
                .date_var   = Date,
                .length_out = input$ml_horizon,
                .bind_data  = TRUE
            )
        
        # Data Prepared
        actual_data <- full_data_tbl %>%
            filter(!is.na(Value))
        
        rv$ensemble_data_prepared_tbl <- actual_data %>%
            drop_na()
        
        rv$ensemble_future_tbl <- full_data_tbl %>%
            filter(is.na(Value))
        
        # SPLITTING data----
        rv$splits <- rv$ml_data_prepared_tbl %>%
            time_series_split(
                date_var   = Date,
                assess     = input$ml_horizon,
                cumulative = TRUE
            )
        
        print(rv$submodels_calibration_tbl)
        print(input$ensemble_selection)

        # 1+2+3/7 Calibration ----
        progress$inc(1/5, detail = percent(1/5))
        
        rv$ensemble_calib_tbl <- if (nrow(rv$submodels_calibration_tbl) < 2){
            sendSweetAlert(session         = session,
                           title           = "Oops",
                           btn_labels      = "OK",
                           text            = HTML("You need to select at least two machine learning models in the previous step to train the ensemble model.<br>Please check your settings."),
                           type            = "error",
                           html            = TRUE,
                           showCloseButton = TRUE)
            removeModal()
        }else{
            ensemble_calibration(input           = input$ensemble_selection,
                                 calibration_tbl = rv$submodels_calibration_tbl,
                                 test_data       = testing(rv$splits)
            )
        }
        
        # tryCatch(
        #     expr = {
        #         calib <- ensemble_calibration(input           = input$ensemble_selection,
        #                                       calibration_tbl = rv$submodels_calibration_tbl,
        #                                       test_data       = testing(rv$splits)
        #                   )
        #         return(calib)
        #         
        #     }, warning = function(cond){
        #         sendSweetAlert(session = session,
        #                        title      = "Oops",
        #                        btn_labels = "OK",
        #                        text       = HTML("You need to select at least two machine learning models in the previous step to train the ensemble model.<br>Please check your settings."),
        #                        type       = "error",
        #                        html       = TRUE,
        #                        showCloseButton = TRUE)
        #         removeModal()
        #         
        #     }, error = function(cond){
        #         sendSweetAlert(session = session,
        #                        title      = "Oops",
        #                        btn_labels = "OK",
        #                        text       = HTML("You need to select at least two machine learning models in the previous step to train the ensemble model.<br>Please check your settings."),
        #                        type       = "error",
        #                        html       = TRUE,
        #                        showCloseButton = TRUE)
        #         removeModal()
        #     }
        # )
            
        # 4/7 Accuracy ----
        progress$inc(1/5, detail = percent(2/5))
        
        req(rv$ensemble_calib_tbl)
        
        rv$ensemble_accuracy_tbl <- rv$ensemble_calib_tbl %>% 
            mutate(.calibration_data = map(.calibration_data, .f = function(tbl) {
                tbl %>%
                    mutate(
                        .actual     = rv$trans_fun_inv(.actual),
                        .prediction = rv$trans_fun_inv(.prediction),
                        .residuals  = .actual - .prediction
                    )
            })) %>%
            modeltime_accuracy()
        
        #5/7 Test forecast ----
        progress$inc(1/5, detail = percent(3/5))
        
        rv$ensemble_forecast_tbl <- rv$ensemble_calib_tbl %>% 
            modeltime_forecast(new_data    = testing(rv$splits),
                               actual_data = rv$ensemble_data_prepared_tbl
            ) %>% 
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        #6/7 Refitting to full dataset----
        progress$inc(1/5, detail = percent(4/5))
       
        rv$ensemble_refit_tbl <- rv$ensemble_calib_tbl %>% 
            modeltime_refit(data = rv$ensemble_data_prepared_tbl
            )
        
        # 7/7 Forecast future horizon----
        progress$inc(1/5, detail = percent(5/5))
        
        rv$ensemble_future_forecast_tbl  <- rv$ensemble_refit_tbl %>% 
            modeltime_forecast(
                new_data    = rv$ensemble_future_tbl,
                actual_data = rv$ensemble_data_prepared_tbl,
                keep_data   = TRUE
            ) %>%
            mutate(
                across(.cols = c(.value, .conf_lo, .conf_hi),
                       .fns  = function(x) rv$trans_fun_inv(x))
            )
        
        removeModal()
        message("\nEnsemble Modelling Done!")
        
        rv$ml_forecast_tbl        <- rv$ensemble_forecast_tbl
        rv$ml_accuracy_tbl        <- rv$ensemble_accuracy_tbl
        rv$ml_future_forecast_tbl <- rv$ensemble_future_forecast_tbl
    })
    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    ##.3 AutoML ----
    # Requires Java versions8-11
    
    output$auto_nfolds <- renderUI({
        if(input$auto_nfolds_checkbox == 0){
            return(NULL)
        }
        
        else if(input$auto_nfolds_checkbox == 1){
            list(
                sliderInput2(
                    inputId  = "auto_nfolds",
                    label    = "Number of folds for k-fold cross-validation:",
                    min      = 0,
                    max      = 20,
                    value    = 5,
                    from_min = 2,
                    from_max = 20
                )
            )
        }
    })
    
    observeEvent(input$run_automl, {

        req(input$ml_horizon)
        req(rv$data)
        
        print("AutoML modelling in progress")
        
        ## Progress bar ----
        progress <- shiny::Progress$new()
        on.exit(progress$close())
        progress$set(message = "AutoML modelling in progress", value = 0)

        ##Text dialog ----
        showModal(
            modalDialog(
                title = "AutoML modelling  in progress",
                "Training Auto Machine Learning models. This will take a few moments, feel free to explore the time series in the meantime.",
                footer = modalButton("Dismiss"),
                easyClose = TRUE,
                fade = TRUE
            )
        )

        ##EXTENDING data ----
        full_data_tbl <- rv$data %>%

            # Remove missing values
            na.omit() %>%

            # Apply transformation
            mutate(Value = ifelse(Value < 0, 0, Value),
                   Date  = as_date(Date)) %>%

            future_frame(
                .date_var   = Date,
                .length_out = input$ml_horizon,
                .bind_data  = TRUE
            )

        # Data Prepared
        actual_data <- full_data_tbl %>%
            filter(!is.na(Value))

        rv$automl_data_prepared_tbl <- actual_data %>%
            drop_na()

        rv$automl_future_tbl <- full_data_tbl %>%
            filter(is.na(Value))

        ## SPLITTING data----
        rv$splits <- rv$automl_data_prepared_tbl %>%
            time_series_split(
                date_var   = Date,
                assess     = input$ml_horizon,
                cumulative = TRUE
            )

        ## PREPROCESSOR ----
        form          <- formula(str_c(rv$value_name, " ~ ."))
        date_var_text <- rv$date_name

        rv$recipe_spec_auto <- recipe(formula = form,
                                      data    = training(rv$splits)) %>%
            step_timeseries_signature(all_of(date_var_text)) %>%
            step_normalize(matches("(_index.num$)|(_year$)"))

        rv$recipe_spec_auto %>% prep() %>% juice()

        ## Model parameters ----
        rv$auto_time       <- input$auto_time
        rv$auto_model_time <- input$auto_model_time
        rv$auto_max_models <- input$auto_max_models
        rv$auto_nfolds     <- input$auto_nfolds

        ##0/7 Inititalize H2O ----
        progress$inc(1/8, detail = percent(1/8,accuracy = 0.01))

        h2o.init(
            nthreads = -1,
            ip       = 'localhost',
            port     = 54321
        )

        ##1/7 Models----
        progress$inc(1/8, detail = percent(2/8,accuracy = 0.01))

        model_spec_h2o <- automl_reg(mode = "regression") %>%
            set_engine(
                engine = "h2o",
                max_runtime_secs = rv$auto_time,
                max_runtime_secs_per_model = rv$auto_model_time,
                max_models = rv$auto_max_models,
                nfolds = rv$auto_nfolds,
                exclude_algos = c("DeepLearning"),
                verbosity = NULL
            )

        ####  FITTING ----
        message("Fitting AutoML model")

        wflw_fit_h2o <- workflow() %>%
            add_model(model_spec_h2o) %>%
            add_recipe(rv$recipe_spec_auto) %>%
            fit(training(rv$splits))

        ##2/7 Modeltime Table----
        progress$inc(1/8, detail = percent(3/8,accuracy = 0.01))

        rv$automl_tbl <- modeltime_table(wflw_fit_h2o)

        ## 3/7 Calibration----
        progress$inc(1/8, detail = percent(4/8,accuracy = 0.01))

        rv$automl_calibration_tbl <- rv$automl_tbl %>%
            modeltime_calibrate(new_data = testing(rv$splits))

        ## 4/7 Accuracy----
        progress$inc(1/8, detail = percent(5/8,accuracy = 0.01))

        rv$automl_accuracy_tbl <- rv$automl_calibration_tbl %>%
            modeltime_accuracy()

        ## 5/7 Test Forecast----
        progress$inc(1/8, detail = percent(6/8,accuracy = 0.01))

        rv$automl_forecast_tbl <- rv$automl_calibration_tbl %>%
            modeltime_forecast(
                new_data    = testing(rv$splits),
                actual_data = rv$automl_data_prepared_tbl
            )

        ##6/7 Refitting to full dataset----
        progress$inc(1/8, detail = percent(7/8,accuracy = 0.01))

        rv$automl_refit_tbl <-  rv$automl_calibration_tbl %>%
            modeltime_refit(data = rv$automl_data_prepared_tbl
            )


        ## 7/7 Forecast future horizon----
        progress$inc(1/8, detail = percent(8/8,accuracy = 0.01))

        rv$automl_future_forecast_tbl <- rv$automl_refit_tbl %>%
            modeltime_forecast(
                new_data    = rv$automl_future_tbl,
                actual_data = rv$automl_data_prepared_tbl,
                keep_data   = TRUE
            )

        removeModal()

        message("\nAutoML modelling Done!")

        rv$ml_forecast_tbl        <- rv$automl_forecast_tbl
        rv$ml_accuracy_tbl        <- rv$automl_accuracy_tbl
        rv$ml_future_forecast_tbl <- rv$automl_future_forecast_tbl
    })

    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    ## Plot (ml_test_plot)----
    output$ml_test_plot <- renderPlotly({
        req(rv$ml_forecast_tbl)
        
        df <- rv$ml_forecast_tbl
        
        g <- df %>%
            plot_modeltime_forecast(
                .conf_interval_alpha = 0.2,
                .legend_show         = TRUE,
                .title               = NULL,
                .legend_max_width    = 25,
                .interactive         = FALSE
            )
        
        ggplotly(g, dynamicTicks = TRUE) %>%
            rangeslider()
    })
    
    ## Accuracy Table (ml_table_accuracy) ----
    output$ml_table_accuracy <- renderReactable({
        req(rv$ml_accuracy_tbl)
        
        rect_data <- rv$ml_accuracy_tbl %>% 
            table_modeltime_accuracy(
                .searchable    = FALSE,
                .show_sortable = FALSE
            )
        return(rect_data)
    })
    
    ## Future Plot (ml_forecast_plot)----
    output$ml_forecast_plot <- renderPlotly({
        req(rv$ml_future_forecast_tbl)
        
        df <- rv$ml_future_forecast_tbl
        
        g <- df %>% 
            plot_modeltime_forecast(
                .conf_interval_alpha = 0.1,
                .conf_interval_show  = input$ml_forecast_plot_conf,
                .legend_show         = input$ml_forecast_plot_legend,
                .title               = NULL,
                .interactive         = FALSE
            )+
            scale_y_continuous(labels = scales::comma_format())
        
        ggplotly(g, dynamicTicks = TRUE) %>%
            rangeslider()
    })
    
    ## Forecast table (ml_table_forecast)----
    output$ml_table_forecast <- renderReactable({
        req(rv$ml_future_forecast_tbl)
        data <- rv$ml_future_forecast_tbl %>% 
            filter(.key =="prediction") %>% 
            select(-c(Value, .index))
        
        rect_data <- reactable(data,
                               defaultPageSize     = 5,
                               pageSizeOptions     = c(5, 10, 20),
                               groupBy             = ".model_desc",
                               showPageSizeOptions = TRUE,
                               minRows             = 1,
                               sortable            = TRUE,
                               highlight           = TRUE,
                               defaultColDef       = colDef(
                                   footer = function(values, name) htmltools::div(name, style = list(fontWeight = 600))
                               )
        )
    })
    
    ## Forecast table downloader (ml_download_forecast)----
    output$ml_download_forecast <- downloadHandler(
        filename = function() {
            paste({input$ml_horizon}, "_ml_forecast_", {file_path_sans_ext(input$file_main)}, ".csv", sep = "")
        },
        
        content = function(file) {
            req(rv$ml_future_forecast_tbl)
            data <- rv$ml_future_forecast_tbl %>% 
                filter(.key =="prediction") %>% 
                select(-c(Value, .index))
            
            write.csv(data, file, row.names = FALSE)
        }
    )
    
    #____________________________________----
    #4.6.2 dl_model TAB ----
    
    output$dl_horizon <- renderUI({
        shinyWidgets::numericInputIcon(
            inputId = "dl_horizon",
            value   = rv$horizon_recommended,
            min     = 1,
            label   = "Enter a Forecast Horizon",
            icon    = icon("chart-line")
        )
    })
    
    # output$dl_lookback <- renderUI({
    #     numericInput(
    #         inputId = "dl_lookback",
    #         label   = "Lookback period:",
    #         value   = 2*input$dl_horizon,
    #         min     = 1,
    #         max     = 1000,
    #         step    = 1   
    #     )
    # })
    
    ## DeepAR inputs ----
    output$dl_deepar_inputs <- renderUI({
        if("Deep AR" %in% input$dl_model_selection){
            return(NULL)
        }
    }) 
    
    ## Nbeats inputs ----
    output$dl_nbeats_inputs <- renderUI({
        if("NBeats Ensemble" %in% input$dl_model_selection){
            list(
                hr(),
                
                htmlOutput(
                    outputId = "dl_nb_text"
                ),
                
                shinyWidgets::pickerInput(
                    inputId  = "dl_nb_loss_function",
                    label    = "Loss function:", 
                    choices  = c("sMAPE", "MASE", "MAPE"),
                    options  = list('actions-box' = TRUE),
                    multiple = TRUE
                ),
                
                numericInput(
                    inputId = "dl_nb_expansion",
                    label   = "Expansion coefficient length:",
                    value   = 3,
                    min     = 1,
                    max     = 100,
                    step    = 1   
                ),
                
                numericInput(
                    inputId = "dl_nb_bagging",
                    label   = "Bagging size:",
                    value   = 3,
                    min     = 1,
                    max     = 10,
                    step    = 1   
                )
            )
        }
    })
    
    output$dl_nb_text <- renderText({
        paste("<h4><b>NBeats Ensemble parameters:")
    })
    
    #. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .----
    ##DL models ----
    
    observeEvent(input$run_dl, {

        req(input$dl_horizon)
        req(rv$data)
        
        print("Deep Learning modelling in progress")
        
        ###Progress bar ----
        progress <- shiny::Progress$new()
        on.exit(progress$close())
        progress$set(message = "Deep Learning modelling in progress", value = 0)

        ##Text dialog ----
        showModal(
            modalDialog(
                title = "Deep Learning modelling  in progress",
                "Training the chosen Deep Learning models. This will take a few moments, feel free to explore the time series in the meantime.",
                footer = modalButton("Dismiss"),
                easyClose = TRUE,
                fade = TRUE
            )
        )

        ##EXTENDING data ----
        full_data_tbl <- rv$data %>%

            #Gluonts algorithms require an id var
            mutate(id = ifelse("id" %in% names(rv$data), id, "1")) %>%

            # Remove missing values
            na.omit() %>%

            group_by(id) %>%

            future_frame(
                .date_var   = Date,
                .length_out = input$dl_horizon,
                .bind_data  = TRUE
            ) %>%

            ungroup()

        # Data Prepared
        actual_data <- full_data_tbl %>%
            filter(!is.na(Value))

        rv$dl_data_prepared_tbl <- actual_data %>%
            drop_na()

        rv$dl_future_tbl <- full_data_tbl %>%
            filter(is.na(Value))

        ## SPLITTING data----
        rv$splits <- rv$dl_data_prepared_tbl %>%
            time_series_split(
                date_var   = Date,
                assess     = input$dl_horizon,
                cumulative = TRUE
            )
        
        ## Model Parameters ----
        rv$epochs        <- input$dl_epochs
        rv$bagging       <- input$dl_nb_bagging
        rv$loss_function <- input$dl_nb_loss_function
        
        ##1+2/7 Modeltime table ----
        progress$inc(1/6, detail = percent(1/6))
        
        rv$dl_models_tbl <- DL_models(input         = input$dl_model_selection,
                                      train_data    = training(rv$splits),
                                      freq          = rv$ts_scale,
                                      horizon       = input$dl_horizon,
                                      epochs        = rv$epochs,
                                      bagging       = rv$bagging,
                                      loss_function = rv$loss_function)
        
        ##3/7 Calibration ----
        progress$inc(2/6, detail = percent(2/6))
        
        rv$dl_calibration_tbl <- rv$dl_models_tbl %>% 
            modeltime_calibrate(new_data = testing(rv$splits)
            )
        
        ##4/7 Accuracy ----
        progress$inc(3/6, detail = percent(3/6))
        
        rv$dl_accuracy_tbl <- rv$dl_calibration_tbl %>%
            modeltime_accuracy()
        
        ##5/7 Test forecast ----
        progress$inc(4/6, detail = percent(4/6))
        
        rv$dl_forecast_tbl <- rv$dl_calibration_tbl %>% 
            modeltime_forecast(new_data    = testing(rv$splits),
                               actual_data = rv$dl_data_prepared_tbl
            )
        
        ##6/7 Refitting to full dataset ----
        progress$inc(5/6, detail = percent(5/6))
        
        rv$dl_refit_tbl <- rv$dl_calibration_tbl %>% 
            modeltime_refit(data = rv$dl_data_prepared_tbl
            )
        
        ##7/7 Forecast future horizon ----
        progress$inc(6/6, detail = percent(6/6))
        
        rv$dl_future_forecast_tbl <-rv$dl_refit_tbl %>% 
            modeltime_forecast(
                new_data    = rv$dl_future_tbl,
                actual_data = rv$dl_data_prepared_tbl,
                keep_data   = TRUE
            )
        
        removeModal()
        
        message("\n Deep Learning Modelling Done!")
    })
        
        #. . . . . . . . . . . . . . . . . . . . . . ----
        # Plot (dl_test_plot)----
        output$dl_test_plot <- renderPlotly({
            req(rv$dl_forecast_tbl)
            
            df <- rv$dl_forecast_tbl
            
            g <- df %>%
                plot_modeltime_forecast(
                    .conf_interval_alpha = 0.2,
                    .legend_show         = TRUE,
                    .title               = NULL,
                    .legend_max_width    = 25,
                    .interactive         = FALSE
                )
            
            ggplotly(g, dynamicTicks = TRUE) %>%
                rangeslider()
        })
        
        # Accuracy Table (dl_table_accuracy) ----
        output$dl_table_accuracy <- renderReactable({
            req(rv$dl_accuracy_tbl)
            
            rect_data <- rv$dl_accuracy_tbl %>% 
                table_modeltime_accuracy(
                    .searchable    = FALSE,
                    .show_sortable = FALSE
                )
            return(rect_data)
        })
        
        # Future Plot (dl_forecast_plot)----
        output$dl_forecast_plot <- renderPlotly({
            req(rv$dl_future_forecast_tbl)
            
            df <- rv$dl_future_forecast_tbl
            
            g <- df %>% 
                plot_modeltime_forecast(
                    .conf_interval_alpha = 0.1,
                    .conf_interval_show  = input$dl_forecast_plot_conf,
                    .legend_show         = input$dl_forecast_plot_legend,
                    .title               = NULL,
                    .interactive         = FALSE
                )+
                scale_y_continuous(labels = scales::comma_format())
            
            ggplotly(g, dynamicTicks = TRUE) %>%
                rangeslider()
        })
        
        # Forecast table (dl_table_forecast)----
        output$dl_table_forecast <- renderReactable({
            req(rv$dl_future_forecast_tbl)
            data <- rv$dl_future_forecast_tbl %>% 
                filter(.key =="prediction") %>% 
                select(-c(Value, .index))
            
            rect_data <- reactable(data,
                                   defaultPageSize     = 5,
                                   pageSizeOptions     = c(5, 10, 20),
                                   groupBy             = ".model_desc",
                                   showPageSizeOptions = TRUE,
                                   minRows             = 1,
                                   sortable            = TRUE,
                                   highlight           = TRUE,
                                   defaultColDef       = colDef(
                                       footer = function(values, name) htmltools::div(name, style = list(fontWeight = 600))
                                   )
            )
        })
        
        # Forecast table downloader (dl_download_forecast)----
        output$dl_download_forecast <- downloadHandler(
            filename = function() {
                paste({input$dl_horizon}, "_dl_forecast_", {file_path_sans_ext(input$file_main)}, ".csv", sep = "")
            },
            
            content = function(file) {
                req(rv$dl_future_forecast_tbl)
                data <- rv$dl_future_forecast_tbl %>% 
                    filter(.key =="prediction") %>% 
                    select(-c(Value, .index))
                
                write.csv(data, file, row.names = FALSE)
            }
        )
        
}

shinyApp(ui, server)
