### mmconvert

[![R-CMD-check](https://github.com/rqtl/mmconvert/workflows/R-CMD-check/badge.svg)](https://github.com/rqtl/mmconvert/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/mmconvert)](https://cran.r-project.org/package=mmconvert)

[Karl Broman](https://kbroman.org)

R package to convert mouse genome positions between build 39 physical locations and
the [Cox genetic map](https://doi.org/10.1534/genetics.109.105486) positions.
(See the [Cox map version 3](https://github.com/kbroman/CoxMapV3), updated
for the build 39 physical map.)

The package is a reimplementation of part of the basic functionality
of the [mouse map
converter](https://churchill-lab.jax.org/mousemapconverter) web
service from [Gary Churchill's
group](https://churchill-lab.jax.org/website/) at the [Jackson
Lab](https://jax.org).

---

### Installation

Install the mmconvert package from
[GitHub](https://github.com/rqtl/mmconvert) using the
[remotes package](https://remotes.r-lib.org):

    install.packages("remotes")
    remotes::install_github("rqtl/mmconvert")

---

### Usage

[mmconvert](https://github.com/rqtl/mmconvert) contains two functions:
`mmconvert()` and `cross2_to_grcm39()`.

#### `mmconvert()`

`mmconvert()` takes a set of positions as input, plus and
indication of whether they are basepairs or Mbp (in build 39) or
sex-averaged, female, or male cM (from the [revised Cox genetic
map](https://github.com/kbroman/CoxMapV3)).

The input positions can be character strings like `"chr:position"`.


```r
input_char <- c(rs13482072="14:6738536", rs13482231="14:67215850", gnf14.117.278="14:121955310")
```

Or they can be a list of marker positions, separated by chromosome.


```r
input_list <- list("14"=c(rs13482072=6738536, rs13482231=67215850, gnf14.117.278=121955310))
```

Or they can be a data frame with chromosome IDs as the first column
and positions as the second column. Marker names can either be in a
third column or included as row names.


```r
input_df <- data.frame(chr=c(14,14,14),
               pos=c(6738536, 67215850, 121955310),
               marker=c("rs13482072", "rs13482231", "gnf14.117.278"))
```

For either of these cases, the output is a data frame with seven
columns: marker, chromosome, sex-averaged cM, female cM, male cM,
basepairs, and mega-basepairs.


```r
library(mmconvert)
mmconvert(input_df)
```

```
##                      marker chr cM_coxV3_ave cM_coxV3_female cM_coxV3_male bp_grcm39 Mbp_grcm39
## rs13482072       rs13482072  14      0.36342         0.39000       0.33856   6738536   6.738536
## rs13482231       rs13482231  14     28.53962        34.47777      22.66820  67215850  67.215850
## gnf14.117.278 gnf14.117.278  14     59.35826        64.29811      54.71468 121955310 121.955310
```

If you want to give the input positions in Mbp rather than basepairs,
use the argument `input_type="Mbp"`.


```r
input_df$pos <- input_df$pos / 1e6
mmconvert(input_df, input_type="Mbp")
```

```
##                      marker chr cM_coxV3_ave cM_coxV3_female cM_coxV3_male bp_grcm39 Mbp_grcm39
## rs13482072       rs13482072  14      0.36342         0.39000       0.33856   6738536   6.738536
## rs13482231       rs13482231  14     28.53962        34.47777      22.66820  67215850  67.215850
## gnf14.117.278 gnf14.117.278  14     59.35826        64.29811      54.71468 121955310 121.955310
```

The input positions can also be provided in sex-averaged, female, or male cM.
But note that the bp or Mbp positions must be in mouse genome build
39, and cM positions must be according to the
[Cox Map V3](https://github.com/kbroman/CoxMapV3).

#### `cross2_to_grcm39()`

`cross2_to_grcm39()` takes a cross2 object from
[R/qtl2](https://kbroman.org/qtl2/) with mouse genotype data from one
of the MUGA arrays and converts it to mouse genome build GRCm39, by
possibly subsetting the markers, reordering them according to the
GRCm39 build, and plugging in GRCm39 Mbp positions and the revised Cox
genetic map. See <https://github.com/kbroman/MUGAarrays> for the
MUGA array annotations and <https://github.com/kbroman/CoxMapV3> for
the revised Cox genetic map.


```r
file <- paste0("https://raw.githubusercontent.com/rqtl/",
               "qtl2data/main/DOex/DOex.zip")

library(qtl2)
DOex <- read_cross2(file)

DOex_rev <- cross2_to_grcm39(DOex)
```

---

#### License

Licensed under [GPL-3](https://www.r-project.org/Licenses/GPL-3).
