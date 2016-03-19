library ieee;
use ieee.std_logic_1164.all;
use work.memory_types.all;
use work.init_funcs.all;
use std.textio.all;

entity test_init_funcs is
end test_init_funcs;

architecture behavioural of test_init_funcs is

begin
  process
    constant test_storage : memory_16b := (
      "11111111",
      "10000000",
      "10000000",
      "10000001",
      "00000001",
      "00001001",
      "00001000",
      "00001000",
      "00010100",
      "00001000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "11111111"
    );
    variable data : memory_16b;
  begin

    data := read_file("rom_lut.mif");
    assert data = test_storage
      report "data should match testcase" severity error;


    wait;
  end process;


end behavioural;
