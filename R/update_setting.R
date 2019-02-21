#' update_setting
#'
#' @param options List object, see \code{\link{write_setting}}
#'
#' @export
#'
#' @examples
#' options <- list(
#'    file_y              = "",             # Data file list/name
#'    file_w              = "",             # Mask file list/name
#'    nyear_and_nptperear = c(17, 23),      # No. years and no. points per year
#'    ylu                 = c(0, 9999),     # Valid data range (lower upper)
#'    qc_1                = c(0, 0, 1),     # Quality range 1 and weight
#'    qc_2                = c(1, 1, 0.5),   # Quality range 2 and weight
#'    qc_3                = c(2, 3, 0.2),   # Quality range 3 and weight
#'    A                   = 0.1,            # Amplitude cutoff value
#'    output_type         = c(1, 1, 0),     # Output files (1/0 1/0 1/0)
#'    seasonpar           = 1.0,            # Seasonality parameter (0-1)
#'    iters               = 2,              # No. of envelope iterations (3/2/1)
#'    FUN                 = 2,              # Fitting method (1/2/3): (SG/AG/DL)
#'    half_win           = 7,              # half Window size for Sav-Gol.
#'    meth_pheno          = 1,              # Season start / end method (4/3/2/1)
#'    trs                 = c(0.5, 0.5)     # Season start / end values
#' )
#' opt <- update_setting(options)
#' print(str(opt))
#' write_setting(opt, "TSM.set")
update_setting <- function(options){
    I <- match(names(options), names(options_TSM))
    options_TSM[I] <- options
    return(options_TSM)
}
