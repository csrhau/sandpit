package board_config is
  constant ROWS: integer := 5;
  constant COLS: integer := 5;
  type board_state is array(ROWS downto 0, COLS downto 0) of integer range 0 to 1;
end package board_config;
