RSCRIPT= Rscript --vanilla
CORPUS_LIB= src/corpus.so
BUILT_VIGNETTES= vignettes/chinese.Rmd vignettes/unicode.Rmd

all: $(CORPUS_LIB) $(BUILT_VIGNETTES)

$(CORPUS_LIB):
	$(RSCRIPT) -e 'devtools::compile_dll(".")'

README: README.md
	sed -e '/^\[!\[/d' $< > $@

vignettes/chinese.Rmd: vignettes/src/chinese.Rmd
	$(RSCRIPT) -e 'devtools::load_all("."); setwd("vignettes"); knitr::knit("src/chinese.Rmd")'
	mv vignettes/chinese.md $@ && touch -r $< $@

vignettes/unicode.Rmd: vignettes/src/unicode.Rmd
	$(RSCRIPT) -e 'devtools::load_all("."); setwd("vignettes"); knitr::knit("src/unicode.Rmd")'
	mv vignettes/unicode.md $@ && touch -r $< $@

bench:
	$(RSCRIPT) -e 'devtools::load_all("."); source("bench/bench.R")'

clean:
	$(RSCRIPT) -e 'devtools::clean_dll(".")'
	rm -rf $(BUILT_VIGNETTES)

check: $(CORPUS_LIB)
	$(RSCRIPT) -e 'devtools::test(".")'

dist: $(BUILT_VIGNETTES) README
	mkdir -p dist && cd dist && R CMD build ..

doc: $(BUILT_VIGNETTES) README

install: $(CORPUS_LIB)
	$(RSCRIPT) -e 'devtools::install(".")'

.PHONY: all bench clean check dist doc install
