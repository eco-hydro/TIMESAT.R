#' write_input
#'
#' Write matrix into the format of TIMESAT.
#'
#' @param x matrix row is site, column is time.
#' @param file a character string naming a file.
#' @param nptperyear How many points per year?
#'
#' @importFrom utils write.table
#' @importFrom data.table fwrite
#' @export
#'
#' @note not allow NA values in x
#' 
#' @examples
#' library(rTIMESAT)
#' data("MOD13A1")
#' df <- subset(MOD13A1$dt, date >= as.Date("2010-01-01") & date <= as.Date("2017-12-31"))
#'
#' sitename <- "CA-NS6"
#' d <- subset(df, site == sitename)
#' nptperyear <- 23
#'
#' file_y <- sprintf("TSM_%s_y.txt", sitename)
#' file_qc <- sprintf("TSM_%s_w.txt", sitename)
#'
#' write_input(d$EVI/1e4 , file_y, nptperyear)
#' write_input(d$SummaryQA, file_qc, nptperyear)
write_input <- function(x, file="TSM_y.txt", nptperyear=23, missing = -0.1){
    if (!is.matrix(x)) x <- matrix(x, nrow=1)
    x[is.na(x)] <- missing
    dim  <- dim(x)

    ngrid <- dim[1] # how many points
    npt  <- dim[2]

    nyear <- floor(npt/nptperyear)
    npt  <- nptperyear*nyear

    header <- sprintf("%d %d %d", nyear, nptperyear, ngrid)

    write_lines(header, file)
    # write.table(x[, 1:npt, drop=F], file, append = T, row.names = F, col.names = F, sep = "\t")
    suppressMessages(fwrite(x[, 1:npt, drop = F], file, append = T, 
        row.names = F, col.names = F, sep = " "))
}
