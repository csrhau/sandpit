all: test_init_funcs

memory_types.o: memory_types.vhdl
	ghdl -a $<

init_funcs.o: init_funcs.vhdl memory_types.o
	ghdl -a $<

test_init_funcs.o: test_init_funcs.vhdl init_funcs.o
	ghdl -a $<

test_init_funcs: test_init_funcs.o
	ghdl -m $@

rom.o: rom.vhdl memory_types.o
	ghdl -a $<

test_rom.o: test_rom.vhdl rom.o memory_types.o
	ghdl -a $<

test_rom: test_rom.o
	ghdl -m $@

test_rom.ghw: test_rom
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_rom
	rm -rf ./test_init_funcs
