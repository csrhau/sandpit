all: test_bus_writer.ghw test_byte_bus.ghw


bus_writer.o: bus_writer.vhdl
	ghdl -a $<

test_bus_writer.o: test_bus_writer.vhdl bus_writer.o
	ghdl -a $<

test_bus_writer: test_bus_writer.o
	ghdl -m $@

test_bus_writer.ghw: test_bus_writer
	./$< --wave=$@

byte_bus.o: byte_bus.vhdl bus_writer.o
	ghdl -a $<


test_byte_bus.o: test_byte_bus.vhdl byte_bus.o
	ghdl -a $<

test_byte_bus: test_byte_bus.o
	ghdl -m $@

test_byte_bus.ghw: test_byte_bus
	./$< --wave=$@



clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_bus_writer
	rm -rf ./test_byte_bus
