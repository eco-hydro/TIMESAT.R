#' TSF_main
#'
#' TIMESAT main function
#'
#' @param y The input vegetation time series
#' @param qc the QC flag of `y`
#' @param nptperyear n points per year
#' @param t corresponding date of `y`
#' @param options TIMESAT options, see [write_setting()]
#' @param cache boolean. If false, temporal files will be removed.
#'
#' @seealso [write_input()]
#' @export
TSF_main <- function(y, qc, nptperyear = 23,
    jobname ="TSF", options = NULL, cache = T,
    t = NULL)
{
    ## 1. Prepare inputs
    y %<>% as.matrix()
    qc %<>% as.matrix()

    # make sure it's complete year in input
    nyear <- floor(nrow(y)/nptperyear)
    npt   <- nyear * nptperyear

    jobname %<>% paste0("TSF_", .)
    file_set <- sprintf("%s.set", jobname)
    options$file_y  = sprintf("%s_y.txt", jobname)  # Data file list/name
    options$file_qc = sprintf("%s_qc.txt", jobname) # Mask file list/name
    options$nyear_and_nptperear = c(nyear, nptperyear)

    write_input(y[1:npt, drop = FALSE], options$file_y, nptperyear)
    write_input(qc[1:npt, drop = FALSE], options$file_qc, nptperyear)

    options$job_name <- jobname
    opt <- update_setting(options)

    write_setting(opt, file_set)
    TSF_process(file_set) # call TSF_process.exe

    file_tts <- sprintf("%s_fit.tts", opt$job_name)
    file_tpa <- sprintf("%s_TS.tpa", opt$job_name)

    d_tts <- read_tts(file_tts) %>% tidy_tts()
    d_tpa <- read_tpa(file_tpa, t)
    
    if (!cache){
        status1 <- file.remove(c(file_tts, file_tpa, opt$file_y, opt$file_qc, file_set))
        status2 <- dir(".", "*.ndx", full.names = T) %>% file.remove()
    }
    list(fit = d_tts, pheno = d_tpa)
}

# note: only suit for ascii
tidy_tts <- function(d_tts){
    sites <- d_tts$row %>% paste0("v", .)
    npt   <- ncol(d_tts) - 2
    d <- d_tts %>% {.[, 3:ncol(.)]} %>% as.matrix() %>% t() %>% data.frame() %>%
        set_colnames(sites) %>% cbind(t = 1:npt, .)
    d
}
