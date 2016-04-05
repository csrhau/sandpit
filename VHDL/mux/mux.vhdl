library ieee;
use ieee.std_logic_1164.all;

entity MUX is
  port (
    selector : in std_logic;
    input_a : in std_logic_vector(7 downto 0);
    input_b : in std_logic_vector(7 downto 0);
    output  : out std_logic_vector(7 downto 0)
   );
end entity MUX;

architecture behavioural of MUX is
  constant dont_care : std_logic_vector(7 downto 0) := "--------";
begin
  with selector select output <= input_a when '0',
                                 input_b when '1',
                                 dont_care when others;
                                 -- Use this to avoid declaring a constant:   (others => '-') when others; -- Don't care
end behavioural;
