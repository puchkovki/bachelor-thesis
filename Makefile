SHELL = /bin/bash

AUX_DIR = aux
OUT_DIR = out
SRC_DIR = src
FIG_DIR = fig

PDFLATEX = pdflatex -file-line-error -interaction=nonstopmode -halt-on-error -output-directory=$(AUX_DIR) $< \
 | grep ".*:[0-9]*:.*"; exit $${PIPESTATUS[0]}

XELATEX = xelatex -synctex=1 -file-line-error -interaction=nonstopmode -halt-on-error -output-directory=$(AUX_DIR) $< \
 | grep ".*:[0-9]*:.*"; exit $${PIPESTATUS[0]}

.PHONY: all
all: $(OUT_DIR)/thesis.pdf

$(OUT_DIR)/thesis.pdf: $(OUT_DIR)/%.pdf : $(SRC_DIR)/%.tex $(SRC_DIR)/%.bib $(wildcard $(FIG_DIR)/*) $(wildcard $(SRC_DIR)/*.tex)
	@echo "==>" $@
	@mkdir -p $(AUX_DIR)
	@$(call PDFLATEX)
	@biber -q $(AUX_DIR)/$(notdir $(basename $<))
	@$(call PDFLATEX)
	@mkdir -p $(OUT_DIR)
	@mv $(AUX_DIR)/$(notdir $@) $(OUT_DIR)

$(OUT_DIR)/review.pdf $(OUT_DIR)/advisor_review.pdf: $(OUT_DIR)/%.pdf : $(SRC_DIR)/%.tex
	@echo "==>" $@
	@mkdir -p $(AUX_DIR)
	@$(call PDFLATEX)
	@mkdir -p $(OUT_DIR)
	@mv $(AUX_DIR)/$(notdir $@) $(OUT_DIR)

$(OUT_DIR)/presentation.pdf $(OUT_DIR)/presentation-en.pdf: $(OUT_DIR)/%.pdf : $(SRC_DIR)/%.tex $(wildcard $(FIG_DIR)/*)
	@echo "==>" $@
	@mkdir -p $(AUX_DIR)
	@$(call XELATEX)
	@$(call XELATEX)
	@mkdir -p $(OUT_DIR)
	@mv $(AUX_DIR)/$(notdir $@) $(OUT_DIR)

.PHONY: clean
clean:
	@rm -f $(AUX_DIR)/*
	@rm -f $(OUT_DIR)/*
