library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity test_typecasts is
end test_typecasts;

architecture behavioural of test_typecasts is
  constant natural_value : natural range 255 downto 0 := 164;
  constant slv_value : std_logic_vector(7 downto 0) := "10100100";



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



begin 


  process
    variable natural_holder : natural range 255 downto 0;
    variable slv_holder : std_logic_vector(7 downto 0);
    variable oline: line;
  begin

    natural_holder := to_integer(unsigned(slv_value));
    assert natural_holder = natural_value
      report "1 natural and slv should match" severity error;

    slv_holder := std_logic_vector(to_unsigned(natural_value, slv_holder'length));
    assert slv_holder = slv_value
      report "2 slv and natural should match" severity error;

    write(oline, str(slv_holder));
    write(oline, '=');
    write(oline, str(slv_value));
    writeline(output, oline);

   

    wait;
  end process;


end behavioural;
