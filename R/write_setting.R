#' write_setting
#' 
#' Write TIMESAT setting file.
#' 
#' @param options List object, parameters of TIMESAT.
#' @param file A character string naming a file 
#' 
#' @details
#' The global paremteres are as follows:
#'
#' \describe{
#'  
#' \item{version}{TIMESAT Version: 3.3.}
#' \item{job_name}{Character string that will be used to label output files from TIMESAT.}
#' \item{is_image}{1 = image mode, 0 = ASCII file with time-series.}
#' \item{is_trend}{1 = STL trend fitting activated. Overrules choice of fitting method (row 32)}
#' \item{has_QC}{1 = use quality data, 0 = do not use quality data.}
#' 
#' \item{file_y}{Running in image mode the user should prepare a file that 
#' on the first row gives the totalnumber N of vegetation index images and 
#' then the path and name of each of the N images.}
#' 
#' \item{file_qc}{Relevant if quality data are used (specifications on rows 14–16). 
#' Running in image mode the user should prepare a file that on the first row 
#' gives the total number N of quality images and then the paths and names of 
#' the quality images. The file has the same structure as the file listing 
#' vegetation index images. The name, followed by %, of the prepared file should 
#' be supplied on row 7. Running sequential data the user should specify the 
#' ASCII file containing the quality data. If quality data are not used the user 
#' should simply input any dummy name.}
#' 
#' \item{image_type (image mode)}{Relevant if in image mode. Please specify the data types 
#' of the images where 1 = 8-bit unsigned integer, 2 = 16-bit signed integer, 
#' 3 = 32-bit real (see also section 10.15). If not in image mode the user may simply input the value 0.}
#' 
#' \item{byte_order (image mode)}{Relevant if in image mode. Please specify the byte order 
#' where 0 = little endian byte order, 1 = big endian byte order (for 16-bit 
#' signed integers). If not in image mode the user may simply input the value 0.}
#' 
#' \item{image_dim (image mode)}{Relevant if in image mode. Please specify the byte order 
#' where 0 = little endian byte order, 1 = big endian byte order (for 16-bit 
#' signed integers). If not in image mode the user may simply input the value 0.}
#' 
#' \item{win_process}{Processing window (start row end row start col end col).}
#' \item{nyear_and_nptperear}{No. years and no. points per year.}
#' 
#' \item{ylu}{lower and upper boundary. Data outside the specified range will 
#' be assigned weight 0. By choosing these values carefully one may for example 
#' avoid that water pixels are processed.}
#'  
#' \item{qc_1}{c(qc_min, qc_max, w_value)}
#' \item{qc_2}{c(qc_min, qc_max, w_value)}
#' \item{qc_3}{c(qc_min, qc_max, w_value)}
#' \item{A}{Amplitude cutoff value. Amplitude lower than A will be ignored.}
#' 
#' \item{debug}{Debug flag. 
#' \describe{
#'     \item{0}{do not print debug data (recommended).}
#'     \item{1}{print certain debug parameters to the screen.}
#'     \item{2}{print certain debug parameters to file debug2_jobname.}
#'     \item{3}{if a crash occurs the position of the problematic time-series as 
#' well as the time-series itself is written to debug3_jobname.}
#' }}
#' 
#' \item{output_type}{(1/0 1/0 1/0), "1" means return, "0" means not.
#' 1: seasonality data, 2: smoothed time-series, 3: original time-series.}
#' 
#' \item{has_lc}{Boolean, Whether use land cover data?}
#' \item{file_lc}{Character, the file path of land cover.}
#' 
#' \item{spike_meth}{Numeric, the methods of spike remove. 
#' \describe{
#'     \item{0}{no spike detection.}
#'     \item{1}{method based on median filtering as described in TIMESAT manual section 3.3.}
#'     \item{2}{weights from STL-decomposition.}
#'     \item{3}{weights from STL-decomposition (the full time-series is divided into a 
#' seasonal- and a trend component, data values that do not fit this pattern are assigned low 
#' weights, see Cleveland et al. 1990 for detailed information) multiplied with original weights.}
#' }}
#' 
#' \item{spike_sd}{Numeric, data values that differ from the median value by 
#' more than the \code{spike_sd} multiplied with the standard deviation of y and that 
#' are different from the left and right neighbors are removed (assigned weight 0). 
#' A normal setting of the spike value is 2. }
#' 
#' \item{stl_stiffness}{STL stiffness value. This value regulates the stiffness of the STL trend
#' variable. The default is 3.0. A smaller value decreases stiffness, and a larger
#' value increases stiffness.}
#' 
#' \item{n_lcs}{No. of land cover classes. Number of land cover classes. Relevant only
#' if a land cover map is used. If a land cover map is not used the user may put 1
#' in this entry.}
#' 
#' \item{lc_code}{Land cover code for class 1. Land cover code for class 1.If there is no land
#' cover file or if processing sequential data in an ASCII file all time- series
#' will be processed with the parameter settings in rows 28–38, i.e. as if they
#' belonged to land cover class 1.}
#' 
#' \item{seasonpar}{Seasonality parameter. This parameter guides how the secondary maximum in the
#' determination of the number of seasons is treated (see section 3.5). A value 1
#' of the parameter will force the program to treat all data as if there is one
#' season per year. A small value of the parameter will attempt to fit two seasons
#' a year. If there are images covering areas with both one and two vegetation
#' seasons, as may be the case for images on continental scale, it is advisable
#' to separate these areas in two different land cover classes using a high value
#' of the seasonality parameter for the class with one vegetation season and a low
#' value for the class with two vegetation seasons.}
#' 
#' \item{iters}{No. of envelope iterations. The function fits can be made to approach the upper
#' envelope of the time-series in an iterative procedure (see section 3.4).
#' Specifying 1 for the number of envelope fits there is only one fit to data and
#' no adaptation to the envelope. Specifying 2 or 3 there are, respectively, one
#' and two additional fits where the weights of the values below the fitted curve
#' is decreased forcing the fitted function toward the upper envelope.}
#' 
#' \item{adapt}{Adaptation strength. The adaptation strength is a number between 1 and 10
#' indicating the strength of the upper envelope adaptation. 10 gives the strongest
#' adaptation to the upper envelope and 1 gives no adaptation. Strong adaptation,
#' especially combined with 3 envelope iterations, may put too much emphasis on
#' single high data values leading to bad results. The adaptation strength needs to
#' be fine tuned for given data, but a normal adaptation value is around 2 and 3.}
#' 
#' \item{force_min}{Force to minimum (1/0) and value of minimum. At northern or southern latitudes
#' time-series may during the dark season be affected by high sun zenith angles
#' and/or pertinent clouds, giving unphysically low values during long periods of
#' time. In these cases it may sometimes be useful to force the fitted function to
#' a user specified minimum (or off-season) value. This is done by giving 1 for the
#' first entry followed by the minimum value. If the user specifies 0 for the first
#' entry there will be no forcing to the minimum value.}
#' 
#' \item{FUN}{Fitting method (3/2/1). Indicate fitting method. Which method to use is
#' determined by the properties of the time-series. Different methods can be used
#' for different land cover classes. If STL trend fitting is activated (row 4),
#' this overrides the fitting method setting.
#' 
#' \describe{
#'     \item{1}{SavitzkyGolay filtering}
#'     \item{2}{asymmetric Gaussian}
#'     \item{3}{double logistic function}
#' }}
#' 
#' \item{wFUN}{Weight update method. Weight update method; not in use. The user may
#' simply input 1.}
#' 
#' \item{half_win}{Window size for Savitzky-Golay If Savitzky-Golay filtering is used (see section
#' 3.6) the half-window n needs to be set. This integer value should be seen in
#' relation to the total number data values during the year. A rough guide value is
#' around floor(nptperyear=4). A large value of the window gives a high degree of
#' smoothing, but affects the possibility to follow a rapid change in data in the
#' beginning of the growth season.}
#' 
#' \item{par_1}{Reserved}
#' \item{par_2}{Reserved}
#' 
#' \item{meth_pheno}{Season start/end method (1/2/3/4). Method for defining the start/end of
#' seasons (see further explanations in section 4.3). 
#' For methods 3, 2 and 1, the threshold values for start and end respectively are specified on row 38.
#' \describe{
#'     \item{1}{seasonal amplitude}
#'     \item{2}{absolute value}
#'     \item{3}{relative amplitude}
#'     \item{4}{STL trend}
#' }}
#' 
#' \item{trs}{Season start/end values. For start / end methods 3 and 1 please supply
#' the threshold values as a proportion of amplitude, ranging between 0 and 1. For
#' method 2 specify absolute values in data units. Not used for method 4 (supply
#' any values).}
#' 
#' }
#' 
#' @import magrittr
#' @importFrom readr write_lines
#' @importFrom purrr map map_chr
#' @export
#' 
#' @examples
#' opt <- rTIMESAT:::options_TSM
#' write_setting(opt, 'TSM.set')
write_setting <- function(options, file = "TSM.set"){
    # check about file_qc    
    if(options$file_qc == "") options$has_QC <- 0
    
    options$file_y  %<>% normalizePath() # "/"
    options$file_qc %<>% normalizePath()
    
    # convert numeric into string
    opt <- options %>% map_chr(paste, collapse = " ")

    str <- opt %>% paste(options_TSM_help, sep = "")
    write_lines(str[1:25], file)

    sep_lc = "************"
    write_lines(sep_lc      , file, append = TRUE)
    write_lines(str[-(1:25)], file, append = TRUE)
    # every land cover 13 params
}
