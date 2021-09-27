#' @name coxmap
#' @aliases coxmap
#'
#' @title Mouse genetic map based on Cox et al. \doi{10.1534/genetics.109.105486},
#' revised for mouse genome build 39.
#'
#' @description A data frame with rows being markers and six columns: marker name, chromosome,
#' sex-averaged cM position, female cM position, male cM position, and build 39 basepair position.
#'
#' @details
#' Genetic maps were re-estimated after reordering markers according to their position
#' in mouse genome build 39. See <https://github.com/kbroman/CoxMapV3>.
#' Markers were shifted so that 0 cM corresponds to 3 Mbp, using the chromosome- and
#' sex-specific recombination rate.
#'
#' @source <https://github.com/kbroman/CoxMapV3>
#'
#' @keywords datasets
#'
#' @examples
#' data(coxmap)
NULL
