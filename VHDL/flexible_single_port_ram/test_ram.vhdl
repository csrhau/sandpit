library ieee;
use ieee.std_logic_1164.all;

entity test_ram is
end test_ram;

architecture behavioural  of test_ram is

  component RAM is 
    port (
      clock : in std_logic;
      write_enable : in std_logic; 
      address : in std_logic_vector;
      data_in : in std_logic_vector;
      data_out : out std_logic_vector
    );
  end component RAM;

  
  signal write_enable : std_logic; 
  signal address  : std_logic_vector(9 downto 0);
  signal data_in  : std_logic_vector(7 downto 0);
  signal data_out : std_logic_vector(7 downto 0);

  -- Just to prove types don't conflict
  signal address2 : std_logic_vector(5 downto 0);
  signal data_in2 : std_logic_vector(1 downto 0);
  signal data_out2 : std_logic_vector(1 downto 0);

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';
begin

  clock <= not clock after period/2 when finished='0';

  ramcell : RAM port map (clock, write_enable, address, data_in, data_out);
  ramcell2 : RAM port map (clock, write_enable, address2, data_in2, data_out2);
  process
  begin

    address <= "0000000000";
    address2 <= "000000";
    write_enable <= '1';
    data_in <= "01010101";
    data_in2 <= "01";
    wait for period;
    assert data_out = "00000000"
      report "RAM should be zero initialized" severity error;

    write_enable <= '0';
    data_in <= "11110000";
    wait for period;
    assert data_out = "01010101"
      report "data should have been written and returned" severity error;

    wait for period;
    assert data_out = "01010101"
      report "data should not be overwritten with write_enable false" severity error;

    finished <= '1';
    wait;
  end process;

end behavioural;
