options <- list(
        ylu = c(0, 9999), # Valid data range (lower upper)
        qc_1 = c(0.0, 0.2, 0.2), # Quality range 1 and weight
        qc_2 = c(0.2, 0.5, 0.5), # Quality range 2 and weight
        qc_3 = c(0.5, 1.0, 1), # Quality range 3 and weight
        A = 0.1, # Amplitude cutoff value
        output_type = c(1, 1, 0), # Output files (1/0 1/0 1/0), 1: seasonality data; 2: smoothed time-series; 3: original time-series
        seasonpar = 0.2, # Seasonality parameter (0-1)
        iters = 2, # No. of envelope iterations (3/2/1)
        FUN = 1, # Fitting method (1/2/3): (SG/AG/DL)
        half_win = 5, # half Window size for Sav-Gol.
        meth_pheno = 1, # (1: seasonal amplitude, 2: absolute value, 3: relative amplitude, 4: STL trend)
        trs = c(1, 1) * 0.1 # Season start / end values
    )

sitename <- "rTS"
# sitename <- "CA-NS6"
# d <- subset(MOD13A1$dt, date >= as.Date("2004-01-01") & date <= as.Date("2010-12-31") & site == sitename)
load("a.rda")
nptperyear = 46
dat <- d
if (nptperyear > 300) dat <- d[format(t, "%m-%d") != "02-29"]
# add one year data
# dat2 <- dat[1:floor(4.5*nptperyear), ]
dat2 = rbind(dat, dat[1:(nptperyear)])
r <- TSF_main(
    y = dat2$y, qc = dat2$w, nptperyear,
    jobname = sitename, options, cache = F,
    NULL
)
