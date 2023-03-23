# bp_ranges: list of 2-element vectors, with the names the chromosomes (1-19 and X)
# bp_lengths: vector of chromosome lengths with names 1-19 and X
bp_out_of_range <-
    function(bp_ranges, bp_lengths=mmconvert::grcm39_chrlen)
    {
        chr_flag <- NULL
        for(chr in names(bp_ranges)) {
            if(!chr %in% names(bp_lengths)) next
            if(bp_ranges[[chr]][1] < 1 ||
               bp_ranges[[chr]][2] > bp_lengths[chr]) {
                chr_flag <- c(chr_flag, chr)
            }
        }
        if(length(chr_flag) > 0) {
            warning("Positions out of range of GRCm39 genome on chr ",
                    paste(chr_flag, collapse=", "))
        }
        invisible(chr_flag)
    }
