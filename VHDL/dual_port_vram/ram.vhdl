library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is 
  port (
    clock   : in std_logic;
    -- Port a has read and write
    a_addr  : in std_logic_vector(9 downto 0);
    a_write : in std_logic; 
    a_din   : in std_logic_vector(7 downto 0); 
    a_dout  : out std_logic_vector(7 downto 0);
    -- Port b is read only
    b_addr  : in std_logic_vector(9 downto 0);
    b_dout  : out std_logic_vector(7 downto 0)
  );
end entity RAM;

architecture behavioural of RAM is
  type memory is array(0 to 1023) of std_logic_vector(7 downto 0);
  signal storage : memory := (others => (others => '0'));
 begin
  process(clock)
  begin
    if rising_edge(clock) then
      a_dout <= storage(to_integer(unsigned(a_addr)));
      b_dout <= storage(to_integer(unsigned(b_addr)));
      if a_write = '1' then
        storage(to_integer(unsigned(a_addr))) <= a_din;
      end if;
    end if;
  end process;
end behavioural;
