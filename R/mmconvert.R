#' Convert mouse genome positions
#'
#' Convert mouse genome positions between the build 39 physical map and the Cox genetic map.
#'
#' @param positions A set of positions, in one of three possible formats
#'   - a vector of character strings with like `"chr:position"`, with names being marker names,
#'     e.g., `c(rs13482072="14:6738536", rs13482231="14:67215850", gnf14.117.278="14:121955310")`.
#'   - a list of marker positions, each list being positions on a given chromosome,
#'     e.g., `list("14"=c(rs13482072=6738536, rs13482231=67215850, gnf14.117.278=121955310))`.
#'   - a data frame with columns chromosome, position, and marker,
#'     e.g. `data.frame(chr=c(14,14,14), pos=c(6738536, 67215850, 121955310), marker=c("rs13482072", "rs13482231", "gnf14.117.278"))`.
#'
#' @param input_type Character string indicating the type of positions provided (`"bp"`, `"Mbp"`,
#' `"ave_cM"`, `"female_cM"`, or `"male_cM"`)
#'
#' @return A data frame with the interpolated positions, with seven columns: marker,
#' chromosome, sex-averaged cM, female cM, male cM, basepairs, and mega-basepairs.
#' The rows are sorted by genomic position.
#'
#' @details We use linear interpolation using the Cox map positions in
#' the object [coxmap]. For positions outside the range of the
#' markers on the Cox map, we extrapolate using the overall
#' recombination rate.
#'
#' @export
#'
#' @seealso [coxmap]
#'
#' @examples
#' # input as character strings like chr:position
#' input_char <- c(rs13482072="14:6738536", rs13482231="14:67215850", gnf14.117.278="14:121955310")
#' mmconvert(input_char)
#'
#' # input as list, as in the map object for R/qtl1 and R/qtl2
#' input_list <- list("14"=c(rs13482072=6738536, rs13482231=67215850, gnf14.117.278=121955310))
#' mmconvert(input_list)
#'
#' # input as data frame; *must* have chr as first column and position as second
#' # (marker names can be third column, or can be row names)
#' input_df <- data.frame(chr=c(14,14,14),
#'                        pos=c(6738536, 67215850, 121955310),
#'                        marker=c("rs13482072", "rs13482231", "gnf14.117.278"))
#' mmconvert(input_df)
#'
#' # input can also be in Mbp
#' input_df$pos <- input_df$pos / 1e6
#' mmconvert(input_df, input_type="Mbp")

