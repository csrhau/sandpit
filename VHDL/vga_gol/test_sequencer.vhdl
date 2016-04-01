library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_sequencer is
  constant ADDR_BITS: natural := 3;
  constant ROWS: natural := 8;
end test_sequencer;

architecture behavioural of test_sequencer is
  component sequencer is 
    generic (
      rows : natural;
      addr_bits : natural
    );
    port (
      clock        : in std_logic;
      write_enable : out std_logic;
      address : out std_logic_vector(addr_bits-1 downto 0)
    );
  end component sequencer;
   
  signal clock         : std_logic;
  signal write_enable  : std_logic;
  signal address  : std_logic_vector(ADDR_BITS-1 downto 0);
begin
  SEQ: sequencer generic map(rows => ROWS, addr_bits => ADDR_BITS)
                 port map(clock, write_enable, address);
  
  process
  begin
    wait for 1 ns;

    assert address = "111"
      report "T0 read address should be last row of RAM" severity error;
    assert write_enable = '0'
      report "Write should be disabled at this point" severity error;


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
