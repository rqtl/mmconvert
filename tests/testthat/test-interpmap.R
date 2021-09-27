context("interpolate gen <-> phys maps")

test_that("interpolate_map works", {

    set.seed(31728290)
    oldmap <- sort(runif(20, 0, 100))
    newmap <- sort(runif(20, 0, 200))

    oldpos <- c(-2, seq(0, 100, by=10), 104)

    newpos <- interpolate_map(oldpos, oldmap, newmap)

    # calculate what result should be in R
    expected <- numeric(length(oldpos))
    wh_left <- (oldpos < min(oldmap))
    if(any(wh_left))
        expected[wh_left] <- min(newmap) - (min(oldmap) - oldpos[wh_left])*diff(range(newmap))/diff(range(oldmap))
    wh_right <- (oldpos >= max(oldmap))
    if(any(wh_right))
        expected[wh_right] <- min(newmap) + (oldpos[wh_right] - min(oldmap))*diff(range(newmap))/diff(range(oldmap))
    other <- (!wh_left & !wh_right)
    if(any(other)) {
        index <- sapply(oldpos[other], function(a,b) sum(b <= a), oldmap)
        expected[other] <- newmap[index] + (oldpos[other] - oldmap[index]) *
            (newmap[index+1] - newmap[index]) / (oldmap[index+1] - oldmap[index])
    }

    expect_equal(newpos, expected)

})


test_that("interp_map works in simplest case", {

    set.seed(31728290)
    oldmap <- list("1"=sort(runif(20, 0, 100)),
                   "2"=sort(runif(20, 0, 80)),
                   "3"=sort(runif(20, 0, 60)))

    # newmap is just double oldmap
    newmap <- oldmap
    for(i in seq(along=newmap)) newmap[[i]] <- oldmap[[i]]*2

    chr2 <- list("2"=c(0, 5, 20, 30))
    chr2_doubled <- list("2"=c(0, 10, 40, 60))
    expect_equal(interp_map(chr2, oldmap, newmap),
                 chr2_doubled)

    chr23 <- list("2"=c(0, 5, 20, 30), "3"=c(-5, 20, 40, 100))
    chr23_doubled <- list("2"=c(0, 10, 40, 60), "3"=c(-10, 40, 80, 200))
    expect_equal(interp_map(chr23, oldmap, newmap),
                 chr23_doubled)

})

test_that("interp_map preserves positions", {

    oldmap <- list("1"=c(0, 5,  5,  5, 10, 20))
    newmap <- list("1"=c(0, 5, 10, 15, 20, 30))
    names(oldmap[[1]]) <- names(newmap[[1]]) <- paste0("marker", seq_along(oldmap[[1]]))

    expect_equal(newmap, interp_map(oldmap, oldmap, newmap))

})
