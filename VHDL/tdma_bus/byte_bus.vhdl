library ieee;
use ieee.std_logic_1164.all;

entity byte_bus is 
  generic (
    bus_length : natural
  );
  port ( 
    clock : in std_logic;
    data : out std_logic_vector(7 downto 0)
  );
end entity byte_bus;

architecture structural of byte_bus is
  component bus_writer is 
    generic (
      bus_length : natural;
      bus_index : natural;
      value : std_logic_vector(7 downto 0)
    );
    port ( 
      clock : in std_logic;
      data : out std_logic_vector(7 downto 0)
    );
  end component bus_writer;

begin 
  BUS_ELEMENT:
  for bus_index in bus_length-1 downto 0 generate
    element: bus_writer generic map (
                          bus_length,
                          bus_index, 
                          "11110000" 
                        ) port map (
                          clock,
                          data
                        );
  end generate BUS_ELEMENT;
end structural;
