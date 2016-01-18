.PHONY: main.pdf all clean

all: main.pdf

AUTO_DIR := auto

# Custom Build Rules - TABLES
TABLE_DIR := tables
TABLE_DATA_FILES := $(wildcard $(TABLE_DIR)/*.csv)
TABLE_TEX_FILES := $(TABLE_DATA_FILES:$(TABLE_DIR)/%.csv=$(AUTO_DIR)/$(TABLE_DIR)/%.tex)

$(AUTO_DIR)/$(TABLE_DIR)/%.tex: $(TABLE_DIR)/%.csv
		$(maketargetdir)
		cat $< > $@

# Custom Build Rules - CHART_DATA FILES
CHART_DATA_DIR := data

$(AUTO_DIR)/$(CHART_DATA_DIR)/rates.csv: local_data/graph.json scripts/rates.rb
	$(maketargetdir)
	scripts/rates.rb -d $< -o $@

define maketargetdir
		@echo $@
		mkdir -p $(dir $@) > /dev/null 2>&1
endef

main.pdf: main.tex $(TABLE_TEX_FILES)
		latexmk -f -pdf $<

clean:
		latexmk -C
		rm -rf $(AUTO_DIR)
		rm *.fls
		rm *.log

debug:
		@echo $(TABLE_TEX_FILES)
		@echo $(TABLE_DATA_FILES)
