library ieee;
use ieee.std_logic_1164.all;

entity test_ram is
end test_ram;

architecture behavioural  of test_ram is
  component RAM is 
    port (
      clock   : in std_logic;
      -- Port a has read and write
      a_addr  : in std_logic_vector(9 downto 0);
      a_write : in std_logic; 
      a_din   : in std_logic_vector(7 downto 0); 
      a_dout  : out std_logic_vector(7 downto 0);
      -- Port b is read only
      b_addr  : in std_logic_vector(9 downto 0);
      b_dout  : out std_logic_vector(7 downto 0)
    );
  end component RAM;

  signal clock   : std_logic;
  signal a_addr  : std_logic_vector(9 downto 0);
  signal a_write : std_logic; 
  signal a_din   : std_logic_vector(7 downto 0); 
  signal a_dout  : std_logic_vector(7 downto 0);
  signal b_addr  : std_logic_vector(9 downto 0);
  signal b_dout  : std_logic_vector(7 downto 0);


begin
  ramcell : RAM port map (
              clock,
              a_addr,
              a_write,
              a_din,
              a_dout,
              b_addr,
              b_dout
            );
  process
  begin


    clock <= '0';
    wait for 1 ns;

    a_addr  <= "0000000000";
    b_addr  <= "0000000001";
    a_write <= '0';
    a_din   <= "11111111";

    clock <= '1';
    wait for 1 ns;
    assert a_dout = "00000000"
      report "PORT A should show initial value of zero" severity error;
    assert b_dout = "00000000"
      report "PORT B should show initial value of zero" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
  
    assert a_dout = "00000000"
      report "PORT A should still show initial value of zero" severity error;
    assert b_dout = "00000000"
      report "PORT B should still show initial value of zero" severity error;

    clock <= '0';
    wait for 1 ns;
    a_write <= '1';
    clock <= '1';
    wait for 1 ns;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;

    assert a_dout = "11111111"
      report "PORT A should show newly written value" severity error;
    assert b_dout = "00000000"
      report "PORT B should still show initial value of zero" severity error;



    wait;
  end process;

end behavioural;
