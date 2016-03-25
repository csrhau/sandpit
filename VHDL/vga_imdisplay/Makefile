all: test_vga_rom.ghw test_vga_sequencer.ghw test_init_funcs.ghw test_vga_system.ghw

memory_types.o: memory_types.vhdl
	ghdl -a $<

vga_rom.o: vga_rom.vhdl memory_types.o
	ghdl -a $<

test_vga_rom.o: test_vga_rom.vhdl vga_rom.o memory_types.o
	ghdl -a $<

test_vga_rom: test_vga_rom.o
	ghdl -m $@

test_vga_rom.ghw: test_vga_rom
	./$< --wave=$@

init_funcs.o: init_funcs.vhdl memory_types.o
	ghdl -a $<

test_init_funcs.o: test_init_funcs.vhdl init_funcs.o
	ghdl -a $<

test_init_funcs: test_init_funcs.o
	ghdl -m $@

test_init_funcs.ghw: test_init_funcs
	./$< --wave=$@

vga_sequencer.o: vga_sequencer.vhdl  memory_types.o
	ghdl -a $<

test_vga_sequencer.o: test_vga_sequencer.vhdl vga_sequencer.o 
	ghdl -a $<

test_vga_sequencer: test_vga_sequencer.o
	ghdl -m $@

test_vga_sequencer.ghw: test_vga_sequencer
	./$< --wave=$@


vga_system.o: vga_system.vhdl memory_types.o vga_sequencer.o vga_rom.o init_funcs.o
	ghdl -a $<

test_vga_system.o: test_vga_system.vhdl vga_system.o
	ghdl -a $<

test_vga_system: test_vga_system.o
	ghdl -m $@

test_vga_system.ghw: test_vga_system
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw *.vcd
	rm -rf ./test_vga_rom
	rm -rf ./test_init_funcs
	rm -rf ./test_vga_sequencer
