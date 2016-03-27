library ieee;
use ieee.std_logic_1164.all;

entity test_ram is
end test_ram;

architecture behavioural  of test_ram is
  component RAM is 
    port (
      clock : in std_logic;
      write_enable : in std_logic; 
      address : in std_logic_vector(9 downto 0);
      data_in : in std_logic_vector(7 downto 0);
      data_out : out std_logic_vector(7 downto 0)
    );
  end component RAM;


  signal clock : std_logic;
  signal write_enable : std_logic; 
  signal address  : std_logic_vector(9 downto 0);
  signal data_in  : std_logic_vector(7 downto 0);
  signal data_out : std_logic_vector(7 downto 0);


begin
  ramcell : RAM port map (clock, write_enable, address, data_in, data_out);
  process
  begin


    clock <= '0';
    wait for 1 ns;

    address <= "0000000000";
    write_enable <= '1';
    data_in <= "01010101";

    clock <= '1';
    wait for 1 ns;
    assert data_out = "00000000"
      report "RAM should be zero initialized" severity error;

    clock <= '0';
    wait for 1 ns;

    write_enable <= '0';
    data_in <= "11110000";

    clock <= '1';
    wait for 1 ns;

    assert data_out = "01010101"
      report "data should have been written and returned" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;

    assert data_out = "01010101"
      report "data should not be overwritten with write_enable false" severity error;


  
    wait;
  end process;

end behavioural;
