#' @title rTIMESAT
#' @name rTIMESAT
#' @aliases rTIMESAT-package
#' @docType package
#' @keywords Vegetation phenology package
#' @description Extract Remote Sensing Vegetation Phenology by TIMESAT Fortran library
NULL

.onLoad <- function (libname, pkgname){
    if(getRversion() >= "2.15.1") {
        utils::globalVariables(
            c(".")
        )
    }
}
