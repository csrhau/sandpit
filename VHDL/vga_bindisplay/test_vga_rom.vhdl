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
      enable : in std_logic;
      address : in natural range vga_memory'range;
      data : out std_logic
    );
  end component;

  signal clock  : std_logic;
  signal enable  : std_logic;
  signal address : natural range vga_memory'range;
  signal output : std_logic;

  constant test_storage : vga_memory := (
    0  => '0',
    1  => '1',
    2  => '1',
    3  => '0',
    others => '0'
  );


begin
  ROMCELL : VGA_ROM generic map (test_storage)
                    port map (clock, enable, address, output);
  process
  begin

    enable <= '1';
    address <= 0;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = '0'
        report "result should be 0" severity error;

    address <= 1;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = '1'
        report "result should be 1" severity error;

    address <= 2;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = '1'
        report "result should be 1" severity error;


    address <= 3;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = '0'
        report "result should be 1" severity error;

    enable <= '0';
    address <= 1;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert output = '0' 
      report "result should be 0 when disabled" severity error;


    wait;
  end process;

end behavioural;
