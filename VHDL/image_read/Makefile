all: test_read_funcs

pgm_types.o: pgm_types.vhdl
	ghdl -a $<

read_funcs.o: read_funcs.vhdl pgm_types.o
	ghdl -a $<

test_read_funcs.o: test_read_funcs.vhdl read_funcs.o
	ghdl -a $<

test_read_funcs: test_read_funcs.o
	ghdl -m $@


clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_read_funcs
