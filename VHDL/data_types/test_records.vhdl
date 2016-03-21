library ieee;
use ieee.std_logic_1164.all;

entity test_records is 
end test_records;

architecture behavioural of test_records is

  type pgm_header is record
    rows   : integer;
    cols   : integer;
    maxval : integer;
  end record;

  type pgm_payload is array(integer range <>, integer range <>) of integer range 0 to 255;

  type pgm_image is record
    header  : pgm_header;
    payload : pgm_payload(1 downto 0, 1 downto 0);
  end record;

  signal lena : pgm_image := (
    header => (
      rows => 2,
      cols => 2,
      maxval => 255
    ),
    payload => ((1,2),(3,4))
  );

  -- Can't seem to define board2 in terms of board1 :(.
begin
  process
  begin

    wait;
  end process;
end behavioural;
