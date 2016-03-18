all: test_rom.gtw

rom.o: rom.vhdl
	ghdl -a $<

test_rom.o: test_rom.vhdl rom.o
	ghdl -a $<

test_rom: test_rom.o
	ghdl -m $@

test_rom.gtw: test_rom
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.gtw
	rm -rf ./test_rom
