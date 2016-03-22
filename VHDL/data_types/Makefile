all: test_array.ghw test_slv.ghw test_records.ghw

test_array.o: test_array.vhdl
	ghdl -a $<

test_array: test_array.o
	ghdl -m $@

test_array.ghw: test_array
	./$< --wave=$@

test_slv.o: test_slv.vhdl
	ghdl -a $<

test_slv: test_slv.o
	ghdl -m $@

test_slv.ghw: test_slv
	./$< --wave=$@

test_records.o: test_records.vhdl
	ghdl -a $<

test_records: test_records.o
	ghdl -m $@

test_records.ghw: test_records
	./$< --wave=$@


clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_array
	rm -rf ./test_slv
	rm -rf ./test_records
