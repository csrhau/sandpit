library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_GLU is
  type input_deck is array(integer range <>) of std_logic_vector(9 downto 0);
  type output_deck is array(integer range <>) of std_logic_vector(7 downto 0);
end test_GLU;

architecture behavioural of test_GLU is
  component GLU is 
    generic (
      rows : natural;
      addr_bits : natural
    );
    port (
      clock        : in std_logic;
      input        : in std_logic_vector(9 downto 0);
      output       : out std_logic_vector(7 downto 0);
      read_address : out std_logic_vector(addr_bits downto 0);
      write_address : out std_logic_vector(addr_bits downto 0)
    );
  end component GLU;

  constant test_input_t1 : input_deck(0 to 7) := (
    0 => "0000000000",
    1 => "0001000000",
    2 => "0000100000",
    3 => "0011100000",
    4 => "0000000000",
    5 => "0000000000",
    6 => "0000000000",
    7 => "0000000000"
  );

  constant test_input_t2 : input_deck(0 to 7) := (
    0 => "0000000000",
    1 => "0000000000",
    2 => "0010100000",
    3 => "0001100000",
    4 => "0001000000",
    5 => "0000000000",
    6 => "0000000000",
    7 => "0000000000"
  );

  signal clock        : std_logic;
  signal input        : std_logic_vector(9 downto 0);
  signal output       : std_logic_vector(7 downto 0);
  signal read_address : std_logic_vector(3 downto 0);
  signal write_address : std_logic_vector(3 downto 0);
  
begin
  GLUE : GLU generic map (8, 3) 
             port map (clock, input, output, read_address, write_address);
  process
  begin

    -- State GLU_INIT
    clock <= '0';
    wait for 1 ns;
    assert to_integer(unsigned(read_address)) = 7
      report "Should read and store last line first" severity error;
    input <= test_input_t1(to_integer(unsigned(read_address)));
    clock <= '1';
    wait for 1 ns;

    -- State GLU_FIRST
    clock <= '0';
    wait for 1 ns;
    assert to_integer(unsigned(read_address)) = 0
      report "Should read line 0" severity error;
    input <= test_input_t1(to_integer(unsigned(read_address)));
    clock <= '1';
    wait for 1 ns;

    -- State GLU_ROW input=1, output=0
    clock <= '0';
    wait for 1 ns;
    assert to_integer(unsigned(read_address)) = 1
      report "Should read line 1" severity error;
    assert to_integer(unsigned(write_address)) = 0
      report "Should write line 0" severity error;
    input <= test_input_t1(to_integer(unsigned(read_address)));
    clock <= '1';
    wait for 1 ns;


    -- State GLU_ROW input=2, output=1
    clock <= '0';
    wait for 1 ns;
    assert to_integer(unsigned(read_address)) = 2
      report "Should read line 1" severity error;
    assert to_integer(unsigned(write_address)) = 1
      report "Should write line 0" severity error;
    input <= test_input_t1(to_integer(unsigned(read_address)));
    clock <= '1';
    wait for 1 ns;




    for i in 0 to 16 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    wait;
  end process;
end behavioural;

