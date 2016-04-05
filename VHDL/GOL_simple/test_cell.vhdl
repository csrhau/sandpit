package gol_types is
  type neighbourhood_t is array (7 downto 0) of integer range 0 to 1;
end package gol_types;

---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gol_types.all;

entity test_cell is 
end test_cell;

architecture behavioural of test_cell is
   signal clock : std_logic;
   signal alive: integer range 0 to 1 := 0;
   signal neighbours: neighbourhood_t;

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

begin

  cell_0: cell generic map (begin_alive => 0) 
                  port map (clock, 
                            neighbours(0), neighbours(1), neighbours(2),
                            neighbours(3),                neighbours(4),
                            neighbours(5), neighbours(6), neighbours(7),
                            alive);

  -- Starts dead test
  process begin
     -- 0 ns
    neighbours <= (0, 0, 0, 0, 0, 0, 0, 0);
    clock <= '0';
    wait for 1 ns;
    assert alive = 0
      report "Cell should start as dead" severity error;
    clock <= '1';
    wait for 1 ns;
    assert alive = 0
      report "Cell should remain dead" severity error;

    -- Single and Dual bit dead inside tests (x8) (single tests occur on overlap)
    for i in 0 to 7 loop
      for j in 0 to 7 loop
        clock <= '0';
        wait for 1 ns;
        neighbours <= (others => 0);
        neighbours(i) <= 1;
        neighbours(j) <= 1;
        wait for 1 ns;
           clock <= '1';
        wait for 1 ns;
        assert alive = 0
          report "Cell should remain dead with neighbours != 3" severity error;

      end loop;
    end loop;

    clock <= '0';
    wait for 1 ns;
    neighbours <= (1, 1, 1, 0, 0, 0, 0, 0);
    clock <= '1';
    wait for 1 ns;
    assert alive = 1
      report "Cell should come to life with 3 neighbours" severity error;

    clock <= '0';
    wait for 1 ns;
    neighbours <= (1, 1, 1, 0, 0, 0, 0, 0);
    clock <= '1';
    wait for 1 ns;
    assert alive = 1
      report "Cell should remain alive with 3 neighbours" severity error;

    clock <= '0';
    wait for 1 ns;
    neighbours <= (1, 1, 0, 0, 0, 0, 0, 0);
    clock <= '1';
    wait for 1 ns;
    assert alive = 1
      report "Cell should remain alive with 2 neighbours" severity error;

    clock <= '0';
    wait for 1 ns;
    neighbours <= (1, 0, 0, 0, 0, 0, 0, 0);
    clock <= '1';
    wait for 1 ns;
    assert alive = 0
      report "Cell should die with 2 neighbours" severity error;

    clock <= '0';
    wait for 1 ns;
    neighbours <= (1, 0, 1, 0, 0, 1, 0, 0);
    clock <= '1';
    wait for 1 ns;
    assert alive = 1
      report "Cell should regenerate with 3 neighbours" severity error;

    wait;
  end process;

end behavioural;
