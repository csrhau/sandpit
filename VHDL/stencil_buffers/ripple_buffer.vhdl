library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ripple_buffer is
  port (
    clock : in std_logic;
    advance: in std_logic;
    address: in std_logic_vector;
    input : in std_logic_vector;
    output : out std_logic_vector
  );
end entity ripple_buffer;

architecture behavioural of ripple_buffer is
  type neighbourhood_t is array(integer range 0 to (2**address'length-1)) of std_logic_vector(input'range);
  signal neighbourhood : neighbourhood_t := (others => (others => '0'));
begin

  process(clock)
  begin
    if rising_edge(clock) then
      if advance = '1' then
        for i in 1 to neighbourhood'right loop
          neighbourhood(i) <= neighbourhood(i-1);
        end loop;
        neighbourhood(0) <= input;
      end if;
      output <= neighbourhood(to_integer(unsigned(address)));
    end if;
  end process;

end behavioural;
