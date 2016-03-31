library ieee;
use ieee.std_logic_1164.all;

entity test_slv is 
end test_slv;

architecture behavioural of test_slv is
  signal input : std_logic_vector(5 downto 0);

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

begin

  process
    variable result : natural range 0 to 6;
  begin
    input <= "000000";
    result := popcnt(input);
    assert result = 0
      report "Result should be 0 for 000000" severity error;

    input <= "000001";
    wait for 1 ns;
    result := popcnt(input);
    assert result = 1
      report "Result should be 1 for 000001" severity error;

    input <= "111110";
    wait for 1 ns;
    result := popcnt(input);
    assert result = 5
      report "Result should be 5 for 111110" severity error;


    wait;
  end process;
end behavioural;
