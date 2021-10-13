#' Convert a cross2 object to use mouse build GRCm39
#'
#' Convert a cross2 object (with genotypes from one of the MUGA
#' arrays) to use mouse build GRCm39 and the revised Cox map
#' positions, revising marker order and omitting markers that are not
#' found.
#'
#' @param cross Object of class `"cross2"`, as produced by
#' [qtl2::read_cross2()]. Must have markers from just one of the MUGA arrays.
#'
#' @param array Character string indicating which of the MUGA arrays
#' was used ("gm" for GigaMUGA, "mm" for MegaMUGA, "mini" for
#' MiniMUGA, or "muga" for the original MUGA), or "guess" (the
#' default) to pick the array with the most matching marker names.
#'
#' @export
#'
#' @return The input `cross` object with markers subset to those in build GRCm39
#' and with `pmap` and `gmap` replaced with the GRCm39 physical map and
#' revised Cox genetic map, respectively.
#'
#' @seealso [MUGAmaps]
#'
#' @examples
#' \dontrun{
#' file <- paste0("https://raw.githubusercontent.com/rqtl/",
#'                "qtl2data/main/DOex/DOex.zip")
#' DOex <- read_cross2(file)
#' DOex_rev <- cross2_to_grcm39(DOex)
#' }

cross2_to_grcm39 <-
    function(cross, array=c("guess", "gm", "mm", "mini", "muga"))
{
    # check that it's cross2
    if(!inherits(cross, "cross2")) stop('Input cross must have class "cross2"')

    # markers in the cross object
    markers <- unlist(lapply(cross$geno, colnames))

    # MUGA maps (internal dataset)
    muga_maps <- mmconvert::MUGAmaps

    array <- match.arg(array)
    if(array == "guess") {
        # compare marker names to the four MUGA arrays
        # use the one with the most matches

        n_match <- vapply(muga_maps, function(a,b) sum(b %in% a$marker), 0, markers)
        if(!any(n_match > 0)) {
            stop("No markers found in the MUGA arrays")
        }

        array <- names(n_match)[which.max(n_match)]
    }

    map <- muga_maps[[array]]

    # number of markers found
    n_found <- sum(markers %in% map$marker)

    # if no markers found, stop with an error
    if(n_found == 0) {
        stop("No markers found in MUGA array")
    }

    n_notfound <- length(markers) - n_found

    # if more than 5% of markers omitted, give a warning
    if(n_notfound / length(markers) >= 0.05) {
        warning("Omitting ", n_notfound, " (", round(n_notfound/length(markers)*100), "%) markers")
    } else if(n_notfound > 0) {
        message("Omitting ", n_notfound, " markers")
    }

    map <- map[map$marker %in% markers, , drop=FALSE]

    gmap <- map_df_to_list(map, "chr", "cM_cox", "marker")
    map$Mbp_grcm39 <- map$bp_grcm39/1e6
    pmap <- map_df_to_list(map, "chr", "Mbp_grcm39", "marker")

    # reorder markers in geno
    cross$geno <- cross$geno[names(pmap)]
    for(chr in names(pmap)) {
        g <- cross$geno[[chr]]
        g <- g[, names(pmap[[chr]]), drop=FALSE]
        cross$geno[[chr]] <- g
    }


    # reorder markers in founder_geno
    if("founder_geno" %in% names(cross)) {
        cross$founder_geno <- cross$founder_geno[names(pmap)]
        for(chr in names(pmap)) {
            fg <- cross$founder_geno[[chr]]
            fg <- fg[, names(pmap[[chr]]), drop=FALSE]
            cross$founder_geno[[chr]] <- fg
        }
    }

    # paste in new genetic map
    cross$gmap <- gmap

    # paste in new physical map
    cross$pmap <- pmap

    # make sure that is_x_chr gets subset, if necessary
    cross$is_x_chr <- cross$is_x_chr[names(pmap)]

    cross
}
