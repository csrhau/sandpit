all: test_sequencer.ghw  test_gol_processor.ghw test_gol_ram.ghw

gol_processor.o: gol_processor.vhdl
	ghdl -a $<

test_gol_processor.o: test_gol_processor.vhdl gol_processor.o
	ghdl -a $<

test_gol_processor: test_gol_processor.o
	ghdl -m $@

test_gol_processor.ghw: test_gol_processor
	./$< --wave=$@

gol_ram.o: gol_ram.vhdl
	ghdl -a $<

test_gol_ram.o: test_gol_ram.vhdl gol_ram.o
	ghdl -a $<

test_gol_ram: test_gol_ram.o
	ghdl -m $@

test_gol_ram.ghw: test_gol_ram
	./$< --wave=$@

glu.o: glu.vhdl
	ghdl -a $<

sequencer.o: sequencer.vhdl
	ghdl -a $<

test_sequencer.o: test_sequencer.vhdl sequencer.o
	ghdl -a $<

test_sequencer: test_sequencer.o
	ghdl -m $@

test_sequencer.ghw: test_sequencer
	./$< --wave=$@



clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_gol_processor
	rm -rf ./test_gol_ram
	rm -rf ./test_sequencer
