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
#' file_w <- sprintf("TSM_%s_w.txt", sitename)
#'
#' write_input(d$EVI/1e4 , file_y, nptperyear)
#' write_input(d$SummaryQA, file_w, nptperyear)
write_input <- function(x, file="TSM_y.txt", nptperyear=23){
    if (!is.matrix(x)) x <- matrix(x, nrow=1)
    dim  <- dim(x)

    ngrid <- dim[1] # how many points
    npt  <- dim[2]

    nyear <- floor(npt/nptperyear)
    npt  <- nptperyear*nyear

    header <- sprintf("%d\t%d\t%d", nyear, nptperyear, ngrid)

    write_lines(header, file)
    # write.table(x[, 1:npt, drop=F], file, append = T, row.names = F, col.names = F, sep = "\t")
    suppressMessages(fwrite(x[, 1:npt, drop = F], file, append = T, 
        row.names = F, col.names = F, sep = "\t"))
}
