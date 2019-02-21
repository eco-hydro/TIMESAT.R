#' TSF_process
#' 
#' @param file_set file path of TIMESAT setting file.
#' @param ncluster How many clusters to be used in parallel mode?
#' 
#' @export
TSF_process <- function(file_set = "", ncluster = 1){
    indir <- system.file(package = "rTIMESAT")
    exe <- sprintf("%s/bin/TSF_process.exe", indir)
    cmd <- sprintf("%s %s %d", exe, file_set, ncluster) 
    system(cmd)
}
