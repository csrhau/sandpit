library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cell is
  generic (
    begin_alive : integer range 0 to 1 := 0
  );

  port (
    clock : in std_logic;
    nw, nn, ne : in integer range 0 to 1;
    ww,     ee : in integer range 0 to 1;
    sw, ss, se : in integer range 0 to 1;
    alive: out integer range 0 to 1 := begin_alive
  );
end cell;

architecture behavioural of cell is
  signal alive_s : integer range 0 to 1 := begin_alive;
begin
  process (clock)
    variable neighbours : natural range 0 to 8 := 0;
  begin
    if rising_edge(clock) then
      neighbours := nw + nn + ne + ww + ee + sw + ss + se;
      if neighbours = 3 or (neighbours = 2 and alive_s = 1) then
        alive_s <= 1;
      else
        alive_s <= 0;
      end if;
    end if;
  end process;

  alive <= alive_s;
end behavioural;
