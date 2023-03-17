#' @name MUGAmaps
#' @aliases MUGAmaps
#'
#' @title Array annotation information for the mouse MUGA arrays
#' in mouse genome build 39.
#'
#' @description A list of four data frames with annotation information for the four MUGA arrays,
#' GigaMUGA ("gm"), MegaMUGA ("mm"), MiniMUGA ("mini") and the original MUGA ("muga").
#' Each has columns marker, chromosome, build 39 basepair position, and sex-averaged cM position (in Cox Map v3).
#'
#' @details
#' SNP probes for the MUGA arrays were blasted against mouse genome
#' build GRCm39 and locations interpolated using revised Cox maps.
#' See <https://github.com/kbroman/MUGAarrays> for the array
#' annotations and <https://github.com/kbroman/CoxMapV3> for the
#' genetic maps. Note that for the genetic map locations, markers were
#' shifted so that 0 cM corresponds to 3 Mbp, using the chromosome-
#' and sex-specific recombination rate.
#'
#' @source <https://github.com/kbroman/MUGAarrays>
#'
#' @keywords datasets
#'
#' @examples
#' data(MUGAmaps)
NULL
