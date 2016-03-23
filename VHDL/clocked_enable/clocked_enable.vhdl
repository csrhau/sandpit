library ieee;
use ieee.std_logic_1164.all;

entity clocked_enable is
  generic (period : integer);
  port (clock : in std_logic;
        enable: out std_logic :='0');
end clocked_enable;

architecture behavioural of clocked_enable is
    signal pcount : integer range period-1 downto 0 := 0;
begin

  process(clock) 
  begin
    if rising_edge(clock) then
      if pcount = period - 1 then
        enable <= '1';
        pcount <= 0;
      else
        enable <= '0';
        pcount <= pcount + 1;
      end if;
    end if;
  end process;

end behavioural;
