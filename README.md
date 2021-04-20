
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rTIMESAT

[![Travis Build
Status](https://travis-ci.org/kongdd/rTIMESAT.svg?branch=master)](https://travis-ci.org/kongdd/rTIMESAT)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/kongdd/rTIMESAT?branch=master&svg=true)](https://ci.appveyor.com/project/kongdd/rTIMESAT)
[![codecov](https://codecov.io/gh/kongdd/rTIMESAT/branch/master/graph/badge.svg)](https://codecov.io/gh/kongdd/rTIMESAT)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)
[![CRAN](http://www.r-pkg.org/badges/version/rTIMESAT)](https://cran.r-project.org/package=rTIMESAT)
[![DOI](https://zenodo.org/badge/171882895.svg)](https://zenodo.org/badge/latestdoi/171882895)

R package: Extract Remote Sensing Vegetation Phenology by TIMESAT
Fortran library.

## Installation

You can install the released version of rTIMESAT from GitHub with:
<!-- [CRAN](https://CRAN.R-project.org) with: -->

``` r
# install.packages("rTIMESAT")
devtools::install_github("kongdd/rTIMESAT")
```

## Example

This is a basic example which shows you how to use `rTIMESAT`:

``` r
## 1. TIMESAT options
# Note the length of `FUN` should be one.
# see details of every parameter in `write_setting`.
nptperyear = 23
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
```

``` r
library(rTIMESAT)
library(phenofit)

data("MOD13A1")
sitename <- "US-KS2"
# sitename <- "CA-NS6"

d <- subset(MOD13A1$dt, date >= as.Date("2004-01-01") & date <= as.Date("2010-12-31") & site == sitename)
r <- TSF_main(y = d$EVI/1e4, qc = d$SummaryQA, nptperyear, 
              jobname = sitename, options, cache = FALSE)
print(str(r))
#> List of 2
#>  $ fit  :'data.frame':   161 obs. of  2 variables:
#>   ..$ t : int [1:161] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ v1: num [1:161] 0.371 0.362 0.359 0.359 0.362 ...
#>  $ pheno:'data.frame':   6 obs. of  16 variables:
#>   ..$ row        : num [1:6] 1 1 1 1 1 1
#>   ..$ col        : num [1:6] 1 1 1 1 1 1
#>   ..$ season     : num [1:6] 1 2 3 4 5 6
#>   ..$ time_start : num [1:6] 7.18 29.79 53.33 75.63 98.19 ...
#>   ..$ time_end   : num [1:6] 18.4 43.4 61.9 88.7 102.7 ...
#>   ..$ time_peak  : num [1:6] 12.8 35.8 57.6 82 100.2 ...
#>   ..$ len        : num [1:6] 11.23 13.57 8.6 13.03 4.47 ...
#>   ..$ val_start  : num [1:6] 0.392 0.462 0.458 0.444 0.452 ...
#>   ..$ val_end    : num [1:6] 0.413 0.459 0.466 0.435 0.458 ...
#>   ..$ val_peak   : num [1:6] 0.425 0.522 0.52 0.476 0.511 ...
#>   ..$ val_base   : num [1:6] 0.38 0.399 0.404 0.403 0.4 ...
#>   ..$ ampl       : num [1:6] 0.0453 0.1236 0.1157 0.0734 0.1111 ...
#>   ..$ der_l      : num [1:6] 0.018 0.0305 0.0322 0.0133 0.0492 ...
#>   ..$ der_r      : num [1:6] 0.00617 0.01563 0.02708 0.01506 0.02284 ...
#>   ..$ integ_large: num [1:6] 5.44 7.96 4.98 6.94 2.88 ...
#>   ..$ integ_small: num [1:6] 0.499 1.583 0.942 0.898 0.484 ...
#> NULL
```
