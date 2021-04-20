#! /usr/bin/Rscript --no-init-file
# Dongdong Kong ----------------------------------------------------------------
# Copyright (c) 2021 Dongdong Kong. All rights reserved.
# source('scripts/main_pkgs.R')

library(rTIMESAT)
library(ggplot2)
library(phenofit)
library(lubridate)

# load_all("/mnt/i/Research/phenology/rTIMESAT.R")
# devtools::load_all("../phenofit.R")

# devtools::load_all("/mnt/i/Research/phenology/rTIMESAT.R")
#' @param d a data.frame with the columns of `[]`
TIMESAT_process <- function(d, nptperyear = 365, p_trs = 0.1, half_win = NULL) {
    if (is.null(half_win)) half_win = floor(nptperyear / 5 * 1)

    options <- list(
        ylu         = c(0, 9999), # Valid data range (lower upper)
        qc_1        = c(0.0, 0.2, 0.2), # Quality range 1 and weight
        qc_2        = c(0.2, 0.5, 0.5), # Quality range 2 and weight
        qc_3        = c(0.5, 1.0, 1), # Quality range 3 and weight
        A           = 0.1, # Amplitude cutoff value
        output_type = c(1, 1, 0), # Output files (1/0 1/0 1/0), 1: seasonality data; 2: smoothed time-series; 3: original time-series
        seasonpar   = 0.2, # Seasonality parameter (0-1)
        iters       = 2, # No. of envelope iterations (3/2/1)
        FUN         = 1, # Fitting method (1/2/3): (SG/AG/DL)
        half_win    = half_win, # half Window size for Sav-Gol.
        meth_pheno  = 1, # (1: seasonal amplitude, 2: absolute value, 3: relative amplitude, 4: STL trend)
        trs         = c(1, 1) * p_trs # Season start / end values
    )
    
    # data("MOD13A1")
    sitename <- "rTS"
    # sitename <- "CA-NS6"
    # d <- subset(MOD13A1$dt, date >= as.Date("2004-01-01") & date <= as.Date("2010-12-31") & site == sitename)
    dat = d
    if (nptperyear > 300) dat = d[format(t, "%m-%d") != "02-29"]
    # add one year data
    dat2 = dat
    dat2 = rbind(dat[1:nptperyear], dat) # the first year with no phenology info
    r <- TSF_main(
        y = dat2$y, qc = dat2$w, nptperyear,
        jobname = sitename, options, cache = F, NULL)
    r$pheno %<>% dplyr::mutate(across(time_start:time_peak, function(x) {
        x  = x - nptperyear
        num2date(x, d$t)
    }))
    r$fit = data.table(t = d$t, z = r$fit$v1[-(1:nptperyear)])
    r
}

TIMESAT_plot <- function(d, r, base_size = 12) {
    d_pheno  = r$pheno
    date_begin = d$t %>% first() %>% {make_date(year(.), 1, 1)}
    date_end   = d$t %>% last() %>% {make_date(year(.), 12, 31)}
    brks_year = seq(date_begin, date_end, by = "year")

    ggplot(d, aes(t, y)) +
        # geom_rect(data = d_ribbon, aes(x = NULL, y = NULL, xmin = xmin, xmax = xmax, group = I, fill = crop),
        #     ymin = -Inf, ymax = Inf, alpha = 0.2, show.legend = F) +
        geom_rect(data = d_pheno, aes(x = NULL, y = NULL, xmin = time_start, xmax = time_end, group = season),
            ymin = -Inf, ymax = Inf, alpha = 0.2, show.legend = F, linetype = 1,
            fill = alpha("grey", 0.2),
            color = alpha("grey", 0.4)) +
        geom_line(color = "black", size = 0.4) +
        geom_line(data = r$fit, aes(t, z), color = "purple") +
        geom_point(data = d_pheno, aes(time_start, val_start), color = "blue") +
        geom_point(data = d_pheno, aes(time_end, val_end), color = "blue") +
        geom_point(data = d_pheno, aes(time_peak, val_peak), color = "red") +
        geom_vline(xintercept = brks_year, color = "yellow3") +
        theme_bw(base_size = base_size) +
        theme(
            axis.text = element_text(color = "black"),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_line(linetype = "dashed", size = 0.2)
        ) +
        scale_x_date(limits = c(date_begin, date_end), expand = c(0, 0))
}

simu_VI <- function(SOS = 50, EOS = 100, rate = 0.1, mx = 0.6, year = 2010, wmin = 0.2) {
    par <- c(0.1, mx, SOS, rate, EOS, rate)

    t <- seq(1, 365, 8)
    w <- rep(1, length(t))

    noise <- rnorm(n = length(t), mean = 0, sd = 0.05)
    I_noise <- noise < 0
    noise[!I_noise] <- 0
    w[I_noise] <- wmin
    y0 <- doubleLog.Beck(par, t)
    y  <- y0 + noise
    data.table(year, doy = t, t = as.Date(sprintf("%d%03d", year, t), "%Y%j"),
               y, y0, w)
}

{
    set.seed(0)
    d1_a <- simu_VI(150, 250, 0.1, year = 2010)
    d1_b <- simu_VI(150, 250, 0.15, year = 2011)

    # two growing season
    d2_1 <- simu_VI(50, 120, 0.05, year = 2012)
    d2_2 <- simu_VI(180, 250, 0.1, year = 2012)
    d2_a = rbind(d2_1[doy < 150, ], d2_2[doy >= 150, ])

    d2_1 <- simu_VI(50, 120, 0.1, year = 2013)
    d2_2 <- simu_VI(180, 250, 0.05, year = 2013)
    d2_b = rbind(d2_1[doy < 150, ], d2_2[doy >= 150, ])

    dat = rbind(d1_a, d1_b, d2_a, d2_b)
    # dat$w %<>% as.factor()

    ggplot(dat, aes(t, y)) +
        geom_line(aes(y = y0), color = "black") +
        geom_line(aes(y = y), color = "green")
        # geom_point(aes(color = w, shape = w))
}

r = TIMESAT_process(dat, 46, half_win = 10)
TIMESAT_plot(dat, r)

# l <- divide_seasons(dat, 46, is.plot = TRUE, maxExtendMonth = 2)
# l_TSM <- divide_seasons(dat, 46, iters = 3, is.plot = TRUE,
#                     wFUN = wTSM,
#                     # wFUN = wBisquare_julia,
#                     lambda = 10,
#                     .v_curve = FALSE,
#                     show.legend = F)
# l_bisquare <- divide_seasons(dat, 46, iters = 3, is.plot = TRUE,
#                         # wFUN = wTSM,
#                         wFUN = wBisquare_julia,
#                         lambda = 10,
#                         .v_curve = FALSE,
#                         show.legend = F)
