all: test_array.gtw

test_array.o: test_array.vhdl
	ghdl -a $<

test_array: test_array.o
	ghdl -m $@

test_array.gtw: test_array
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.gtw
	rm -rf ./test_array
