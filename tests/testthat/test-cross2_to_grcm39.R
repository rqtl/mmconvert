context("cross2_to_grcm39")

test_that("cross2_to_grcm39 works for DOex", {

    library(qtl2)

    skip_if(isnt_karl(), "this test only run locally")

    file <- paste0("https://raw.githubusercontent.com/rqtl/",
                   "qtl2data/master/DOex/DOex.zip")
    DOex <- read_cross2(file)

    DOex_rev <- cross2_to_grcm39(DOex)

    expect_equal(tot_mar(DOex_rev), tot_mar(DOex)-14)
    expect_equal(n_ind(DOex_rev), n_ind(DOex))

})
