all: test_test_utils.ghw

test_utils.o: test_utils.vhdl 
	ghdl -a $<

test_test_utils.o: test_test_utils.vhdl test_utils.o 
	ghdl -a $<

test_test_utils: test_test_utils.o
	ghdl -m $@

test_test_utils.ghw: test_test_utils
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_test_utils
