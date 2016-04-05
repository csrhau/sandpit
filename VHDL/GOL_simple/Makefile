all: test_board.ghw

cell.o: cell.vhdl
	ghdl -a $<

test_cell.o: test_cell.vhdl cell.o
	ghdl -a $<

test_cell: test_cell.o
	ghdl -m $@

test_cell.ghw: test_cell
	./$< --wave=$@


test_multicell.o: test_multicell.vhdl cell.o
	ghdl -a $<

test_multicell: test_multicell.o
	ghdl -m $@

test_multicell.ghw: test_multicell
	./$< --wave=$@

test_multicell_boundaries.o: test_multicell_boundaries.vhdl cell.o
	ghdl -a $<

test_multicell_boundaries: test_multicell_boundaries.o
	ghdl -m $@

test_multicell_boundaries.ghw: test_multicell_boundaries
	./$< --wave=$@

board_config.o: board_config.vhdl
	ghdl -a $<

board.o: board.vhdl board_config.o cell.o
	ghdl -a $<

test_board.o: test_board.vhdl board_config.o board.o cell.o
	ghdl -a $<

test_board: test_board.o
	ghdl -m $@

test_board.ghw: test_board
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_cell
	rm -rf ./test_multicell
	rm -rf ./test_multicell_boundaries
	rm -rf ./test_board
