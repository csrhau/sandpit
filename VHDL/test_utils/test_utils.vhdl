library ieee;
use ieee.std_logic_1164.all;

package test_utils is
  function sl2chr(sl: std_logic) return character;
  function slv2str(slv: std_logic_vector) return string;
end package test_utils;

package body test_utils is

   function sl2chr(sl: std_logic) return character is
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
   end sl2chr;

  function slv2str(slv: std_logic_vector) return string is
    variable result : string (1 to slv'length);
    variable r : integer;
  begin
    r := 1;
    for i in slv'range loop
      result(r) := sl2chr(slv(i));
      r := r + 1;
    end loop;
    return result;
  end slv2str;

end package body test_utils;
