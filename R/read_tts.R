#' read_tts
#' 
#' Read curve fitting time-series in TIMESAT .tts binary format file to dataframe.
#'
#' @param file A .tts file output by TIMESAT
#' 
#' @return A data.frame containing 'row' and 'col' columns giving the the row 
#' and column of a pixel in the input image to timesat, and then a number of 
#' columns named 't1', 't2', ...'tn', where n is the total number of image 
#' dates input to TIMESAT.
#' 
#' @export
#' 
#' @seealso
#' \code{\link{TSF_fit2time}}
#'
#' @examples
#' file <- system.file("example/ascii/TSM_fit.tts", package = "rTIMESAT") 
#' d_tts <- read_tts(file)
read_tts <- function(file) {
    if (missing(file) || !grepl('[.]tts$', tolower(file))) {
        stop('must specify a .tts file')
    }

    # Number of elements in the tts file line header (which are normally: row, column).
    fid <- file(file, "rb")
    raw_vec <- readBin(fid, n=file.info(file)$size, raw())
    on.exit(close(fid))

    offset <- 1
    header <- offset_readBin(raw_vec, integer(), n=6, size=4) %>%
        set_names(c("nyear", "nptperyear", "row_start", "row_end", "col_start", "col_end")) %>% as.list()
    
    num_rows <- with(header, row_end - row_start + 1)
    num_cols <- with(header, col_end - col_start + 1)
    
    n_pixels <- num_cols * num_rows # How many points?
    npt <- with(header, nyear*nptperyear)

    # Note that: if error in the middle procedure, all data will be chaos.
    lst <- map(1:n_pixels, function(i){
        info <- offset_readBin(raw_vec, integer(), n=2, size=4)
        data <- offset_readBin(raw_vec, numeric(), n=npt, size=4) %>% 
            c(info, .)
    })

    Colnames <- c("row", "col", paste('t', seq(1, npt), sep=''))
    df <- do.call(rbind.data.frame, lst) %>% set_colnames(Colnames)
    return(df)
}
