#' write_Input
#' 
#' Write matrix into the format of TIMESAT.
#' 
#' @param x matrix row is time, column is site.
#' @param file a character string naming a file.
#' @param nptperyear How many points per year?
#' 
#' @importFrom utils write.table
#' @export
#' 
#' @examples
#' library(rTIMESAT)
#' data("MOD13A1")
#' df <- MOD13A1$dt[date >= ymd("20010101") & date <= ymd("20171231")]
#' sitename <- "CA-NS6"
#' d <- df[site == sitename]
#' nptperyear <- 23
#' 
#' file_y <- sprintf("TSM_# s_y.txt", sitename)
#' file_w <- sprintf("TSM_# s_w.txt", sitename)
#' 
#' write_TSM(d$EVI/1e4 , file_y, nptperyear)
#' write_TSM(d$SummaryQA, file_w, nptperyear)
write_Input <- function(x, file="TSM_y.txt", nptperyear=23){
    if (!is.matrix(x)) x <- matrix(x, nrow=1)
    dim  <- dim(x)

    ngrid <- dim[1] # how many points
    npt  <- dim[2]

    nyear <- floor(npt/nptperyear)
    npt  <- nptperyear*nyear

    header <- sprintf("# d\t# d\t# d", nyear, nptperyear, ngrid)

    write_lines(header, file)
    write.table(x[, 1:npt, drop=F], file, append = T, row.names = F, col.names = F, sep = "\t")
}
