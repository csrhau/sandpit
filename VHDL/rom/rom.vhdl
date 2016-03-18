library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is 
  port (
    clock : in std_logic;
    address : in std_logic_vector(3 downto 0);
    data : out std_logic_vector(7 downto 0)
  );
end entity ROM;


architecture behavioural of ROM is
  type memory is array (15 downto 0) of std_logic_vector(7 downto 0);
  constant storage : memory := (
    0  => "00000000",
    1  => "00000001",
    2  => "00000010",
    3  => "00000011",
    4  => "00000100",
    5  => "11110000",
    6  => "11110000",
    7  => "11110000",
    8  => "11110000",
    9  => "11110000",
    10 => "11110000",
    11 => "11110000",
    12 => "11110000",
    13 => "11110000",
    14 => "11110000",
    15 => "11110000"
  );
begin

  process(clock)
  begin
    if rising_edge(clock) then
        data <= storage(to_integer(unsigned(address))); 
    end if;
  end process;
end behavioural;


