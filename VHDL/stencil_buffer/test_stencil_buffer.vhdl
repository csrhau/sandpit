library ieee;
use ieee.std_logic_1164.all;

entity test_stencil_buffer is 
end test_stencil_buffer;


architecture behavioural of test_stencil_buffer is

  component stencil_buffer is
    generic (
      addr_bits : natural
    );
    port (
      clock : in std_logic;
      advance: in std_logic;
      input : in std_logic_vector;
      tl : out std_logic_vector;
      tc : out std_logic_vector;
      tr : out std_logic_vector;
      ml : out std_logic_vector;
      mc : out std_logic_vector;
      mr : out std_logic_vector;
      bl : out std_logic_vector;
      bc : out std_logic_vector;
      br : out std_logic_vector
    );
  end component stencil_buffer;

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';

  signal advance : std_logic := '0';
  signal input : std_logic_vector(7 downto 0);

  signal tl : std_logic_vector(7 downto 0);
  signal tc : std_logic_vector(7 downto 0);
  signal tr : std_logic_vector(7 downto 0);
  signal ml : std_logic_vector(7 downto 0);
  signal mc : std_logic_vector(7 downto 0);
  signal mr : std_logic_vector(7 downto 0);
  signal bl : std_logic_vector(7 downto 0);
  signal bc : std_logic_vector(7 downto 0);
  signal br : std_logic_vector(7 downto 0);


begin
  clock <= not clock after period/2 when finished='0';
  BUFF: stencil_buffer generic map (addr_bits => 4) -- 16 places; large enough for a 3x3 stencil
                       port map (clock, advance, input,
                                 tl, tc, tr,
                                 ml, mc, mr,
                                 bl, bc, br);


  process
  begin
    -- Fill test
    advance <= '1';
    input <= "11001100";
    wait for 9 * period;

    assert tl = "11001100" report "tl should be filled" severity error;
    assert tc = "11001100" report "tc should be filled" severity error;
    assert tr = "11001100" report "tr should be filled" severity error;
    assert ml = "11001100" report "ml should be filled" severity error;
    assert mc = "11001100" report "mc should be filled" severity error;
    assert mr = "11001100" report "mr should be filled" severity error;
    assert bl = "11001100" report "bl should be filled" severity error;
    assert bc = "11001100" report "bc should be filled" severity error;
    assert br = "11001100" report "br should be filled" severity error;

    -- Order test
    input <= "00000000"; wait for period;
    input <= "00000001"; wait for period;
    input <= "00000010"; wait for period;
    input <= "00000011"; wait for period;
    input <= "00000100"; wait for period;
    input <= "00000101"; wait for period;
    input <= "00000110"; wait for period;
    input <= "00000111"; wait for period;
    input <= "00001000"; wait for period;

    assert tl = "00000000" report "tl should contain the correct value" severity error;
    assert tc = "00000001" report "tc should contain the correct value" severity error;
    assert tr = "00000010" report "tr should contain the correct value" severity error;
    assert ml = "00000011" report "ml should contain the correct value" severity error;
    assert mc = "00000100" report "mc should contain the correct value" severity error;
    assert mr = "00000101" report "mr should contain the correct value" severity error;
    assert bl = "00000110" report "bl should contain the correct value" severity error;
    assert bc = "00000111" report "bc should contain the correct value" severity error;
    assert br = "00001000" report "br should contain the correct value" severity error;

    -- Scroll test
    input <= "00001001"; wait for period;
    input <= "00001010"; wait for period;
    input <= "00001011"; wait for period;

    assert tl = "00000011" report "tl should contain the correct value" severity error;
    assert tc = "00000100" report "tc should contain the correct value" severity error;
    assert tr = "00000101" report "tr should contain the correct value" severity error;
    assert ml = "00000110" report "ml should contain the correct value" severity error;
    assert mc = "00000111" report "mc should contain the correct value" severity error;
    assert mr = "00001000" report "mr should contain the correct value" severity error;
    assert bl = "00001001" report "bl should contain the correct value" severity error;
    assert bc = "00001010" report "bc should contain the correct value" severity error;
    assert br = "00001011" report "br should contain the correct value" severity error;

    wait for 30 * period;

    finished <= '1';
    wait;
  end process;
end behavioural;
