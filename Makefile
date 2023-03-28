.PHONY: doc test all

all: doc README.md data/MUGAmaps.RData

README.md: README.Rmd
	R -e "knitr::knit('$<')"

# build package documentation
doc:
	R -e 'devtools::document()'

# run tests
test:
	R -e 'devtools::test()'

data/MUGAmaps.RData: inst/scripts/grab_muga_array_annot.R
	R -e "source('$<')"

data/coxmap.RData: inst/scripts/smooth_coxmaps.R
	R -e "source('$<')"
