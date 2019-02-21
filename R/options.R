options_TSM <- list(
    version             = "3.3",
    job_name            = "TSM",          # Job_name (no blanks) 
    is_image            = 0,              # Image /series mode (1/0) 
    is_trend            = 0,              # 1 = STL trend fitting activated. Overrules choice of fitting method (row 32).
    has_QC              = 1,              # 1 = use quality data, 0 = do not use quality data
    file_y              = "",             # Data file list/name 
    file_w              = "",             # Mask file list/name 
    image_type          = 1,              # Image file type 
    byte_order          = 0,              # Byte order (1/0) 
    image_dim           = c(1, 1),        # Image dimension (nrow ncol) 
    win_process         = c(1, 1, 1, 1),  # Processing window (start row end row start col end col) 
    nyear_and_nptperear = c(17, 23),      # No. years and no. points per year 
    ylu                 = c(0, 9999),      # Valid data range (lower upper) 
    qc_1                = c(0, 0, 1),     # Quality range 1 and weight 
    qc_2                = c(1, 1, 0.5),   # Quality range 2 and weight 
    qc_3                = c(2, 3, 0.2),   # Quality range 3 and weight 
    A                   = 0.1,            # Amplitude cutoff value 
    debug               = 0,              # Debug flag (3/2/1/0) 
    output_type         = c(1, 1, 0),     # Output files (1/0 1/0 1/0) 
    has_lc              = 0,              # Use land cover (1/0) 
    file_lc             = "",             # Name of landcover file 
    spike_meth          = 1,              # Spike method (3/2/1/0) 
    spike_sd            = 2.0,            # Spike value 
    stl_stiffness       = 3.0,            # STL stiffness value (1-10) 
    n_lcs               = 1,              # No. of landcover classes 
    # ************, Separator
    lc_code             = 1,              # Land cover code for class 1 
    seasonpar           = 1.0,            # Seasonality parameter (0-1) 
    iters               = 2,              # No. of envelope iterations (3/2/1) 
    adapt               = 2,              # Adaptation strength (1-10) 
    force_min           = c(0, -9999),   # Force minimum (1/0) and value 
    FUN                 = 2,              # Fitting method (3/2/1) 
    wFUN                = 1,              # Weight update method 
    half_wmin           = 7,              # Window size for Sav-Gol. 
    par_1               = 0,              # Reserved 
    par_2               = 0,              # Reserved 
    meth_pheno          = 1,              # Season start / end method (4/3/2/1) 
    trs                 = c(0.5, 0.5)     # Season start / end values 
)
# {Separator. This row contains a separator. On the rows following the separator
# parameters are given that are specific to each land cover class. If no land
# cover map is used all time-series will be treated as belonging to the first
# class.}
