library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ring_buffer is
  port (
    clock : in std_logic;
    advance: in std_logic;
    address: in std_logic_vector;
    input : in std_logic_vector;
    output : out std_logic_vector
  );
end entity ring_buffer;

architecture behavioural of ring_buffer is
  type neighbourhood_t is array(integer range 0 to (2**address'length-1)) of std_logic_vector(input'range);
  signal neighbourhood : neighbourhood_t := (others => (others => '0'));
  signal head : std_logic_vector(address'range) := (others => '0');
begin

  process(clock)
  begin
    if rising_edge(clock) then
      if advance = '1' then
        neighbourhood(to_integer(unsigned(head))) <= input;
        head <= std_logic_vector(unsigned(head) + 1);
      end if;
      output <= neighbourhood(to_integer(unsigned(address)));
    end if;
  end process;

end behavioural;
