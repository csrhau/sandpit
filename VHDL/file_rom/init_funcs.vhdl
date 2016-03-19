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
    constant test_storage : memory_16b := (
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
