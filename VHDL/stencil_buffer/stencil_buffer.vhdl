library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- NB in practice the stencil buffer shouldn't expose all these values;
-- More commonly, the stencil buffer will be a stencil engine, and produce
-- A single output based on some f(tl, tc, tr... br)
-- This file exists to help understand and iron out offsets

entity stencil_buffer is
  port (
    clock : in std_logic;
    advance: in std_logic;
    address: in std_logic_vector;
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
end entity stencil_buffer;

architecture behavioural of stencil_buffer is
  type direction_t is (NORTH_WEST, NORTH,  NORTH_EAST,
                       WEST,       CENTER,       EAST,
                       SOUTH_WEST, SOUTH,  SOUTH_EAST);

  function offset_addr(address: std_logic_vector; direction: direction_t) return natural is
    variable offset : natural range 1 to 9;
  begin
    case direction is
      when NORTH_WEST => offset := 9;
      when NORTH      => offset := 8;
      when NORTH_EAST => offset := 7;
      when WEST       => offset := 6;
      when CENTER     => offset := 5;
      when EAST       => offset := 4;
      when SOUTH_WEST => offset := 3;
      when SOUTH      => offset := 2;
      when SOUTH_EAST => offset := 1;
    end case;
    return to_integer(unsigned(address) - offset);
  end function offset_addr;

  type neighbourhood_t is array(integer range 0 to (2**address'length-1)) of std_logic_vector(input'range);
  signal neighbourhood : neighbourhood_t := (others => (others => '0'));
  signal head : std_logic_vector(address'range) := (others => '0');

begin
  SEQUENTIAL: process(clock) begin
    if rising_edge(clock) then
      if advance = '1' then
        neighbourhood(to_integer(unsigned(head))) <= input;
        head <= std_logic_vector(unsigned(head) + 1);
      end if;
    end if;
  end process;

  COMBI: process (head) begin
    tl <= neighbourhood(offset_addr(head, NORTH_WEST));
    tc <= neighbourhood(offset_addr(head, NORTH));
    tr <= neighbourhood(offset_addr(head, NORTH_EAST));
    ml <= neighbourhood(offset_addr(head, WEST));
    mc <= neighbourhood(offset_addr(head, CENTER));
    mr <= neighbourhood(offset_addr(head, EAST));
    bl <= neighbourhood(offset_addr(head, SOUTH_WEST));
    bc <= neighbourhood(offset_addr(head, SOUTH));
    br <= neighbourhood(offset_addr(head, SOUTH_EAST));
  end process;

end behavioural;
