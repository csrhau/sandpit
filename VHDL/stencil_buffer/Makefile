all: test_ring_buffer.ghw test_stencil_buffer.ghw

ring_buffer.o: ring_buffer.vhdl
	ghdl -a $<

test_ring_buffer.o: test_ring_buffer.vhdl ring_buffer.o
	ghdl -a $<

test_ring_buffer: test_ring_buffer.o
	ghdl -m $@

test_ring_buffer.ghw: test_ring_buffer
	./$< --wave=$@

stencil_buffer.o: stencil_buffer.vhdl
	ghdl -a $<

test_stencil_buffer.o: test_stencil_buffer.vhdl stencil_buffer.o
	ghdl -a $<

test_stencil_buffer: test_stencil_buffer.o
	ghdl -m $@

test_stencil_buffer.ghw: test_stencil_buffer
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_ring_buffer
	rm -rf ./test_stencil_buffer
