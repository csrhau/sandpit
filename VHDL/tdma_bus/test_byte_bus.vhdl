library ieee;
use ieee.std_logic_1164.all;


entity test_byte_bus is
end test_byte_bus;


architecture behavioural of test_byte_bus is
  component byte_bus is 
    generic (
      bus_length : natural
    );
    port ( 
      clock : in std_logic;
      data : out std_logic_vector(7 downto 0)
    );
  end component byte_bus;

  signal clock: std_logic;
  signal data_bus : std_logic_vector(7 downto 0);

begin
  BBUS: byte_bus generic map(4)
                 port map (clock, data_bus);


  process
  begin

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "00000000"
      report "Data should match writer position" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "00000001"
      report "Data should match writer position" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "00000010"
      report "Data should match writer position" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "00000011"
      report "Data should match writer position" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert data_bus = "00000000"
      report "Writer should cycle back to start" severity error;

    wait;
  end process;
end behavioural;
