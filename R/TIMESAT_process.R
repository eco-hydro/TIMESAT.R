#' TIMESAT_process
#' @param d a data.frame with the columns of `t`, `y` and `w`
#' @importFrom purrr map map_df transpose
#' @importFrom data.table data.table
#' @export
TIMESAT_process <- function(d, nptperyear = 365, p_trs = 0.1, half_win = NULL, cache = FALSE,
    methods = c("SG", "AG", "DL"),
    missval = -0.1, wmin = 0.1,
    seasonpar = 0.2,
    iters = 2)
{
    if (is.null(half_win)) half_win = floor(nptperyear / 5 * 1)
    I_meths = match(methods, c("SG", "AG", "DL"))

    sitename <- "rTS"
    d = d[format(t, "%m%d") != "0229", ]
    dat = d
    dat[is.na(y), y := missval]
    dat[w <= wmin, w := wmin]
    if (nptperyear > 300) dat = d[format(t, "%m-%d") != "02-29"]
    # add one year data
    dat2 = dat
    dat2 = rbind(dat[1:nptperyear], dat) # the first year with no phenology info

    process <- function(I_meth) {
        options <- list(
            ylu         = c(0, 9999), # Valid data range (lower upper)
            qc_1        = c(0.0, 0.2, 0.2), # Quality range 1 and weight
            qc_2        = c(0.2, 0.5, 0.5), # Quality range 2 and weight
            qc_3        = c(0.5, 1.0, 1), # Quality range 3 and weight
            A           = 0.1, # Amplitude cutoff value
            output_type = c(1, 1, 0), # Output files (1/0 1/0 1/0), 1: seasonality data; 2: smoothed time-series; 3: original time-series
            seasonpar   = seasonpar, # Seasonality parameter (0-1)
            iters       = iters, # No. of envelope iterations (3/2/1)
            FUN         = I_meth, # Fitting method (1/2/3): (SG/AG/DL)
            half_win    = half_win, # half Window size for Sav-Gol.
            meth_pheno  = 1, # (1: seasonal amplitude, 2: absolute value, 3: relative amplitude, 4: STL trend)
            trs         = c(1, 1) * p_trs # Season start / end values
        )
        # data("MOD13A1")
        # sitename <- "CA-NS6"
        # d <- subset(MOD13A1$dt, date >= as.Date("2004-01-01") & date <= as.Date("2010-12-31") & site == sitename)
        r <- TSF_main(
            y = dat2$y, qc = dat2$w, nptperyear,
            jobname = sitename, options, cache = cache, NULL)
        r$pheno %<>% dplyr::mutate(across(time_start:time_peak, function(x) {
            x  = x - nptperyear
            num2date(x, d$t)
        }))
        r$fit = data.table(t = d$t, z = r$fit$z1[-(1:nptperyear)])
        r
    }
    ans = map(I_meths, process) %>% set_names(methods)
    ans %>% purrr::transpose() %>%
        map(~map_df(.x, ~., .id = "meth"))
}
