library ieee;
use ieee.std_logic_1164.all;
use work.memory_types.all;

entity test_vga_rom is
end test_vga_rom;

architecture behavioural  of test_vga_rom is
  component VGA_ROM is
    generic ( 
      contents: vga_memory
    );
    port (
      clock : in std_logic;
      address : in natural range vga_memory'range;
      data : out std_logic_vector(7 downto 0)
    );
  end component;

  signal clock  : std_logic;
  signal address : natural range vga_memory'range;
  signal output : std_logic_vector(7 downto 0);

  constant test_storage : vga_memory := (
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
    15 => "11110000",
    others => "00000000"
  );


begin
  ROMCELL : VGA_ROM generic map (test_storage)
                    port map (clock, address, output);
  process
  begin

    address <= 0;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = "00000000"
        report "result should be 0" severity error;

    address <= 1;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = "00000001"
        report "result should be 1" severity error;

    address <= 2000;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = "00000000"
        report "result should be zero" severity error;
   
    wait;
  end process;

end behavioural;
