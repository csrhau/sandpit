all: test_vga_rom.ghw test_vga_controller.ghw test_init_funcs.ghw test_vga_system.ghw

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

vga_controller.o: vga_controller.vhdl  memory_types.o
	ghdl -a $<

test_vga_controller.o: test_vga_controller.vhdl vga_controller.o 
	ghdl -a $<

test_vga_controller: test_vga_controller.o
	ghdl -m $@

test_vga_controller.ghw: test_vga_controller
	./$< --wave=$@


vga_system.o: vga_system.vhdl memory_types.o vga_controller.o vga_rom.o init_funcs.o
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
	rm -rf ./test_vga_controller
