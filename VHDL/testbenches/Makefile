all: testbench.ghw

testbench.o: testbench.vhdl
	ghdl -a $<

testbench: testbench.o
	ghdl -m $@

testbench.ghw: testbench
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./testbench
