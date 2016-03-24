library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;
use work.init_funcs.all;
use std.textio.all;


entity test_init_funcs is
end test_init_funcs;

architecture behavioural of test_init_funcs is
begin
  process
    variable data_ptr : vga_memory_ptr;
    variable data : vga_memory;
    variable result : integer;
    variable oline: line;
  begin
    data_ptr := read_file("images/f14.mif");
    data := data_ptr.all;

   assert data(0) ="10100100"
      report "Data should match test case" severity error;
   assert data(1) ="10100100"
      report "Data should match test case" severity error;
   assert data(2) ="10100010"
      report "Data should match test case" severity error;

    wait;
  end process;
end behavioural;
