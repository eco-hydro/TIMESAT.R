# This function is used to track the offset within the binary vector as readBin
# does not track position except for file objects
offset_readBin <- function(raw_vec, what, n=n, size=size, increment_offset=TRUE, ...) {
    env <- parent.frame()
    offset <- get("offset", envir = env)

    bin_data <- readBin(raw_vec[offset:(n * size + offset)], what, n, size, ...)
    # Use a global variable to track the offset
    if (increment_offset) {
        assign("offset", offset + (size*n), envir = env, inherits=TRUE)
    }
    return(bin_data)
}

#' read_tpa
#'
#' Read seasonality phenological metrics in TIMESAT .tpa binary
#' format file to dataframe.
#'
#' @param file A string giving the location of a .tpa file output by
#' TIMESAT
#'
#' @return A data.frame containing 14 columns: \code{
#' "row", "col", "season", "time_start", "time_end", "len",
#' "val_base", "time_peak", "val_peak", "ampl", "der_l", "der_r",
#' "integ_large", "integ_small", "val_start", "val_end"}.
#'
#' @export
#'
#' @examples
#' file <- system.file("example/ascii/TSM_TS.tpa", package = "rTIMESAT")
#' d_tpa <- read_tpa(file)
read_tpa <- function(file, t = NULL) {
    if (missing(file) || !grepl('[.]tpa$', tolower(file))) {
        stop('must specify a .tpa file')
    }

    # The number of seasonal indicators output by TIMESAT.
    Colnames     <- c("row", "col", "season", "time_start", "time_end", "len",
        "val_base", "time_peak", "val_peak", "ampl", "der_l", "der_r",
        "integ_large", "integ_small", "val_start", "val_end")
    Colnames_adj <- c("row", "col", "season", "time_start", "time_end", "time_peak", "len",
        "val_start", "val_end", "val_peak", "val_base", "ampl",
        "der_l", "der_r", "integ_large", "integ_small")

    ncol <- length(Colnames)

    # Number of elements in the tpa file line header (which are normally: row,
    # column, number of seasons).
    fid <- file(file, "rb")
    raw_vec <- readBin(fid, n=file.info(file)$size, raw())
    on.exit(close(fid))

    # This function is used to track the offset within the binary vector as readBin
    # does not track position except for file objects
    offset <- 1
    raw_vec_length <- length(raw_vec)

    # File header format is: nyears nptperyear rowstart rowstop colstart colstop
    header <- offset_readBin(raw_vec, integer(), n=6, size=4) %>%
        set_names(c("nyear", "nptperyear", "row_start", "row_end", "col_start", "col_end")) %>% as.list()

    num_rows <- with(header, row_end - row_start + 1)
    num_cols <- with(header, col_end - col_start + 1)
    n_pixels <- num_cols * num_rows # How many points?

    # Read the data and save it in the tpa_data matrix
    lst <- map(1:n_pixels, function(i){
        info <- offset_readBin(raw_vec, integer(), n=3, size=4)
        # If failed to extract phenology matrix: (fixed 20190316)
        # info <- c(0, 0, 0)
        nseason <- info[3]
        if (nseason > 0) {
            data <- offset_readBin(raw_vec, numeric(), n=(ncol-3)*nseason, size=4) %>%
                matrix(nrow = nseason, byrow = T) %>%
                cbind(info[1], info[2], 1:nseason, .)
        } else {
            data <- NULL
        }
        return(data)
    })
    df <- do.call(rbind.data.frame, lst) %>% set_colnames(Colnames)
    df <- df[, Colnames_adj]
    df %<>% dplyr::mutate(across(time_start:time_peak, ~num2date(.x, t)))
    return(df)
}

#' @importFrom dplyr across mutate
#' @importFrom stats approx
#' @export
num2date <- function(x, t = NULL) {
    if (is.null(t)) return(x)
    approx(seq_along(t), t, xout = x, na.rm = FALSE)$y %>% as.Date(origin = "1970-01-01")
}
