library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIFO is 
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
end entity fifo;

architecture behavioural of FIFO is
  type FIFO_storage is array(0 to addr_bits**2 - 1) of std_logic_vector(7 downto 0);
  signal storage : FIFO_storage := (others => (others => '0'));
  signal head : std_logic_vector(addr_bits-1 downto 0) := (others => '0');
  signal tail : std_logic_vector(addr_bits-1 downto 0) := (others => '0');
  signal s_empty : std_logic := '1';
  signal s_full : std_logic := '0';
  type FIFO_op is (OP_POP, OP_PUSH);
  signal last_op: FIFO_op := OP_POP;
begin
  SEQUENTIAL : process(clock)
  begin
    if rising_edge(clock) then
      if pop = '1' and s_empty = '0' then
        tail <= std_logic_vector(unsigned(tail) + 1);
        last_op <= OP_POP;
        output <= storage(to_integer(unsigned(tail))); 
      elsif push = '1' and s_full = '0' then
        storage(to_integer(unsigned(head))) <= input;
        head <= std_logic_vector(unsigned(head) + 1);
        last_op <= OP_PUSH;
      end if;
    end if;
  end process SEQUENTIAL;

  -- Combinatorial logic
  COMBINATORIAL : process(head, tail, last_op)
  begin
    -- Full and empty flags --
    if head = tail then
      if last_op = OP_POP then
        s_full <= '0';
        s_empty <= '1';
      else -- OP_PUSH
        s_full <= '1';
        s_empty <= '0';
      end if;
    else
      s_full  <= '0';
      s_empty <= '0';
    end if;
  end process COMBINATORIAL;

  -- Combinatorial signal mappings
  empty <= s_empty;
  full <= s_full;
end behavioural;
