library ieee;
use ieee.std_logic_1164.all;

entity bus_writer is 
  generic (
    bus_length : natural;
    bus_index : natural;
    value : std_logic_vector(7 downto 0)
  );
  port ( 
    clock : in std_logic;
    data : out std_logic_vector(7 downto 0)
  );
end entity bus_writer;

architecture behavioural of bus_writer is 
  signal active_index : natural range bus_length-1 downto 0 := 0;

begin
  process(clock)
  begin
    if rising_edge(clock) then
      if active_index = bus_index then
        data <= value;
      else
        data <= (others => 'Z');
      end if;
      if active_index = bus_length - 1 then
        active_index <= 0;
      else
        active_index <= active_index + 1;
      end if;
    end if;
  end process;
end behavioural;
