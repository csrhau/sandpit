library ieee;
use ieee.std_logic_1164.all;
use work.board_config.all;


entity board is
  generic (
    init_state : board_state
  );
  port (
    clock : in std_logic;
    state : out board_state
  );
end board;

architecture structural of board is
  component cell is 
    generic ( 
      begin_alive : integer range 0 to 1
    );
    port (
      clock : in std_logic;
      nw, nn, ne : in integer range 0 to 1;
      ww,     ee : in integer range 0 to 1;
      sw, ss, se : in integer range 0 to 1;
      alive: out integer range 0 to 1
    );
  end component;

  signal state_s : board_state; -- := init_state;

begin
  ROW:
  for row in 0 to ROWS generate
    COL:
    for col in 0 to COLS generate
      cellx: cell generic map (begin_alive => init_state(row, col))
                     port map (clock, 
                             state_s((row - 1) mod ROWS, (col - 1) mod COLS), state_s((row - 1) mod ROWS, col), state_s((row - 1) mod ROWS, (col + 1) mod COLS),
                             state_s(row,              (col - 1) mod COLS),                                 state_s(row,              (col + 1) mod COLS),
                             state_s((row + 1) mod ROWS, (col - 1) mod COLS), state_s((row + 1) mod ROWS, col), state_s((row + 1) mod ROWS, (col + 1) mod COLS),
                             state_s(row, col));
    end generate COL; -- COLS
  end generate ROW; -- ROWS

  state <= state_s;

end structural;
