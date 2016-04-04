library ieee;
use ieee.std_logic_1164.all;

entity test_fifo is
end test_fifo;


architecture behavioural of test_fifo is
  component FIFO is 
    generic (
      addr_bits: natural
    );
    port (
      clock   : in std_logic;
      push : in std_logic;      -- Enable data write
      pop : in std_logic;       -- Enable data read if possible (push takes priority)
      input   : in std_logic_vector(7 downto 0); -- Data in 
      output  : out std_logic_vector(7 downto 0); -- Data out
      full    : out std_logic;
      empty   : out std_logic
     );
  end component FIFO;

  signal clock: std_logic;
  signal push : std_logic := '0';
  signal pop  : std_logic := '0';
  signal input   : std_logic_vector(7 downto 0);
  signal output  : std_logic_vector(7 downto 0);
  signal full    : std_logic;
  signal empty   : std_logic;

  procedure CYCLE(signal clock: out std_logic) is
  begin
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
  end procedure;

  procedure PUSH_IMPL(value : in std_logic_vector(7 downto 0);
                      signal clock : out std_logic;
                      signal push : out std_logic;
                      signal pop  : out std_logic;
                      signal fifo_input : out std_logic_vector(7 downto 0)) is
  begin
    push <= '1';
    pop <= '0';
    fifo_input <= value;
    CYCLE(clock);
  end procedure;

  procedure POP_IMPL(signal clock: out std_logic;
                     signal push: out std_logic;
                     signal pop  : out std_logic) is
  begin
    push <= '0';
    pop <= '1';
    CYCLE(clock);
  end procedure;


  begin
  queue : FIFO generic map(addr_bits => 3) -- fifo with 8 elements
               port map (clock, push, pop, input, output, full, empty);

  process
    -- Helper macros
    -- PUSH wrapper
    procedure PUSH_MACRO(value: in std_logic_vector(7 downto 0)) is 
    begin
      PUSH_IMPL(value, clock, push, pop, input);
    end procedure;
    -- POP wrapper
    procedure POP_MACRO(value: out std_logic_vector(7 downto 0)) is
    begin
      POP_IMPL(clock, push, pop);
      value := output;
    end procedure;

    variable retval : std_logic_vector(7 downto 0);
  begin
    wait for 1 ns;
    assert full = '0' 
      report "Fresh queue should not be full"
      severity error;
    assert empty = '1' 
      report "Fresh queue should be empty"
      severity error;

    PUSH_MACRO("10101010");

    assert full = '0' 
      report "1 element queue should not be full" severity error;
    assert empty = '0' 
      report "1 element queue should not be empty" severity error;

    for i in 1 to 6 loop
      CYCLE(clock);

      assert full = '0' 
        report "queue should not be full" severity error;
      assert empty = '0' 
        report "queue should not be empty" severity error;
    end loop;
    CYCLE(clock);

    assert full = '1' 
      report "8 element queue should be full" severity error;
    assert empty = '0' 
      report "8 element queue should not be empty" severity error;

    -- Ensure queue maintains size
    push <= '0';
    pop <= '0';
    CYCLE(clock);

    assert full = '1' 
      report "8 element queue should be full" severity error;
    assert empty = '0' 
      report "8 element queue should not be empty" severity error;

    -- Drain queue
    for i in 1 to 7 loop
      POP_MACRO(retval);
      assert full = '0' 
        report "draining queue should not be full" severity error;
      assert empty = '0' 
        report "draining queue should not be empty" severity error;
    end loop;
    POP_MACRO(retval);
    assert full = '0' 
      report "Empty queue should not be full" severity error;
    assert empty = '1' 
      report "Empty queue should be empty" severity error;

    -- Ensure queue maintains size
    push <= '0';
    pop <= '0';
    CYCLE(clock);
    assert full = '0' 
      report "Empty queue should not be full" severity error;
    assert empty = '1' 
      report "Empty queue should be empty" severity error;


    PUSH_MACRO("00001111");
    POP_MACRO(retval);
    assert retval = "00001111"
      report "Returned value should match pushed value" severity error;
    

    PUSH_MACRO("00000001");
    PUSH_MACRO("00000010");
    PUSH_MACRO("00000100");
    PUSH_MACRO("00001000");
    POP_MACRO(retval);
    assert retval = "00000001"
      report "FIFO Queue should maintain FIFO ordering" severity error;
    POP_MACRO(retval);
    assert retval = "00000010"
      report "FIFO Queue should maintain FIFO ordering" severity error;
    POP_MACRO(retval);
    assert retval = "00000100"
      report "FIFO Queue should maintain FIFO ordering" severity error;

    POP_MACRO(retval);
    assert retval = "00001000"
      report "FIFO Queue should maintain FIFO ordering" severity error;

    assert empty = '1'
      report "Queue should be empty here" severity error;

    PUSH_MACRO("00000001"); -- 1
    PUSH_MACRO("00000010"); -- 2
    PUSH_MACRO("00000100"); -- 3
    PUSH_MACRO("00001000"); -- 4
    PUSH_MACRO("00010000"); -- 5
    PUSH_MACRO("00100000"); -- 6
    PUSH_MACRO("01000000"); -- 7
    PUSH_MACRO("10000000"); -- 8
    assert full = '1'
      report "Queue should be full here"
      severity error;
    PUSH_MACRO("11111111"); -- Overflow
    PUSH_MACRO("11111111"); -- Overflow
    assert full = '1'
      report "Queue should be full after overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "00000001"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "00000010"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "00000100"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "00001000"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "00010000"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "00100000"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
   POP_MACRO(retval);
    assert retval = "01000000"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    POP_MACRO(retval);
    assert retval = "10000000"
      report "FIFO Queue should maintain FIFO ordering in the presence of overflow"
      severity error;
    assert empty = '1'
      report "Queue should be fully drained here"
      severity error;

    POP_MACRO(retval);
    assert retval = "10000000" -- Just keeps repeating last read value
      report "FIFO Queue should have dropped the overflow values"
      severity error;

    assert empty = '1'
      report "Queue should remain fully drained after over-emptying"
      severity error;
    assert full = '0'
      report "Queue should remain fully drained after over-emptying"
      severity error;

    PUSH_MACRO("11110000");

    assert empty = '0'
      report "Queue should work correctly after over-emptying"
      severity error;
    assert full = '0'
      report "Queue should work correctly after over-emptying"
      severity error;

    POP_MACRO(retval);
    assert retval = "11110000";
    assert empty = '1'
      report "Queue should become fully drained here"
      severity error;
    assert full = '0'
      report "Queue should become fully drained here"
      severity error;

    wait;
  end process;
end behavioural;
