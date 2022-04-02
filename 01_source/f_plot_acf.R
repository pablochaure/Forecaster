plot_acf <-
function(.data, .date_var, .value, .ccf_vars = NULL, .lags = 1000,
                                 .show_ccf_vars_only = FALSE,
                                 .show_white_noise_bars = FALSE,
                                 .facet_ncol = 1, .facet_scales = "fixed",
                                 .line_color = "#2c3e50", .line_size = 0.5,
                                 .line_alpha = 1,
                                 .point_color = "#2c3e50", .point_size = 1,
                                 .point_alpha = 1,
                                 .x_intercept = NULL,
                                 .x_intercept_color = "#E31A1C",
                                 .hline_color = "#2c3e50",
                                 .white_noise_line_type = 2,
                                 .white_noise_line_color = "#A6CEE3",
                                 .title = "Lag Diagnostics",
                                 .x_lab = "Lag", .y_lab = "Correlation",
                                 .interactive = TRUE, .plotly_slider = FALSE,
                                 #.feature_set options = c("acf", "pacf", "all")
                                 .feature_set = c("all")) {
  
  # Checks
  date_var_expr <- enquo(.date_var)
  value_expr    <- enquo(.value)
  if (rlang::quo_is_missing(date_var_expr)) stop(call. = FALSE, "plot_acf(.date_var), Please provide a .date_var column of class date or date-time.")
  if (rlang::quo_is_missing(value_expr)) stop(call. = FALSE, "plot_acf(.value), Please provide a .value.")
  if (!is.data.frame(.data)) {
    stop(call. = FALSE, "plot_diagnostics(.data) is not a data-frame or tibble. Please supply a data.frame or tibble.")
  }
  
  UseMethod("plot_acf", .data)
}
plot_acf.data.frame <-
function(.data, .date_var, .value, .ccf_vars = NULL, .lags = 1000,
                                            .show_ccf_vars_only = FALSE,
                                            .show_white_noise_bars = FALSE,
                                            .facet_ncol = 1, .facet_scales = "fixed",
                                            .line_color = "#2c3e50", .line_size = 0.5,
                                            .line_alpha = 1,
                                            .point_color = "#2c3e50", .point_size = 1,
                                            .point_alpha = 1,
                                            .x_intercept = NULL,
                                            .x_intercept_color = "#E31A1C",
                                            .hline_color = "#2c3e50",
                                            .white_noise_line_type = 2,
                                            .white_noise_line_color = "#A6CEE3",
                                            .title = "Lag Diagnostics",
                                            .x_lab = "Lag", .y_lab = "Correlation",
                                            .interactive = TRUE, .plotly_slider = FALSE,
                                            #.feature_set options = c("acf", "pacf", "all")
                                            .feature_set = c("all")) {
  
  # Tidy Eval Setup
  value_expr    <- rlang::enquo(.value)
  
  # ---- DATA PREPARATION ----
  
  data_formatted <- tk_acf_diagnostics(
    .data     = tibble::as_tibble(.data),
    .date_var = !! rlang::enquo(.date_var),
    .value    = !! value_expr,
    .ccf_vars = !! rlang::enquo(.ccf_vars),
    # ...       = ...,
    .lags     = .lags
  )
  
  if (.show_ccf_vars_only) {
    data_formatted <- data_formatted %>%
      dplyr::select(-dplyr::contains("ACF"))
  }
  
  if ("all" %in% .feature_set){
    data_formatted <- data_formatted %>%
      tidyr::pivot_longer(cols = -c(lag, .white_noise_upper, .white_noise_lower),
                          values_to = "value", names_to = "name") %>%
      dplyr::mutate(name = forcats::as_factor(name))
    
  } else if("acf" %in% .feature_set){
    data_formatted <- data_formatted %>%
      tidyr::pivot_longer(cols = -c(lag, .white_noise_upper, .white_noise_lower),
                          values_to = "value", names_to = "name") %>%
      dplyr::filter(name == "ACF") %>% 
      dplyr::mutate(name = forcats::as_factor(name))
  } else if ("pacf" %in% .feature_set) {
    data_formatted <- data_formatted %>%
      tidyr::pivot_longer(cols = -c(lag, .white_noise_upper, .white_noise_lower),
                          values_to = "value", names_to = "name") %>%
      dplyr::filter(name == "PACF") %>% 
      dplyr::mutate(name = forcats::as_factor(name))
  }
  
  
  
  # time_series_length <- nrow(.data)
  
  
  # ---- VISUALIZATION ----
  
  g <- data_formatted %>%
    ggplot2::ggplot(ggplot2::aes(lag, value, color = name)) +
    ggplot2::geom_hline(yintercept = 0, color = .hline_color) +
    ggplot2::facet_wrap(~ name, ncol = .facet_ncol, scales = .facet_scales) +
    ggplot2::expand_limits(y = 0) +
    ggplot2::labs(x = .x_lab, y = .y_lab, title = .title)
  
  if (!is.null(.x_intercept)) {
    if (!is.numeric(.x_intercept)) rlang::abort("`.x_intercept` must be a numeric value.")
    g <- g + ggplot2::geom_vline(xintercept = .x_intercept, color = .x_intercept_color)
  }
  
  # Add line
  if (.line_color == "scale_color") {
    g <- g +
      ggplot2::geom_line(ggplot2::aes(color = name),
                         size = .line_size, alpha = .line_alpha) +
      scale_color_tq()
  } else {
    g <- g +
      ggplot2::geom_line(color = .line_color, size = .line_size, alpha = .line_alpha)
  }
  
  # Add points
  if (.point_color == "scale_color") {
    g <- g +
      ggplot2::geom_point(ggplot2::aes(color = name),
                          size = .point_size, alpha = .point_alpha) +
      scale_color_tq()
  } else {
    g <- g +
      ggplot2::geom_point(color = .point_color, size = .point_size, alpha = .point_alpha)
  }
  
  # Add white noise bars
  if (.show_white_noise_bars) {
    g <- g +
      ggplot2::geom_line(ggplot2::aes(y = .white_noise_upper),
                         linetype = .white_noise_line_type,
                         color    = .white_noise_line_color) +
      ggplot2::geom_line(ggplot2::aes(y = .white_noise_lower),
                         linetype = .white_noise_line_type,
                         color    = .white_noise_line_color)
  }
  
  # Add theme
  g <- g + theme_tq()
  
  if (.interactive) {
    
    p <- plotly::ggplotly(g, dynamicTicks = TRUE)
    
    if (.plotly_slider) {
      p <- p %>%
        plotly::layout(
          xaxis = list(
            rangeslider = list(autorange = TRUE)
          )
        )
    }
    return(p)
  } else {
    return(g)
  }
}
plot_acf.grouped_df <-
function(.data, .date_var, .value, .ccf_vars = NULL, .lags = 1000,
                                            .show_ccf_vars_only = FALSE,
                                            .show_white_noise_bars = FALSE,
                                            .facet_ncol = 1, .facet_scales = "fixed",
                                            .line_color = "#2c3e50", .line_size = 0.5,
                                            .line_alpha = 1,
                                            .point_color = "#2c3e50", .point_size = 1,
                                            .point_alpha = 1,
                                            .x_intercept = NULL,
                                            .x_intercept_color = "#E31A1C",
                                            .hline_color = "#2c3e50",
                                            .white_noise_line_type = 2,
                                            .white_noise_line_color = "#A6CEE3",
                                            .title = "Lag Diagnostics",
                                            .x_lab = "Lag", .y_lab = "Correlation",
                                            .interactive = TRUE, .plotly_slider = FALSE) {
  
  # Tidy Eval Setup
  group_names   <- dplyr::group_vars(.data)
  value_expr    <- rlang::enquo(.value)
  
  # ---- DATA PREPARATION ----
  
  data_formatted <- tk_acf_diagnostics(
    .data     = .data,
    .date_var = !! rlang::enquo(.date_var),
    .value    = !! value_expr,
    .ccf_vars = !! rlang::enquo(.ccf_vars),
    # ...       = ...,
    .lags     = .lags
  )
  
  if (.show_ccf_vars_only) {
    data_formatted <- data_formatted %>%
      dplyr::select(-dplyr::contains("ACF"))
  }
  
  # dont_pivot_these <- c(group_names, "lag")
  data_formatted <- data_formatted %>%
    dplyr::ungroup() %>%
    dplyr::mutate(.groups_consolidated = stringr::str_c(!!! rlang::syms(group_names), sep = "_")) %>%
    dplyr::mutate(.groups_consolidated = forcats::as_factor(.groups_consolidated)) %>%
    dplyr::select(-(!!! rlang::syms(group_names))) %>%
    dplyr::select(.groups_consolidated, lag, dplyr::everything()) %>%
    tidyr::pivot_longer(cols      = -c(.groups_consolidated, lag, .white_noise_upper, .white_noise_lower),
                        values_to = "value",
                        names_to  = "name") %>%
    dplyr::mutate(name = forcats::as_factor(name))
  
  # data_formatted
  
  g <- data_formatted %>%
    ggplot2::ggplot(ggplot2::aes(lag, value, color = .groups_consolidated)) +
    ggplot2::geom_hline(yintercept = 0, color = .hline_color) +
    ggplot2::facet_grid(rows   = ggplot2::vars(name),
                        cols   = ggplot2::vars(.groups_consolidated),
                        scales = .facet_scales) +
    ggplot2::expand_limits(y = 0) +
    ggplot2::labs(x = .x_lab, y = .y_lab, title = .title)
  
  if (!is.null(.x_intercept)) {
    if (!is.numeric(.x_intercept)) rlang::abort("`.x_intercept` must be a numeric value.")
    g <- g + ggplot2::geom_vline(xintercept = .x_intercept, color = .x_intercept_color)
  }
  
  # Add line
  if (.line_color == "scale_color") {
    g <- g +
      ggplot2::geom_line(ggplot2::aes(color = .groups_consolidated),
                         size = .line_size, alpha = .line_alpha) +
      scale_color_tq()
  } else {
    g <- g +
      ggplot2::geom_line(color = .line_color, size = .line_size, alpha = .line_alpha)
  }
  
  # Add points
  if (.point_color == "scale_color") {
    g <- g +
      ggplot2::geom_point(ggplot2::aes(color = .groups_consolidated),
                          size = .point_size, alpha = .point_alpha) +
      scale_color_tq()
  } else {
    g <- g +
      ggplot2::geom_point(color = .point_color, size = .point_size, alpha = .point_alpha)
  }
  
  # Add white noise bars
  if (.show_white_noise_bars) {
    g <- g +
      ggplot2::geom_line(ggplot2::aes(y = .white_noise_upper),
                         linetype = .white_noise_line_type,
                         color    = .white_noise_line_color) +
      ggplot2::geom_line(ggplot2::aes(y = .white_noise_lower),
                         linetype = .white_noise_line_type,
                         color    = .white_noise_line_color)
  }
  
  # Add theme
  g <- g + theme_tq()
  
  
  if (.interactive) {
    return(plotly::ggplotly(g))
  } else {
    return(g)
  }
  
}
