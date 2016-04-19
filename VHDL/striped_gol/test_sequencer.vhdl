library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_sequencer is
  constant ADDR_BITS: natural := 3;
  constant ROWS: natural := 8;
  type input_deck is array(integer range <>) of std_logic_vector(9 downto 0);
  type output_deck is array(integer range <>) of std_logic_vector(7 downto 0);
end test_sequencer;

architecture behavioural of test_sequencer is
  component sequencer is 
    generic (
      rows : natural;
      addr_bits : natural
    );
    port (
      clock        : in std_logic;
      input : in std_logic_vector(9 downto 0);
      output: out std_logic_vector(8 downto 1);
      address : out std_logic_vector(addr_bits-1 downto 0);
      write_enable : out std_logic
    );
  end component sequencer;

  constant test_input : input_deck(0 to 7) := (
    0 => "1110000111",
    1 => "0000000001",
    2 => "0000000010",
    3 => "0000000011",
    4 => "1110001000",
    5 => "1010011100",
    6 => "1110001000",
    7 => "0000000000"
  );

  constant test_output: output_deck(2 to 9) := (
    2 => "10000001",
    3 => "10000001",
    4 => "10000010",
    5 => "00000001",
    6 => "10000011",
    7 => "01001101",
    8 => "00101010",
    9 => "01001110" 
  );

  signal clock         : std_logic;
  signal write_enable  : std_logic;
  signal input  : std_logic_vector(9 downto 0);
  signal output : std_logic_vector(8 downto 1);
  signal address  : std_logic_vector(ADDR_BITS-1 downto 0);
begin
  SEQ: sequencer generic map(rows => ROWS, addr_bits => ADDR_BITS)
                 port map(clock, input, output, address, write_enable);
  process
  begin
    wait for 1 ns;

    assert address = "111"
      report "T0 read address should be last row of RAM" severity error;
    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    input <= test_input(to_integer(unsigned(address)));

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_INIT -> SEQ_FIRST_ROW
    wait for 1 ns; -- Here, the data_in will match the last line of the GOL strip

    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    assert address = "000"
      report "T1 read address should be row 0 of RAM" severity error;
    input <= test_input(to_integer(unsigned(address)));

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_FIRST_ROW -> SEQ_UPDATE
    wait for 1 ns; -- Here, data_in will match line 0 of the GOL strip
    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    assert address = "001"
      report "T2 read address should be row 1 of RAM" severity error;
    input <= test_input(to_integer(unsigned(address)));

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_UPDATE -> SEQ advance
    wait for 1 ns;

    assert write_enable = '1'
      report "T3 should write out the first calculation" severity error;
    assert address = "000"
      report "T3 should write to row 0" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_advance -> SEQ_update
    wait for 1 ns;
    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    assert address = "010"
      report "T4 read address should be row 2 of RAM" severity error;

    for i in 1 to 5 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
      assert write_enable = '1'
        report "Update should write out a result" severity error;
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
      assert write_enable = '0'
        report "Advance should schedule input" severity error;
    end loop;

    -- This is the interesting bit
    clock <= '0';
    wait for 1 ns;
    clock <= '1';     -- SEQ_UPDATE -> SEQ_FLUSH
    wait for 1 ns;
    assert write_enable = '1'
      report "Tn should write out the nnd calculation" severity error;
    assert address = "110"
      report "Tn should write to row 3" severity error;


    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_FLUSH -> SEQ_INIT
    wait for 1 ns;
    assert write_enable = '1'
      report "Write should be enabled for the final flush" severity error;
    assert address = "111"
      report "The final flush should write to the final row" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_INIT -> SEQ_FIRST_ROW
    wait for 1 ns; -- Here, the data_in will match the last line of the GOL strip

    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    assert address = "000"
      report "T1 read address should be row 0 of RAM" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_FIRST_ROW -> SEQ_UPDATE
    wait for 1 ns; -- Here, data_in will match line 0 of the GOL strip
    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    assert address = "001"
      report "T2 read address should be row 1 of RAM" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_UPDATE -> SEQ advance
    wait for 1 ns;

    assert write_enable = '1'
      report "T3 should write out the first calculation" severity error;
    assert address = "000"
      report "T3 should write to row 0" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- SEQ_advance -> SEQ_update
    wait for 1 ns;
    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;
    assert address = "010"
      report "T4 read address should be row 2 of RAM" severity error;

    wait;
  end process;
end behavioural;
