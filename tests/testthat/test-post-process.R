context("test-post-process")

test_that("post-process", {
    file_tts <- system.file("example/ascii/TSM_fit.tts", package = "rTIMESAT")
    file_tpa <- system.file("example/ascii/TSM_TS.tpa", package = "rTIMESAT")

    expect_silent(d_tts <- read_tts(file_tts))
    expect_silent(d_tpa <- read_tpa(file_tpa))

    expect_equal(nrow(d_tpa), 7)
    expect_equal(ncol(d_tpa), 16)
    expect_equal(nrow(d_tts), 1)
})
