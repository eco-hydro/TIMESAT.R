library(rTIMESAT)

## 1. prepare inputs
data("MOD13A1")
df <- subset(MOD13A1$dt, date >= as.Date("2010-01-01") & date <= as.Date("2017-12-31"))

sitename <- "CA-NS6"
d <- subset(df, site == sitename)
nptperyear <- 23
nyear <- floor(nrow(d)/nptperyear)

file_y <- sprintf("TSM_%s_y.txt", sitename)
file_w <- sprintf("TSM_%s_w.txt", sitename)

write_input(d$EVI/1e4 , file_y, nptperyear)
write_input(d$SummaryQA, file_w, nptperyear)

## 2. adj options
options <- list(
   file_y              = file_y,             # Data file list/name
   file_w              = file_w,             # Mask file list/name
   nyear_and_nptperear = c(nyear, nptperyear),      # No. years and no. points per year
   ylu                 = c(0, 9999),     # Valid data range (lower upper)
   qc_1                = c(0, 0, 1),     # Quality range 1 and weight
   qc_2                = c(1, 1, 0.5),   # Quality range 2 and weight
   qc_3                = c(2, 3, 0.2),   # Quality range 3 and weight
   A                   = 0.1,            # Amplitude cutoff value
   output_type         = c(1, 1, 0),     # Output files (1/0 1/0 1/0)
   seasonpar           = 1.0,            # Seasonality parameter (0-1)
   iters               = 2,              # No. of envelope iterations (3/2/1)
   FUN                 = 2,              # Fitting method (3/2/1)
   half_win           = 7,              # half Window size for Sav-Gol.
   meth_pheno          = 1,              # Season start / end method (4/3/2/1)
   trs                 = c(0.5, 0.5)     # Season start / end values
)
opt <- update_setting(options)
print(str(opt))
file_set <- "TSM.set"
write_setting(opt, file_set)

TSF_process(file_set)
