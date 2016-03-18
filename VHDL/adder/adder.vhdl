library ieee;
use ieee.std_logic_1164.all;

entity adder is
  port (x, y    : in std_logic;
        sum, carry : out std_logic);
end adder;

architecture behavioural of adder is
begin
  sum <= x xor y;
  carry <= x and y;
end behavioural;
