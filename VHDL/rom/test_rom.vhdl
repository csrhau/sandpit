library ieee;
use ieee.std_logic_1164.all;
use work.memory_types.all;

entity test_rom is
end test_rom;

architecture behavioural  of test_rom is
  component ROM is
    generic ( 
      contents: memory_16b
    );
    port (
      clock : in std_logic;
      address : in std_logic_vector(3 downto 0);
      data : out std_logic_vector(7 downto 0)
    );
  end component;

  signal clock  : std_logic;
  signal addr   : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(7 downto 0);

  constant test_storage : memory_16b := (
    0  => "00000000",
    1  => "00000001",
    2  => "00000010",
    3  => "00000011",
    4  => "00000100",
    5  => "11110000",
    6  => "11110000",
    7  => "11110000",
    8  => "11110000",
    9  => "11110000",
    10 => "11110000",
    11 => "11110000",
    12 => "11110000",
    13 => "11110000",
    14 => "11110000",
    15 => "11110000"
  );


begin
  romcell : ROM generic map (test_storage)
                port map (clock, addr, output);
  process
  begin

    addr <= "0000";
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = "00000000"
        report "result should be 0" severity error;

    addr <= "0001";
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = "00000001"
        report "result should be 1" severity error;

    addr <= "1001";
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = "11110000"
        report "result should be big" severity error;
   
    wait;
  end process;

end behavioural;
