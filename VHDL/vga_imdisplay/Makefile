all: test_vga_controller.ghw


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
	rm -rf ./test_vga_controller
