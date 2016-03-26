library ieee;
use ieee.std_logic_1164.all;

entity test_bus_writer is
end test_bus_writer;

architecture behavioural of test_bus_writer is
  component bus_writer is 
    generic (
      bus_length : natural;
      bus_index : natural;
      value : std_logic_vector(7 downto 0)
    );
    port ( 
      clock : in std_logic;
      data : out std_logic_vector(7 downto 0)
    );
  end component bus_writer;

  signal clock : std_logic;
  signal data_bus : std_logic_vector(7 downto 0);

begin
  WRITER: bus_writer generic map (
                       bus_length => 3,
                       bus_index => 1, --- The middle one
                       value => "11111111"
                     )
                     port map (
                      clock,
                      data_bus
                     );

  process
  begin
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "ZZZZZZZZ"
      report "No data should be recieved on tick 0" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "11111111"
      report "Data should be recieved on tick 1" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "ZZZZZZZZ"
      report "No data should be recieved on tick 2" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "ZZZZZZZZ"
      report "No data should be recieved on tick 3" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "11111111"
      report "Data should be recieved on tick 4" severity error;

    wait;
  end process;
end behavioural;
