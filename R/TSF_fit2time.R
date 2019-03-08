#' TSF_fit2time
#'
#' Extracts time-series data (raw or fitted) for one or many pixels and writes
#' to an ASCII file
#'
#' @param infile file path of curve fitting file.
#' @param row_start  First row in processing window
#' @param row_end Last row in processing window
#' @param col_start First col in processing window
#' @param col_end Last col in processing window
#' @param outdir Output directory.
#' @param outfile file name of output.
#' @param wait A logical (not NA) indicating whether the R interpreter should
#' wait for the command to finish, or run it asynchronously.
#' 
#' @seealso
#' \code{\link{read_tts}}
#' 
#' @export
#' @examples
#' \dontrun{
#' TSF_fit2time(file, 1, 1e8, 1, 1, outdir = "TSF", wait = F)
#' }
TSF_fit2time <- function(infile, row_start = 1, row_end = Inf, col_start = 1, col_end = 1,
    outdir, outfile, wait = TRUE)
{
    if (missing(outdir)) outdir <- "."
    if (missing(outfile)) outfile <- gsub('.tts$', '.txt', infile)
    outfile <- sprintf("%s/%s", outdir, basename(outfile))

    comd <- sprintf('TSF_fit2time %s %d %d %d %d %s',
                    infile, row_start, row_end, col_start, col_end, outfile)
    system(comd, wait = wait)
}