mmconvert <-
    function(positions, input_type=c("bp", "Mbp", "ave_cM", "female_cM", "male_cM"))
{
    input_type <- match.arg(input_type)

    # convert matrix to a data frame
    if(is.matrix(positions)) positions <- as.data.frame(positions)

    # convert positions to data frame
    if(is.character(positions)) {
        # split at ":"
        pos_spl <- strsplit(positions, ":", fixed=TRUE)
        markers <- names(pos_spl)
        if(is.null(markers)) markers <- paste0("pos", seq_along(positions))

        # check each is length 2
        if(!all(vapply(pos_spl, length, 0L)==2)) {
            stop('positions should all be like "chr:position".')
        }

        # pull apart chr and pos
        chr <- vapply(pos_spl, "[", "", 1)
        # strip off leading or ending white space
        chr <- sub("^\\s+", "", chr)
        chr <- sub("\\s+$", "", chr)

        # positions as numbers
        pos <- as.numeric(vapply(pos_spl, "[", "", 2))

        positions <- data.frame(chr=chr,
                                pos=pos,
                                marker=markers)
        rownames(positions) <- markers
    }

    if(is.data.frame(positions)) { # force to list
        if(is.null(rownames(positions))) {
            rownames(positions) <- paste0("pos", seq_len(nrow(positions)))
        }

        if(ncol(positions) == 2) { # no marker column
            positions <- cbind(positions, marker=rownames(positions))
        }

        positions <- map_df_to_list(positions,
                                    chr_column=colnames(positions)[1],
                                    pos_column=colnames(positions)[2],
                                    marker_column=colnames(positions)[3])
    } else {
        if(!is.list(positions)) { # otherwise, force it to be a list?
            positions <- as.list(positions)
        }
    }


    # make sure there are chromosome names
    if(is.null(names(positions))) {
        stop("input needs column names")
    }

    # force x -> X
    chr <- names(positions) <- toupper(names(positions))

    # drop chr outside 1-19, X
    if(!all(chr %in% c(1:19,"X"))) {
        if(any(chr %in% c(1:19,"X"))) {
            warning("Ignoring chr ", paste(chr[!(chr %in% c(1:19,"X"))], collapse=", "))
            positions <- positions[chr %in% c(1:19,"X")]
        } else {
            stop("Chromosome should be in 1-19, X; we see: ", paste(chr, collapse=", "))
        }
    }

    # if input_type == "male_cM" or "ave_cM", drop anything on X chromosome
    if(input_type %in% c("ave_cM", "male_cM") && any(chr == "X")) {
        positions <- positions[chr != "X"]
        chr <- chr[chr != "X"]
        warning('Omitting X chr as "', input_type, '" is NA')
    }

    if(length(positions)==0) {
        return(
            data.frame(marker=character(0),
                       chr=character(0),
                       cM_coxV3_ave=numeric(0),
                       cM_coxV3_female=numeric(0),
                       cM_coxV3_male=numeric(0),
                       bp_grcm39=numeric(0),
                       Mbp_grcm39=numeric(0))
        )
    }

    # make sure there are marker names
    for(i in seq_along(positions)) {
        if(is.null(names(positions[[i]]))) {
            names(positions[[i]]) <- paste0("pos", names(positions)[i], "_", seq_along(positions[[i]]))
        }
    }

    # convert cox map to lists
    cmap <- mmconvert::coxmap
    cmap$Mbp_grcm39 <- cmap$bp_grcm39/1e6

    cmap_bp <- map_df_to_list(cmap, pos_column="bp_grcm39")
    cmap_Mbp <- map_df_to_list(cmap, pos_column="Mbp_grcm39")
    cmap_ave <- map_df_to_list(cmap, pos_column="cM_coxV3_ave")
    cmap_female <- map_df_to_list(cmap, pos_column="cM_coxV3_female")
    cmap_male <- map_df_to_list(cmap, pos_column="cM_coxV3_male")

    cmap_input <- switch(input_type,
                         "bp"=cmap_bp,
                         "Mbp"=cmap_Mbp,
                         "ave_cM"=cmap_ave,
                         "female_cM"=cmap_female,
                         "male_cM"=cmap_male)

    # convert input
    result_bp <- interp_map(positions, cmap_input, cmap_bp)
    result_Mbp <- interp_map(positions, cmap_input, cmap_Mbp)
    result_ave <- interp_map(positions, cmap_input, cmap_ave)
    result_female <- interp_map(positions, cmap_input, cmap_female)
    result_male <- interp_map(positions, cmap_input, cmap_male)

    # combine results
    result <- cbind(map_list_to_df(result_bp),
                    Mbp=map_list_to_df(result_Mbp)$pos,
                    ave=map_list_to_df(result_ave)$pos,
                    female=map_list_to_df(result_female)$pos,
                    male=map_list_to_df(result_male)$pos)

    # reorder columns
    result <- result[,c("marker", "chr", "ave", "female", "male",
                        "pos", "Mbp")]
    colnames(result) <- colnames(cmap)

    # sort the output by genomic position
    result <- result[order(factor(result$chr, levels=c(1:19,"X")),
                           result$bp_grcm39),,drop=FALSE]

    # check whether values are out of range
    ranges <- tapply(result$bp_grcm39, result$chr, range, na.rm=TRUE)
    bp_out_of_range(ranges)

    result
}
