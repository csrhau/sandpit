library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity file_RAM is 
  generic (
    filename: string
  );
  port (
    clock : in std_logic;
    write_enable : in std_logic; 
    address : in std_logic_vector;
    data_in : in std_logic_vector;
    data_out : out std_logic_vector
  );
end entity file_RAM;

architecture behavioural of file_RAM is
  type memory is array(integer range 0 to (2**address'length-1)) of std_logic_vector(data_in'range);

  function read_file(filename: string) return memory is
    variable contents : memory;
    variable mem_temp : bit_vector(data_in'range);
    file data_file : text open read_mode is filename;
    variable data_line, output_line: line;
  begin
    for i in memory'range loop
      readline(data_file, data_line);
      read(data_line, mem_temp);
      contents(i) := to_stdlogicvector(mem_temp);
    end loop;
    return contents;
  end function read_file;

  signal storage : memory := read_file(filename);
 begin
  process(clock)
  begin
    if rising_edge(clock) then
      data_out <= storage(to_integer(unsigned(address))); 
      if write_enable = '1' then
        storage(to_integer(unsigned(address))) <= data_in;
      end if;
    end if;
  end process;
end behavioural;
