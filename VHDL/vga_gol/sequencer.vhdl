-- Game of life Logic Unit (sequencer), part of a processing element
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequencer is 
  generic (
    rows : natural;
    addr_bits : natural
  );
  port (
    clock        : in std_logic;
    input : in std_logic_vector(9 downto 0);
    output: out std_logic_vector(8 downto 1);
    address : out std_logic_vector(addr_bits-1 downto 0);
    write_enable : out std_logic := '0'
  );
end entity sequencer;
 
architecture behavioural of sequencer is
  type SEQ_state is (SEQ_init, SEQ_first_row, SEQ_update, SEQ_advance, SEQ_flush);
  signal s_state : SEQ_state := SEQ_init;
  signal s_address_row : natural range 0 to rows-1 := rows-1;
begin
  process(clock)
  begin
    if rising_edge(clock) then
      case s_state is
        when SEQ_init => -- input contains ROW rows-1
          s_address_row <= 0;
          write_enable <= '0';
          s_state <= SEQ_first_row;
        when SEQ_first_row => -- input contains ROW 0
          s_address_row <= 1;
          write_enable <= '0';
          s_state <= SEQ_update;
        when SEQ_update => -- input contains ROW1 
          s_address_row <= s_address_row-1;
          write_enable <= '1';
          if s_address_row < rows - 1 then
            -- Continue to advance
            s_state <= SEQ_advance;
          else
            -- We have just read the last row
            s_state <= SEQ_flush;
          end if;
        when SEQ_advance => -- make address point to row 2
          s_address_row <= s_address_row + 2;
          write_enable <= '0';
          s_state <= SEQ_update;
        when SEQ_flush =>
          s_address_row <= rows-1;
          write_enable <= '1';
          s_state <= SEQ_init;


      end case;
    end if;
  end process;
  address  <= std_logic_vector(to_unsigned(s_address_row, address'length)); 
end behavioural;
