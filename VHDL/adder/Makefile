all: test_adder.ghw

adder.o: adder.vhdl
	ghdl -a $<

test_adder.o: test_adder.vhdl adder.o
	ghdl -a $<

test_adder: test_adder.o
	ghdl -m $@

test_adder.ghw: test_adder
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_adder
