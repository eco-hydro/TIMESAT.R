context("test-tsf_process")


test_that("write_input works", {
    expect_silent({
      write_input(d$EVI/1e4 , file_y, nptperyear)
      write_input(d$SummaryQA, file_w, nptperyear)
    })
})


test_that("write_setting works", {
    expect_silent({
        options <- update_setting(options)
        write_setting(options, file_set)
    })
})

test_that("TSF_process works", {
    expect_silent({
        TSF_process(file_set)
    })
})
