library ieee;
use ieee.std_logic_1164.all;

entity test_file_RAM is
end test_file_RAM;

architecture behavioural  of test_file_RAM is

  component file_RAM is 
    generic (
      filename: string
    );
    port (
      clock : in std_logic;
      write_enable : in std_logic; 
      address : in std_logic_vector;
      data_in : in std_logic_vector;
      data_out : out std_logic_vector
    );
  end component file_RAM;

  signal write_enable : std_logic; 
  signal address  : std_logic_vector(9 downto 0);
  signal data_in  : std_logic_vector(7 downto 0);
  signal data_out : std_logic_vector(7 downto 0);

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';
begin

  clock <= not clock after period/2 when finished='0';

  memory : file_RAM generic map (filename => "ram_1024.mif")
                    port map (clock, write_enable, address, data_in, data_out);
  process
  begin

    address <= "0000000000";
    write_enable <= '1';
    data_in <= "01010101";
    wait for period;
    assert data_out = "00000000"
      report "file_RAM should start at zero" severity error;

    address <= "0000000000";
    write_enable <= '1';
    data_in <= "01010101";
    wait for period;
    assert data_out = "01010101"
      report "file_RAM should store values" severity error;

    address <= "0000000001";
    wait for period;
    assert data_out = "00000001"
      report "data should be sequential in ram" severity error;

    address <= "0000000010";
    wait for period;
    assert data_out = "00000010"
      report "data should be sequential in ram" severity error;

    address <= "0000010010";
    wait for period;
    assert data_out = "00010010"
      report "data should be sequential in ram" severity error;



    finished <= '1';
    wait;
  end process;

end behavioural;
