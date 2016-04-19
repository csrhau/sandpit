library ieee;
use ieee.std_logic_1164.all;

entity test_gol_processor is
  type input_deck is array(integer range <>) of std_logic_vector(9 downto 0);
  type output_deck is array(integer range <>) of std_logic_vector(7 downto 0);
end test_gol_processor;

architecture behavioural of test_gol_processor is
  component gol_processor is
    port (
      clock : in std_logic;
      input : in std_logic_vector(9 downto 0);
      output: out std_logic_vector(8 downto 1)
    );
  end component gol_processor;

  signal clock : std_logic;
  signal input : std_logic_vector(9 downto 0);
  signal output : std_logic_vector(7 downto 0);

  constant test_input : input_deck(0 to 8) := (
    0 => "1110000111",
    1 => "0000000001",
    2 => "0000000010",
    3 => "0000000011",
    4 => "1110001000",
    5 => "1010011100",
    6 => "1110001000",
    7 => "0000000000",
    8 => "0000000000"
  );

  constant test_output: output_deck(0 to 8) := (
    0 => "10000001", -- 0000000000,
                     -- 0000000000, => _10000001_
                     -- 1110000111 

    1 => "10000001", -- 0000000000 
                     -- 1110000111 => _10000001_
                     -- 0000000001

    2 => "10000010", -- 1110000111
                     -- 0000000001 => _10000010_
                     -- 0000000010

    3 => "00000001", -- 0000000001
                     -- 0000000010 => _00000001_
                     -- 0000000011
                    
    4 => "10000011", -- 0000000010 
                     -- 0000000011 => _10000011_
                     -- 1110001000

    5 => "01001101", -- 0000000011 
                     -- 1110001000 => _01001101_
                     -- 1010011100
    6 => "00101010", -- 1110001000 
                     -- 1010011100 => _00101010_
                     -- 1110001000
    7 => "01001110", -- 1010011100
                     -- 1110001000 => _01001110_
                     -- 0000000000
    8 => "10000000"  -- 1110001000
                     -- 0000000000 => _10000000_
                     -- 0000000000
  );


begin
  PROCESSOR : gol_processor port map (clock, input, output); 

  process
  begin
    for i in 0 to 8 loop
      clock <= '0';
      wait for 1 ns;
      input <= test_input(i);
      clock <= '1';
      wait for 1 ns;

      assert output = test_output(i)
        report "Expectation mismatch on iteration " & integer'image(i) severity error;
    end loop;
 

    wait;
  end process;
end behavioural;

