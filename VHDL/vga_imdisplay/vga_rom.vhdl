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
    address : in natural range contents'range;
    data : out std_logic_vector(7 downto 0)
  );
end entity VGA_ROM;

architecture behavioural of VGA_ROM is
  constant storage : vga_memory := contents;
 begin

  process(clock)
  begin
    if rising_edge(clock) then
        data <= storage(address);
    end if;
  end process;
end behavioural;
