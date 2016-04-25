library ieee;
use ieee.std_logic_1164.all;

entity test_ring_buffer is 
end test_ring_buffer;


architecture behavioural of test_ring_buffer is

  component ring_buffer is
    port (
      clock : in std_logic;
      advance: in std_logic;
      address: in std_logic_vector;
      input : in std_logic_vector;
      output : out std_logic_vector
    );
  end component ring_buffer;

  signal clock : std_logic := '0';
  signal finished : std_logic := '0';
  signal advance : std_logic := '0';
  signal input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(7 downto 0);
  signal address : std_logic_vector (2 downto 0) := "000"; -- 8 places
  signal period: time := 10 ns;

begin
  clock <= not clock after period/2 when finished='0';

  BUFF: ring_buffer port map (clock, advance, address, input, output);

  process
  begin
    -- Fill test
    input <= "11001100";
    advance <= '1';
    wait for period;

    advance <= '0';
    address <= "000";
    wait for period;
    assert output = "11001100"
      report "Ripple buffer should be content addressable" severity error;

    address <= "001";
    wait for period;
    assert output = "00000000"
      report "Only the first element should be written" severity error;

    advance <= '1';
    wait for period;

    advance <= '0';
    address <= "001";
    wait for period;
    assert output = "11001100"
      report "The queue should now advance by one" severity error;

    wait for 10 * period;
    finished <= '1';
    wait;
  end process;
end behavioural;
