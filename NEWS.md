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
