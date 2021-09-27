#' Convert mouse genome positions
#'
#' Convert mouse genome positions between the build 39 physical map and the Cox genetic map.
#'
#' @param positions A set of positions, in one of three possible formats
#'   - a vector of character strings with like `"chr:position"`, with names being marker names,
#'     e.g., `c(rs13482072="14:6738536", rs13482231="14:67215850", gnf14.117.278="14:121955310")`.
#'   - a list of marker positions, each list being positions on a given chromosome,
#'     e.g., `list("14"=c(rs13482072=6738536, rs13482231=67215850, gnf14.117.278=121955310))`.
#'   - a data frame with columns chromosome, position, and marker, e.g.
#'     e.g. `data.frame(chr=c(14,14,14), pos=c(6738536, 67215850, 121955310), marker=c("rs13482072", "rs13482231", "gnf14.117.278"))`.
#'
#' @param input_type Character string indicating the type of positions provided (`"bp"`, `"Mbp"`,
#' `"ave_cM"`, `"female_cM"`, or `"male_cM"`)
#'
#' @return A data frame with the interpolated positions, with six columns: marker, chromosome,
#' basepairs, mega-basepairs, sex-averaged cM, female cM, and male cM.
#'
#' @details We use linear interpolation using the Cox map positions in
#' the object [coxmap]. For positions outside the range of the
#' markers on the Cox map, we extrapolate using the overall
#' recombination rate.
#'
#' @export
#'
#' @seealso [coxmap]

mmconvert <-
    function(positions, input_type=c("bp", "Mbp", "ave_cM", "female_cM", "male_cM"))
{
    input_type <- match.arg(input.type)

    # convert positions to data frame
    if(is.character(positions)) {
        # split at ":"
        # check each is length 2
        # pull apart chr and pos
        # names -> rownames
    }

    if(is.data.frame(positions)) { # force to list
        positions <- map_df_to_list(positions)
    }


    # convert cox map to lists
    cmap <- mmconvert::coxmap

    # convert input

    # combine results

}
