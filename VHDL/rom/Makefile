all: test_rom.gtw

memory_types.o: memory_types.vhdl
	ghdl -a $<

rom.o: rom.vhdl memory_types.o
	ghdl -a $<

test_rom.o: test_rom.vhdl rom.o memory_types.o
	ghdl -a $<

test_rom: test_rom.o
	ghdl -m $@

test_rom.gtw: test_rom
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.gtw
	rm -rf ./test_rom
