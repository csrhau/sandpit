library ieee;
use ieee.std_logic_1164.all;

package pgm_types is


  subtype pixel is natural range 255 downto 0; 
  type pixel_array is array(natural range <>, natural range <>) of pixel;
  type pixel_array_ptr is access pixel_array;

  type pgm_header is record
    rows   : natural;
    cols   : natural;
    maxval : natural;
  end record;

  type pgm_image is record
    rows    : natural;
    cols    : natural;
    maxval  : natural;
    content : pixel_array_ptr;
  end record;

end package pgm_types;
