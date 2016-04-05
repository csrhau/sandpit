all: test_mux.ghw


mux.o: mux.vhdl 
	ghdl -a $<

test_mux.o: test_mux.vhdl mux.o 
	ghdl -a $<

test_mux: test_mux.o
	ghdl -m $@

test_mux.ghw: test_mux
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_mux
