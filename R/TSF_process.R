#' TSF_process
#' 
#' @param file_set file path of TIMESAT setting file.
#' @param ncluster How many clusters to be used in parallel mode?
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' file_set <- system.file("example/ascii/TSM.set", package = "rTIMESAT") 
#' TSF_process(file_set)
#' }
TSF_process <- function(file_set, ncluster = 1){
    exe <- system.file("exec/TSF_process.exe", package = "rTIMESAT")
    cmd <- sprintf("%s %s %d", exe, file_set, ncluster) 
    system(cmd)
}
