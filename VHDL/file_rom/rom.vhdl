library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;

entity ROM is 
  generic (
    contents : memory_16b
  );
  port (
    clock : in std_logic;
    address : in std_logic_vector(3 downto 0);
    data : out std_logic_vector(7 downto 0)
  );
end entity ROM;

architecture behavioural of ROM is
  constant storage : memory_16b := contents;
 begin

  process(clock)
  begin
    if rising_edge(clock) then
        data <= storage(to_integer(unsigned(address))); 
    end if;
  end process;
end behavioural;


