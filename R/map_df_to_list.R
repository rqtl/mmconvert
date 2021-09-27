#' Marker map data frame to list
#'
#' Convert a marker map organized as data frame to a list
#'
#' @param map Data frame with marker map
#'
#' @param chr_column Name of the column in `map` that contains the chromosome IDs.
#'
#' @param pos_column Name of the column in `map` that contains the marker positions.
#'
#' @param marker_column Name of the column in `map` that contains
#' the marker names. If NULL, use the row names.
#'
#' @param Xchr Vector of character strings indicating the name or
#' names of the X chromosome. If NULL, assume there's no X
#' chromosome.
#'
#' @seealso [map_list_to_df()]
#'
#' @return A list of vectors of marker positions, one component per chromosome
#'
#' @examples
#' map <- data.frame(chr=c(1,1,1,  2,2,2,   "X","X"),
#'                   pos=c(0,5,10, 0,8,16,  5,20),
#'                   marker=c("D1M1","D1M2","D1M3",    "D2M1","D2M2","D2M3",   "DXM1","DXM2"))
#' map_list <- map_df_to_list(map, pos_column="pos")
#'
#' @export
map_df_to_list <-
    function(map, chr_column="chr", pos_column="cM", marker_column="marker",
             Xchr=c("x", "X"))
{
    if(is.null(marker_column)) {
        marker_column <- "qtl2tmp_marker"
        map[,marker_column] <- rownames(map)
    }
    if(!(marker_column %in% colnames(map)))
        stop('Column "', marker_column, '" not found.')
    if(!(chr_column %in% colnames(map)))
        stop('Column "', chr_column, '" not found.')
    if(!(pos_column %in% colnames(map)))
        stop('Column "', pos_column, '" not found.')

    marker <- map[,marker_column]

    chr <- map[,chr_column]
    uchr <- unique(chr)
    pos <- map[,pos_column]

    result <- split(as.numeric(pos), factor(chr, levels=uchr))
    marker <- split(marker, factor(chr, levels=uchr))
    for(i in seq(along=result))
        names(result[[i]]) <- marker[[i]]

    is_x_chr <- rep(FALSE, length(result))
    names(is_x_chr) <- names(result)
    if(!is.null(Xchr)) {
        Xchr_used <- Xchr %in% names(is_x_chr)
        if(any(Xchr_used)) {
            Xchr <- Xchr[Xchr_used]
            is_x_chr[Xchr] <- TRUE
        }
    }
    attr(result, "is_x_chr") <- is_x_chr

    result
}
