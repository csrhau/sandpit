library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;
use std.textio.all;

package init_funcs is
  function read_file(data_file_name: string) return memory_16b;
end package init_funcs;

package body init_funcs is

  function read_file(data_file_name: string) return memory_16b is
    variable state : memory_16b;
    variable mem_temp : bit_vector(7 downto 0);
    file data_file : text open read_mode is data_file_name;
    variable data_line, output_line: line;
  begin
    for i in memory_16b'range loop
      readline(data_file, data_line);
      read(data_line, mem_temp);
      state(i) := to_stdlogicvector(mem_temp);
    end loop;
    return state;
  end function read_file;

end package body init_funcs;
