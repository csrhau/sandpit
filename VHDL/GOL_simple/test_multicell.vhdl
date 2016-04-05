package gol_types is
  type grid_state is array(3 downto 0, 3 downto 0) of integer range 0 to 1;
end package gol_types;

---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.gol_types.all;

entity test_multicell is 
end test_multicell;

architecture behavioural of test_multicell is
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


  function print_state(mat: grid_state)
    return integer is
    variable l : line;  
  begin
    writeline (output, l);
    for i in 3 downto 0 loop
      for j in 3 downto 0 loop
        write (l, ' ');
        write (l, mat(i,j));
      end loop;
      writeline (output, l);
    end loop;
    return 0; 
  end print_state;


  signal interconnect: grid_state;
 
begin

  ROW:
  for ROW in 0 to 1 generate
    COL:
    for COL in 0 to 1 generate
      cell_xx: cell generic map (begin_alive => 0) 
           port map (clock, 
                     interconnect(ROW + 0, COL + 0), interconnect(ROW + 0, COL + 1), interconnect(ROW + 0, COL + 2), 
                     interconnect(ROW + 1, COL + 0),                    interconnect(ROW + 1, COL + 2), 
                     interconnect(ROW + 2, COL + 0), interconnect(ROW + 2, COL + 1), interconnect(ROW + 2, COL + 2), 
                     interconnect(ROW + 1, COL + 1));
    end generate COL;
  end generate ROW;
 
  -- Starts dead test
  process
    variable dummy: integer range 0 to 1;
  begin

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;

    assert interconnect = ((0, 0, 0, 0),
                           (0, 0, 0, 0),
                           (0, 0, 0, 0),
                           (0, 0, 0, 0))
      report "Board should start dead" severity error;


    interconnect(0, 0) <= 1;
    interconnect(0, 1) <= 1;
    interconnect(0, 2) <= 1;
    interconnect(0, 3) <= 1;


    clock <= '0';
    wait for 1 ns;
    dummy := print_state(interconnect);
    clock <= '1';
    wait for 1 ns;
    dummy := print_state(interconnect);

    -- note downto ordering
    assert interconnect = ((0, 0, 0, 0),
                           (0, 0, 0, 0),
                           (0, 1, 1, 0),
                           (1, 1, 1, 1))
      report "Board should come alive" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    dummy := print_state(interconnect);
    assert interconnect = ((0, 0, 0, 0),
                           (0, 0, 0, 0),
                           (0, 0, 0, 0),
                           (1, 1, 1, 1))
      report "Board should die back" severity error;

    interconnect(0, 0) <= 0;
    interconnect(0, 1) <= 0;
    interconnect(0, 2) <= 0;
    interconnect(0, 3) <= 0;
    interconnect(0, 0) <= 1;
    interconnect(0, 1) <= 1;
    interconnect(1, 0) <= 1;
    interconnect(3, 2) <= 1;
    interconnect(3, 3) <= 1;
    interconnect(2, 3) <= 1;

    clock <= '0';
    wait for 1 ns;
    assert interconnect = ((1, 1, 0, 0),
                           (1, 0, 0, 0),
                           (0, 0, 0, 1),
                           (0, 0, 1, 1))
      report "Board should have reset to new test pattern" severity error;
     
    dummy := print_state(interconnect);
    clock <= '1';
    wait for 1 ns;
    dummy := print_state(interconnect);
    assert interconnect = ((1, 1, 0, 0),
                           (1, 1, 0, 0),
                           (0, 0, 1, 1),
                           (0, 0, 1, 1));
 
    wait;
  end process;

end behavioural;
