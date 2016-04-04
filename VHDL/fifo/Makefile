all: test_fifo.ghw

fifo.o: fifo.vhdl
	ghdl -a $<

test_fifo.o: test_fifo.vhdl fifo.o
	ghdl -a $<

test_fifo: test_fifo.o
	ghdl -m $@

test_fifo.ghw: test_fifo
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_fifo
