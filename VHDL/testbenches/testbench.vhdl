library ieee;
use ieee.std_logic_1164.all;

entity testbench is 
end entity testbench;


architecture behavioural of testbench is
  constant period : time := 10 ns;
  signal active : std_logic := '1';
  signal clock : std_logic := '0';

begin
  clock <= not clock after period / 2 when active = '1';
  process
  begin

    wait for period;
    wait for period;
    wait for period;
    wait for period;

    wait for 100 ns;
    active <= '0';
    wait;
  end process;
end architecture behavioural;
