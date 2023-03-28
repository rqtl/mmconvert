context("mmconvert")

test_that("mmconvert works in a simple case", {

    expected_result <- structure(list(marker=c("rs13482072", "rs13482231", "gnf14.117.278"),
                                      chr = c("14", "14", "14"),
                                      cM_coxV3_ave = c(0.39388779888276, 28.7007117832223, 59.5630159665358),
                                      cM_coxV3_female = c(0.420461682627125, 34.8398609429512, 64.5897949774906),
                                      cM_coxV3_male = c(0.370711578723447, 22.8635375609951, 55.0750080461851),
                                      bp_grcm39 = c(6738536L, 67215850L, 121955310L),
                                      Mbp_grcm39 = c(6.738536, 67.215850, 121.955310)),
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


test_that("mmconvert works at 0 position", {

    pos_Mbp <- setNames(paste(c(1:19,"X"), 3, sep=":"), c(1:19,"X"))
    pos_bp <- setNames(paste(c(1:19,"X"), 3e6, sep=":"), c(1:19,"X"))

    result_bp <- mmconvert(pos_bp)

    expect_equal(result_bp, mmconvert(pos_Mbp, "Mbp"))

})

test_that("mmconvert works without names", {

    input1 <- c("1:3000000", "2:3000000")
    input2 <- c("1:3", "2:3")
    expect_equivalent(mmconvert(input1), mmconvert(input2, "Mbp"))

    input1 <- list("1"=3000000, "2"=3000000)
    input2 <- list("1"=3, "2"=3)
    expect_equivalent(mmconvert(input1), mmconvert(input2, "Mbp"))

})

test_that("mmconvert handles chr names properly", {

    # warning of some chr wrong
    expect_warning( mmconvert(c(a="M:5", b="15:3", c="Y:8")) )
    expect_warning( mmconvert(list(M=c(5, 10), Y=c(8, 12), "15"=3)) )

    # error that all chr wrong
    expect_error( mmconvert(c(a="M:5", b="Z:3", c="Y:8")) )
    expect_error( mmconvert(list(M=c(5, 10), Y=c(8, 12), "Z"=3)) )

    # convert x -> X
    expect_equal( mmconvert("X:5"), mmconvert("x:5") )

})


test_that("mmconvert handles non-lists", {

    expect_equal( mmconvert(c("1"=3, "2"=3)), mmconvert(list("1"=3, "2"=3)) )

})

test_that("mmconvert handles matrices", {

    input1 <- cbind(chr=c(1,1,1,2,2,2),
                    pos=c(232364, 5807509, 6222136, 8701875, 1960672, 8409166))
    input2 <- cbind(chr=c("1","1","1","2","2","2"),
                    pos=c(232364, 5807509, 6222136, 8701875, 1960672, 8409166))

    expect_equal( mmconvert(input1), mmconvert(input2) )

})

test_that("mmconvert gives out-of-range warning", {

    input1 <- c("1:300000000", "2:300000000")

    expect_warning( mmconvert(input1) )

})
