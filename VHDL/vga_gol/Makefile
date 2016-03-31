all: test_gol_processor.ghw


gol_processor.o: gol_processor.vhdl
	ghdl -a $<

test_gol_processor.o: test_gol_processor.vhdl gol_processor.o
	ghdl -a $<

test_gol_processor: test_gol_processor.o
	ghdl -m $@

test_gol_processor.ghw: test_gol_processor
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_gol_processor
