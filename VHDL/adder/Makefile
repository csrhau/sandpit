all: test_adder.gtw

adder.o: adder.vhdl
	ghdl -a $<

test_adder.o: test_adder.vhdl adder.o
	ghdl -a $<

test_adder: test_adder.o
	ghdl -m $@

test_adder.gtw: test_adder
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.gtw
	rm -rf ./test_adder
