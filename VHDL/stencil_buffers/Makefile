all: test_ring_buffer.ghw test_ripple_buffer.ghw

ring_buffer.o: ring_buffer.vhdl
	ghdl -a $<

test_ring_buffer.o: test_ring_buffer.vhdl ring_buffer.o
	ghdl -a $<

test_ring_buffer: test_ring_buffer.o
	ghdl -m $@

test_ring_buffer.ghw: test_ring_buffer
	./$< --wave=$@

ripple_buffer.o: ripple_buffer.vhdl
	ghdl -a $<

test_ripple_buffer.o: test_ripple_buffer.vhdl ripple_buffer.o
	ghdl -a $<

test_ripple_buffer: test_ripple_buffer.o
	ghdl -m $@

test_ripple_buffer.ghw: test_ripple_buffer
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_ring_buffer
	rm -rf ./test_ripple_buffer
