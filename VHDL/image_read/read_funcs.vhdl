library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.pgm_types.all;

package read_funcs is

  function read_pgm_image(pgm_file_name: string) return pgm_image;

end package read_funcs;

package body read_funcs is

  function read_pgm_image(pgm_file_name: string) return pgm_image is
    variable image : pgm_image;
    variable int_temp : integer;
    variable pgm_line : line;
    file pgm_file : text open read_mode is pgm_file_name;
  begin
    readline(pgm_file, pgm_line); -- HEADER - TODO check it says pgm
    readline(pgm_file, pgm_line); -- ROWS COLS
    read(pgm_line, image.rows);
    read(pgm_line, image.cols);
    readline(pgm_file, pgm_line); -- MAXVAL
    read(pgm_line, image.maxval);
    -- Begin reading actual data
    image.content := new pixel_array(image.rows-1 downto 0, image.cols-1 downto 0);
    ROW: for r in image.rows-1 downto 0 loop
      readline(pgm_file, pgm_line);
      COL: for c in image.cols-1 downto 0 loop
        read(pgm_line, int_temp);
        image.content(r, c) :=  int_temp;
      end loop COL;
    end loop ROW;
    file_close(pgm_file);
    return image;
  end function read_pgm_image;

end package body read_funcs;
