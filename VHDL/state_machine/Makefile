all: test_three_multiple.ghw

three_multiple_types.o: three_multiple_types.vhdl
	ghdl -a $<

three_multiple.o: three_multiple.vhdl three_multiple_types.o
	ghdl -a $<

test_three_multiple.o: test_three_multiple.vhdl three_multiple.o three_multiple_types.o
	ghdl -a $<

test_three_multiple: test_three_multiple.o
	ghdl -m $@

test_three_multiple.ghw: test_three_multiple
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_three_multiple
