all: test_ram.ghw test_file_ram.ghw

ram.o: ram.vhdl 
	ghdl -a $<

test_ram.o: test_ram.vhdl ram.o 
	ghdl -a $<

test_ram: test_ram.o
	ghdl -m $@

test_ram.ghw: test_ram
	./$< --wave=$@

file_ram.o: file_ram.vhdl 
	ghdl -a $<

test_file_ram.o: test_file_ram.vhdl file_ram.o 
	ghdl -a $<

test_file_ram: test_file_ram.o
	ghdl -m $@

test_file_ram.ghw: test_file_ram
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_ram
	rm -rf ./test_file_ram
