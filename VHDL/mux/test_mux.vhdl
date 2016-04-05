library ieee;
use ieee.std_logic_1164.all;

entity test_mux is
end entity test_mux;


architecture behavioural of test_mux is 
  component MUX is
    port (
      selector : in std_logic;
      input_a : in std_logic_vector(7 downto 0);
      input_b : in std_logic_vector(7 downto 0);
      output  : out std_logic_vector(7 downto 0)
     );
  end component MUX;

  signal selector : std_logic;
  signal input_a  : std_logic_vector(7 downto 0);
  signal input_b  : std_logic_vector(7 downto 0);
  signal output   : std_logic_vector(7 downto 0);

begin
  multiplexer : MUX port map (selector, input_a, input_b, output);

  process
  begin

    input_a <= "00001111";
    input_b <= "11110000";
    selector <= '0';
    wait for 1 ns;
    assert output = input_a
      report "MUX should output input_a when selector is zero" severity error;
    selector <= '1';
    wait for 1 ns;
    assert output = input_b
      report "MUX should output input_b when selector is zero" severity error;



    wait;
  end process;
end behavioural;
