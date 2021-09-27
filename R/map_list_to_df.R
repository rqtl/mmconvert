#' Marker map list to data frame
#'
#' Convert a marker map organized as a list to a data frame
#'
#' @param map_list List of vectors containing marker positions
#'
#' @param chr_column Name of the chromosome column in the output
#'
#' @param pos_column Name of the position column in the output
#'
#' @param marker_column Name of the marker column in the output.
#' If NULL, just put them as row names.
#'
#' @seealso [map_df_to_list()]
#'
#' @return A data frame with the marker positions.
#'
#' @examples
#' library(qtl2)
#' iron <- read_cross2(system.file("extdata", "iron.zip", package="qtl2"))
#' iron_map <- map_list_to_df(iron$gmap)
#'
#' @export
map_list_to_df <-
    function(map_list, chr_column="chr", pos_column="pos", marker_column="marker")
{
    nmar <- vapply(map_list, length, 1) # no. markers per chromosome

    markers <- unlist(lapply(map_list, names))

    result <- data.frame(chr=rep(names(map_list), nmar),
                         pos=unlist(map_list),
                         marker=markers,
                         stringsAsFactors=FALSE)
    rownames(result) <- markers

    names(result)[1] <- chr_column
    names(result)[2] <- pos_column
    if(is.null(marker_column))
        result <- result[,-3,drop=FALSE]
    else
        names(result)[3] <- marker_column

    result
}
