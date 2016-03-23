library ieee; use ieee.std_logic_1164.all;

entity test_clocked_enable is 
end test_clocked_enable;


architecture behavioural of test_clocked_enable is
  signal clock, clock_enable : std_logic;

  component clocked_enable is
      generic (period : integer);
      port (clock : in std_logic;
            enable: out std_logic);
  end component clocked_enable;

begin

  enabler : clocked_enable generic map (4)
                           port map (clock, clock_enable);
  process
  begin
    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 1, 
    assert clock_enable = '0'
      report "Clock enable should remain off";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 2, 
    assert clock_enable = '0'
      report "Clock enable should remain off";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 3, 
    assert clock_enable = '0'
      report "Clock enable should remain off";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 4, 
    assert clock_enable = '1'
      report "Clock enable should fire";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 5, 
    assert clock_enable = '0'
      report "Clock enable should remain off";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 6, 
    assert clock_enable = '0'
      report "Clock enable should remain off";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 7, 
    assert clock_enable = '0'
      report "Clock enable should remain off";

    clock <='0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    -- Counter = 7, 
    assert clock_enable = '1'
      report "Clock enable should fire";






    wait;
  end process;
end behavioural;
