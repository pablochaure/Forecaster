exp_smoothing_custom <-
function(mode = "regression", seasonal_period = NULL,
                          error = NULL, trend = NULL, season = NULL, damping = NULL,
                          smooth_level = NULL, smooth_trend = NULL, smooth_seasonal = NULL
) {
  
  args <- list(
    seasonal_period   = rlang::enquo(seasonal_period),
    error             = rlang::enquo(error),
    trend             = rlang::enquo(trend),
    season            = rlang::enquo(season),
    damping           = rlang::enquo(damping),
    smooth_level      = rlang::enquo(smooth_level),
    smooth_trend      = rlang::enquo(smooth_trend),
    smooth_seasonal   = rlang::enquo(smooth_seasonal)
  )
  
  parsnip::new_model_spec(
    "exp_smoothing",
    args     = args,
    eng_args = NULL,
    mode     = mode,
    method   = NULL,
    engine   = NULL
  )
  
}
