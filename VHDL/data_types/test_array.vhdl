library ieee;
use ieee.std_logic_1164.all;

entity test_array is 
end test_array;

architecture behavioural of test_array is
  -- This is how to specify unconstrained ranges.
  type board is array(integer range <>, integer range <>) of integer range 0 to 1;
  signal state : board(5 downto 0, 5 downto 0);
begin
  process
  begin

    wait;
  end process;
end behavioural;
