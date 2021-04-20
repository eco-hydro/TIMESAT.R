
library(rTIMESAT)
library(phenofit)

{
    options <- list(
        ylu                 = c(0, 9999),     # Valid data range (lower upper)
        qc_1                = c(0, 0, 1),     # Quality range 1 and weight
        qc_2                = c(1, 1, 0.5),   # Quality range 2 and weight
        qc_3                = c(2, 3, 0.2),   # Quality range 3 and weight
        A                   = 0.1,            # Amplitude cutoff value
        output_type         = c(1, 1, 0),     # Output files (1/0 1/0 1/0), 1: seasonality data; 2: smoothed time-series; 3: original time-series
        seasonpar           = 1.0,            # Seasonality parameter (0-1)
        iters               = 2,              # No. of envelope iterations (3/2/1)
        FUN                 = 2,              # Fitting method (1/2/3): (SG/AG/DL)
        half_win            = 7,              # half Window size for Sav-Gol.
        meth_pheno          = 1,              # (1: seasonal amplitude, 2: absolute value, 3: relative amplitude, 4: STL trend)
        trs                 = c(0.5, 0.5)     # Season start / end values
    )

    data("MOD13A1")
    sitename <- "US-KS2"
    # sitename <- "CA-NS6"

    nptperyear <- 23
    # nptperyear <- 46

    d <- subset(MOD13A1$dt, date >= as.Date("2004-01-01") & date <= as.Date("2010-12-31") & site == sitename)
    r <- TSF_main(
        y = d$EVI / 1e4, qc = d$SummaryQA * 1.0, nptperyear,
        jobname = sitename, options, cache = FALSE
    )
    print(str(r))
}
