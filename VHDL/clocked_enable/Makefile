all: test_clocked_enable.ghw

clocked_enable.o: clocked_enable.vhdl
	ghdl -a $<

test_clocked_enable.o: test_clocked_enable.vhdl clocked_enable.o
	ghdl -a $<

test_clocked_enable: test_clocked_enable.o
	ghdl -m $@

test_clocked_enable.ghw: test_clocked_enable
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_clocked_enable
