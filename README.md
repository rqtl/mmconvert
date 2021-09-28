### mmconvert

[![R-CMD-check](https://github.com/rqtl/mmconvert/workflows/R-CMD-check/badge.svg)](https://github.com/rqtl/mmconvert/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/mmconvert)](https://cran.r-project.org/package=mmconvert)

[Karl Broman](https://kbroman.org)

Convert mouse genome positions between build 39 physical locations and
the [Cox genetic map](https://doi.org/10.1534/genetics.109.105486) positions.

---

### Installation

Install the mmconvert package from
[GitHub](https://github.com/rqtl/mmconvert) using the
[remotes package](https://remotes.r-lib.org):

    install.packages("remotes")
    remotes::install_github("mmconvert")

---

### Usage

[mmconvert](https://github.com/rqtl/mmconvert) contains a single
function `mmconvert()`. It takes a set of positions as input, plus and
indication of whether they are basepairs or Mbp (in build 37) or
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
## rs13482072       rs13482072  14      0.36341         0.38999       0.33855   6738536   6.738536
## rs13482231       rs13482231  14     28.53961        34.47776      22.66819  67215850  67.215850
## gnf14.117.278 gnf14.117.278  14     59.35825        64.29810      54.71467 121955310 121.955310
```

---

#### License

Licensed under [GPL-3](https://www.r-project.org/Licenses/GPL-3).
