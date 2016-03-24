all: test_vga_rom.ghw test_vga_controller.ghw test_init_funcs.ghw

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

vga_controller.o: vga_controller.vhdl 
	ghdl -a $<

test_vga_controller.o: test_vga_controller.vhdl vga_controller.o 
	ghdl -a $<

test_vga_controller: test_vga_controller.o
	ghdl -m $@

test_vga_controller.ghw: test_vga_controller
	./$< --wave=$@



clean: 
	rm -f *.o *.cf *.ghw *.vcd
	rm -rf ./test_vga_rom
	rm -rf ./test_init_funcs
	rm -rf ./test_vga_controller
