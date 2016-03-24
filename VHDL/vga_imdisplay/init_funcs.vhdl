library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;
use std.textio.all;

package init_funcs is
  function read_file(data_file_name: string) return vga_memory_ptr;
  function chr(sl: std_logic) return character;
  function str(slv: std_logic_vector) return string;
end package init_funcs;

package body init_funcs is

   function chr(sl: std_logic) return character is
    variable c: character;
    begin
      case sl is
         when 'U' => c:= 'U';
         when 'X' => c:= 'X';
         when '0' => c:= '0';
         when '1' => c:= '1';
         when 'Z' => c:= 'Z';
         when 'W' => c:= 'W';
         when 'L' => c:= 'L';
         when 'H' => c:= 'H';
         when '-' => c:= '-';
      end case;
    return c;
   end chr;

  function str(slv: std_logic_vector) return string is
    variable result : string (1 to slv'length);
    variable r : integer;
  begin
    r := 1;
    for i in slv'range loop
      result(r) := chr(slv(i));
      r := r + 1;
    end loop;
    return result;
  end str;


  function read_file(data_file_name: string) return vga_memory_ptr is
    variable state_ptr : vga_memory_ptr;
    variable data_line : line;
    variable text_line : line;
    variable pixel_value: natural range 255 downto 0;
    variable pixel_slv: std_logic_vector(7 downto 0);
    file data_file : text open read_mode is data_file_name;
  begin
    state_ptr := new vga_memory; 
    for i in vga_memory'reverse_range loop -- range would operate downto, and reverse the image! (this took 3 hours)
      readline(data_file, data_line);
      read(data_line, pixel_value);
      pixel_slv := std_logic_vector(to_unsigned(pixel_value, pixel_slv'length));
      state_ptr(i) := pixel_slv;
    end loop;
    return state_ptr;
  end function read_file;

end package body init_funcs;
