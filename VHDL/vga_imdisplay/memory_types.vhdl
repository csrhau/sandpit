library ieee;
use ieee.std_logic_1164.all;

package memory_types is 
  constant PIXEL_MAX : integer := 640 * 480 - 1;
  type vga_memory is array(PIXEL_MAX downto 0) of std_logic_vector(7 downto 0);
  type vga_memory_ptr is access vga_memory;
end package memory_types;
