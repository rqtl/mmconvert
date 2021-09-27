context("mmconvert")

test_that("mmconvert works in a simple case", {

    expected_result <- structure(list(chr = c("14", "14", "14"),
                                      cM_coxV3_ave = c(0.36341, 28.53961, 59.35825),
                                      cM_coxV3_female = c(0.38999, 34.47776, 64.2981),
                                      cM_coxV3_male = c(0.33855, 22.66819, 54.71467),
                                      bp_grcm39 = c(6738536L, 67215850L, 121955310L)),
                                      Mbp_grcm39 = c(6.738536, 6.7215850, 121.955310)),
                                 class = "data.frame",
                                 row.names = c("rs13482072", "rs13482231", "gnf14.117.278"))

    input1 <- c(rs13482072="14:6738536", rs13482231="14:67215850", gnf14.117.278="14:121955310")
    input2 <- list("14"=c(rs13482072=6738536, rs13482231=67215850, gnf14.117.278=121955310))
    input3 <- data.frame(chr=c(14,14,14),
                         pos=c(6738536, 67215850, 121955310),
                         marker=c("rs13482072", "rs13482231", "gnf14.117.278"))

    expect_equal(mmconvert(input1), expected_result)
    expect_equal(mmconvert(input2), expected_result)
    expect_equal(mmconvert(input3), expected_result)
})
