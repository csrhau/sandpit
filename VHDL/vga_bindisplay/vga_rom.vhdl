library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;

entity VGA_ROM is 
  generic (
    contents : vga_memory
  );
  port (
    clock : in std_logic;
    enable : in std_logic;
    address : in natural range vga_memory'range;
    data : out std_logic
  );
end entity VGA_ROM;

architecture behavioural of VGA_ROM is
  constant storage : vga_memory := contents;
 begin

  process(clock)
  begin
    if rising_edge(clock) then
      if enable = '1' then
        data <= storage(address);
      else
        data <= '0';
      end if;
    end if;
  end process;
end behavioural;
