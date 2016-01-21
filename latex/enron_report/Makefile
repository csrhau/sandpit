.PHONY: main.pdf all clean

AUTO_DIR := auto/data
ENRON_FILE := local_data/graph.json

all: main.pdf

#Custom Build Rules
AUTO_FILES += $(AUTO_DIR)/rates.csv
$(AUTO_DIR)/rates.csv: $(ENRON_FILE) scripts/rates.rb
	$(maketargetdir)
	scripts/rates.rb -d $< -o $@

define maketargetdir
		@echo $@
		mkdir -p $(dir $@) > /dev/null 2>&1
endef


main.pdf: main.tex $(AUTO_FILES)
		latexmk -pdf -f  -use-make $<

clean:
		latexmk -C
		rm -rf $(AUTO_DIR)
		rm -f *.fls
		rm -f *.log

debug:
		@echo $(TABLE_TEX_FILES)
		@echo $(TABLE_DATA_FILES)


# Custom Build Rules - TABLES, left just in case needed
TABLE_DIR := tables
TABLE_DATA_FILES := $(wildcard $(TABLE_DIR)/*.csv)
TABLE_TEX_FILES := $(TABLE_DATA_FILES:$(TABLE_DIR)/%.csv=$(AUTO_DIR)/$(TABLE_DIR)/%.tex) 

$(AUTO_DIR)/$(TABLE_DIR)/%.tex: $(TABLE_DIR)/%.csv
		$(maketargetdir)
		cat $< > $@

