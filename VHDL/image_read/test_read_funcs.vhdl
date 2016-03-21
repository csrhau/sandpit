library ieee;
use ieee.std_logic_1164.all;
use work.pgm_types.all;
use work.read_funcs.all;
use std.textio.all;

entity test_read_funcs is
end test_read_funcs;

architecture behavioural of test_read_funcs is

begin
  process
    variable image : pgm_image := read_pgm_image("example.pgm");
    constant test_image : pixel_array(4 downto 0, 4 downto 0) := ((1,3,5,7,9),
                                                                  (2,2,1,1,1),
                                                                  (3,1,3,1,1),
                                                                  (4,1,1,4,1),
                                                                  (5,1,1,1,5));

  begin
    assert image.rows = 5
      report "image should show 5 rows" severity error;

    assert image.cols = 5
      report "image should show 5 cols" severity error;

    assert image.maxval = 255
      report "image should show 255 maxval" severity error;

   assert image.content.all = test_image
      report "image should match test image" severity error;

    wait;
  end process;


end behavioural;
