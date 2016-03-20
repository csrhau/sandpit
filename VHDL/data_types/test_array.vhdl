library ieee;
use ieee.std_logic_1164.all;

entity test_array is 
end test_array;

architecture behavioural of test_array is
  -- This is how to specify unconstrained ranges.
  type board1 is array(integer range <>, integer range <>) of integer range 0 to 1;
  type board2 is array(5 downto 0, 5 downto 0) of integer range 0 to 1;
  -- Can't seem to define board2 in terms of board1 :(.
  signal state1 : board1(5 downto 0, 5 downto 0);
  signal state2 : board2;
begin
  process
  begin

    wait;
  end process;
end behavioural;
