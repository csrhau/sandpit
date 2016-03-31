-- Game of life Logic Unit (GLU), part of a processing element
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity GLU is 
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
end entity GLU;
    
architecture behavioural of GLU is 
  type GLU_state is (GLU_INIT, GLU_FIRST, GLU_ROW, GLU_LAST);
  signal state : GLU_STATE := GLU_INIT;
  signal input_row : natural range 0 to rows-1 := rows - 1;
  signal output_row : natural range 0 to rows-1 := rows - 2;
  signal cycle_buffer : std_logic_vector(9 downto 0);
  signal prev : std_logic_vector(9 downto 0);
  signal curr : std_logic_vector(9 downto 0);
begin
  process(clock)
  begin
    if rising_edge(clock) then
      case state is
        when GLU_INIT  => -- PRECONDITION: input_row = rows-1
                          -- POSTCONDITION: input_row = 0
                          -- POSTCONDITION: prev holds line rows-1
          prev <= input;
          input_row <= 0;
          state <= GLU_FIRST;
        when GLU_FIRST =>
          -- PRECONDITION: input_row = 0
          -- PRECONDITION: prev holds line rows-1
          -- POSTCONDITION: curr holds line 0
          -- POSTCONDITION: cycle_buffer holds line 0
          -- POSTCONDITION: INPUT_ROW = 1
          curr <= input;
          cycle_buffer <= input;
          input_row <= 1;
          state <= GLU_ROW;
        when GLU_ROW  =>
          -- Normal row processing, read in next row, output value of current
          if input_row = rows - 1 then
            state <= GLU_LAST;
          else
            input_row <= input_row + 1;
          end if;
        when GLU_LAST  => 
          -- Don't bother reading row zero, update based on period_buffer;
          state <= GLU_FIRST;
      end case;
      output_row <= input_row;
    end if;
  end process;
  read_address <= std_logic_vector(to_unsigned(input_row, read_address'length)); 
  write_address <= std_logic_vector(to_unsigned(output_row, write_address'length)); 
end behavioural;
