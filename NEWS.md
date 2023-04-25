## mmconvert 0.10 (2023-04-25)

- Omit X chr positions if `input_type` is `"ave_cM"` or `"male_cM"`
  (Issue #9)


## mmconvert 0.8 (2023-03-29)

- Small changes for CRAN submission.


## mmconvert 0.6 (2023-03-28)

- Added dataset `grcm39_chrlen` with lengths of GRCm39 chromosomes
  in basepairs.

- Revised mmconvert to give warnings if inferred positions are outside
  of the range of chromosomes in GRCm39. (Issue #7)

- In `cross2_to_grcm39()` when using "guess", only pick the GM/MM
  combination if it gives >20 additional markers than either GM or MM
  on their own.

- Replaced the `coxmap` object with a smoothed version (using the
  R/qtl2 function `smooth_gmap()` with `alpha=0.02`), with intervals
  with 0 recombination smoothed out to allow some recombination. The `mmconvert()`
  function uses this version of the Cox maps, and so gives
  interpolated positions that are similarly smoothed.
  Included a script `smooth_coxmaps.R` that does the work.

- Revised the MUGA array datasets to use this "smoothed" version of the
  Cox maps.


## mmconvert 0.4 (2023-03-22)

- Revised Cox genetic maps, estimated using the original crimap software.

- Revised MUGAmaps, using the corrected Cox genetic maps.

- Revised `cross2_to_grcm39()` so that it will also consider that
  markers are from the combination of GigaMUGA and MegaMUGA arrays
  (Issue #6).


## mmconvert 0.2-4 (2021-10-13)

- Added a dataset with the MUGA array annotations for markers on the
  autosomes or X chromosome, with mouse build GRCm39 positions and
  the revised Cox Map genetic map locations.

- Add function `cross2_to_grcm39()` for converting an R/qtl2 cross2
  object to use the new GRCm39 mouse build and the revised Cox genetic
  map.


## mmconvert 0.1-5 (2021-09-28)

- New package
