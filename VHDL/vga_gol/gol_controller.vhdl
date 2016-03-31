library ieee;
use ieee.std_logic_1164.all;

entity gol_controller is 
  generic (
    rows: natural
  );
  port (
    clock : in std_logic; 
    read_address
  );


