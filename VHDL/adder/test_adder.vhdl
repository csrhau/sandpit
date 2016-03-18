library ieee;
use ieee.std_logic_1164.all;

entity test_adder is 
end test_adder;


architecture behavioural of test_adder is
  signal x, y, sum, carry: std_logic;

  component adder is 
    port (
      x, y: in std_logic;
      sum, carry: out std_logic
    );
  end component;

begin

  adder_0: adder port map (
    x => x, y=>y,
    sum => sum, carry => carry
  );

  process
  begin
    x <= '1';
    y <= '1';
    wait for 1 ns;
    assert carry = '1' and sum = '0'
        report "result should be 0 carry 1" severity error;

      x <= '0';
      y <= '0';
      wait for 1 ns;
      assert carry = '0' and sum = '0'
        report "result should be 0" severity error;

      x <= '1';
      y <= '0';
      wait for 1 ns;
      assert carry = '0' and sum = '1'
        report "result should be 1" severity error;

      x <= '0';
      y <= '1';
      wait for 1 ns;
      assert carry = '0' and sum = '1'
        report "result should be 1" severity error;

    wait;
  end process;
end behavioural;
