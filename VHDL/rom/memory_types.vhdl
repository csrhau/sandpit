library ieee;
use ieee.std_logic_1164.all;

package memory_types is 
  type memory_16b is array (15 downto 0) of std_logic_vector(7 downto 0);
end package memory_types;
