package gol_types is
  constant ROWS: integer := 5;
  constant COLS: integer := 5;
  type board_state is array(ROWS downto 0, COLS downto 0) of integer range 0 to 1;
  constant GLIDER: board_state := ((0, 0, 0, 0, 0, 0),
                                   (0, 0, 1, 0, 0, 0),
                                   (0, 0, 0, 1, 0, 0),
                                   (0, 1, 1, 1, 0, 0),
                                   (0, 0, 0, 0, 0, 0),
                                   (0, 0, 0, 0, 0, 0));

end package gol_types;

---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.gol_types.all;

entity test_multicell_boundaries is 
end test_multicell_boundaries;

architecture behavioural of test_multicell_boundaries is
   signal clock : std_logic;

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


  function print_state(mat: board_state)
    return integer is
    variable l : line;  
  begin
    writeline (output, l);
    for i in ROWS downto 0 loop
      for j in COLS downto 0 loop
        write (l, ' ');
        write (l, mat(i,j));
      end loop;
      writeline (output, l);
    end loop;
    return 0; 
  end print_state;

  signal interconnect: board_state;
 
begin

  ROW:
  for row in 0 to ROWS generate
    COL:
    for col in 0 to COLS generate
      cellx: cell generic map (begin_alive => GLIDER(row, col))
                     port map (clock, 
                             interconnect((row - 1) mod ROWS, (col - 1) mod COLS), interconnect((row - 1) mod ROWS, col), interconnect((row - 1) mod ROWS, (col + 1) mod COLS),
                             interconnect(row,              (col - 1) mod COLS),                                 interconnect(row,              (col + 1) mod COLS),
                             interconnect((row + 1) mod ROWS, (col - 1) mod COLS), interconnect((row + 1) mod ROWS, col), interconnect((row + 1) mod ROWS, (col + 1) mod COLS),
                             interconnect(row, col));
    end generate COL; -- COLS
  end generate ROW; -- ROWS


  -- Starts dead test
  process
    variable dummy: integer range 0 to 1;
    constant T0: board_state := GLIDER;
    constant T1: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 1, 0, 1, 0, 0),
                                 (0, 0, 1, 1, 0, 0),
                                 (0, 0, 1, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0));

    constant T2: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 1, 0, 0),
                                 (0, 1, 0, 1, 0, 0),
                                 (0, 0, 1, 1, 0, 0),
                                 (0, 0, 0, 0, 0, 0));

    constant T3: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 0, 1, 0, 0, 0),
                                 (0, 0, 0, 1, 1, 0),
                                 (0, 0, 1, 1, 0, 0),
                                 (0, 0, 0, 0, 0, 0));

    -- T4 is the end of a cycle - glider is period 4. 
    constant T4: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 1, 0, 0),
                                 (0, 0, 0, 0, 1, 0),
                                 (0, 0, 1, 1, 1, 0),
                                 (0, 0, 0, 0, 0, 0));
begin
    assert interconnect = T0
      report "Board should start as glider" severity error;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T1
      report "Board should proceed to state T1" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T2
      report "Board should proceed to state T2" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T3
      report "Board should proceed to state T3" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T4
      report "Board should proceed to state T4" severity error;

    -- At this point we've proven the glider progresses through one of its cycles, 
    -- but we still need to see it navigate the entire space and return to start.
    -- This takes an extra 16 steps.

    for i in 1 to 16 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    assert interconnect = T0
        report "Board should proceed to state T4" severity error;

    wait;
  end process;

end behavioural;
