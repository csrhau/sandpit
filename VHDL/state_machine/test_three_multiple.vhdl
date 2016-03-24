library ieee;
use ieee.std_logic_1164.all;
use work.three_multiple_types.all;

entity test_three_multiple is
end test_three_multiple;

architecture behavioural of test_three_multiple is
  component three_multiple is
    port (
      clock : in std_logic;
      input : in std_logic; 
      output: out std_logic;
      state: out three_state
    );
  end component three_multiple;

  signal clock_s : std_logic;
  signal input_s : std_logic;
  signal output_s : std_logic;
  signal state_s : three_state;

begin
  DFA : three_multiple port map (clock_s, input_s, output_s, state_s);

  process
  begin

   -- 0
    assert state_s = SAccept
      report "Should start in accept state" severity error;

    -- 1
    clock_s <= '0';
    wait for 1 ns;
    input_s <= '0';
    clock_s <= '1';
    wait for 1 ns;
    assert output_s = '1'
      report "Zero should be a multiple of 3";
    assert state_s = SAccept
      report "Should remain in accept state for zeroes" severity error;
    wait for 1 ns;

    -- 01
    clock_s <= '0';
    wait for 1 ns;
    input_s <= '1';
    clock_s <= '1';
    wait for 1 ns;
    assert output_s = '0'
      report "One is not a multiple of 3";
    assert state_s = S1
      report "Should transition SAccept to S1 on a 1" severity error;
    wait for 1 ns;

    -- 011
    clock_s <= '0';
    wait for 1 ns;
    input_s <= '1';
    clock_s <= '1';
    wait for 1 ns;
    assert output_s = '1'
      report "Three is a multiple of 3";
    assert state_s = SAccept
      report "Should transition S1 to SAccept on a 1" severity error;
    wait for 1 ns;

    -- 0111
    clock_s <= '0';
    wait for 1 ns;
    input_s <= '1';
    clock_s <= '1';
    wait for 1 ns;
    assert output_s = '0'
      report "Seven is not a multiple of 3";
    assert state_s = S1
      report "Should transition SAccept to S1 on a 1" severity error;
    wait for 1 ns;


    -- 01110
    clock_s <= '0';
    wait for 1 ns;
    input_s <= '0';
    clock_s <= '1';
    wait for 1 ns;
    assert output_s = '0'
      report "14 is not a multiple of 3";
    assert state_s = S2
      report "Should transition S1 to S2 on a 0" severity error;
    wait for 1 ns;

    clock_s <= '0';
    wait for 1 ns;
    input_s <= '1';
    clock_s <= '1';
    wait for 1 ns;
    assert state_s = S2
      report "Should transition S2 to S2 on a 1" severity error;
    wait for 1 ns;

    clock_s <= '0';
    wait for 1 ns;
    input_s <= '0';
    clock_s <= '1';
    wait for 1 ns;
    assert state_s = S1
      report "Should transition S2 to S1 on a 0" severity error;
    wait for 1 ns;


    wait;
  end process;


end behavioural;
