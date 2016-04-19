library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--         0 1 2 3 4 5 6 7 8 9
-- input  | | | | | | | | | | |
-- middle | | | | | | | | | | |
-- bottom | | | | | | | | | | |
-- output  x| | | | | | | | |x
--

entity gol_processor is
  port (
    clock : in std_logic;
    input : in std_logic_vector(9 downto 0);
    output: out std_logic_vector(8 downto 1)
  );
end entity gol_processor;

architecture behavioural of gol_processor is
  function popcnt(vector : std_logic_vector) return natural is
    variable result : natural range 0 to vector'length := 0;
  begin
    for i in vector'range loop
      if vector(i) = '1' then
        result := result + 1;
      end if;
    end loop;
    return result;
  end function popcnt;

  signal middle : std_logic_vector(9 downto 0) := "0000000000";
  signal bottom : std_logic_vector(9 downto 0) := "0000000000";
begin
  process(clock)
    variable count: natural range 0 to 9;
  begin
    if rising_edge(clock) then
      for i in output'range loop
        count := popcnt(input(i+1 downto i-1)
                      & middle(i+1 downto i-1)
                      & bottom(i+1 downto i-1));
        if count = 3 then
          output(i) <= '1';
        elsif count = 4 then
          output(i) <= middle(i);
        else
          output(i) <= '0';
        end if;
      end loop;
      middle <= input;
      bottom <= middle;
    end if;
  end process;
end behavioural;
