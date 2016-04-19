library ieee;
use ieee.std_logic_1164.all;

entity test_array is 
end test_array;

architecture behavioural of test_array is
  -- This is how to specify unconstrained ranges.
  type board1 is array(integer range <>, integer range <>) of integer range 0 to 1;
  type board2 is array(5 downto 0, 5 downto 0) of integer range 0 to 1;

  -- Can't seem to define board2 in terms of board1 :(.
  signal state1 : board1(5 downto 0, 5 downto 0);
  signal state2 : board2;




  type kB_ram is array(0 to 1023) of std_logic_vector(7 downto 0);
  signal initializeme : kB_ram := (others => (others => '1')); -- Nested initialization!
  signal blockinit : kB_ram := (0 => "00000000",
                                1 => "00000001",
                                2 to 10 => "01010101",
                                others => (others => '1'));


  
begin
  process
  begin
    assert initializeme(4) = "11111111"
      report "Should have initialized correctly" severity error;

    assert blockinit(0) = "00000000"
      report "Should have initialized correctly" severity error;

    assert blockinit(1) = "00000001"
      report "Should have initialized correctly" severity error;


    for i in 2 to 10 loop
      assert blockinit(i) = "01010101"
        report "Should have initialized correctly" severity error;
    end loop;

    assert blockinit(100) = "11111111"
        report "Should have initialized correctly" severity error;


    wait;
  end process;
end behavioural;
