.PHONY: doc test all

all: doc README.md

README.md: README.Rmd
	R -e "knitr::knit('$<')"

# build package documentation
doc:
	R -e 'devtools::document()'

# run tests
test:
	R -e 'devtools::test()'
