# internal function (duplicated from qtl2convert package)
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
