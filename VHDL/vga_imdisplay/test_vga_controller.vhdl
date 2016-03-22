library ieee;
use ieee.std_logic_1164.all;

entity test_vga_controller is
end test_vga_controller;

architecture behavioural  of test_vga_controller is
  component vga_sync is
    generic (
      display_rows : integer;
      display_cols : integer;
      display_color : std_logic_vector(7 downto 0)
    );
    port (
      clock : in std_logic;
      hsync : out std_logic;
      vsync : out std_logic;
      red : out STD_LOGIC_VECTOR (2 downto 0);
      green : out STD_LOGIC_VECTOR (2 downto 0);
      blue : out STD_LOGIC_VECTOR (2 downto 1)
   );
  end component vga_sync;

  signal clock  : std_logic;
  signal hsync  : std_logic;
  signal vsync  : std_logic;
  signal pixel  : std_logic_vector(7 downto 0);

begin
  VGA_OUTPUT: vga_sync generic map(6, 4, "00011100")
                       port map (clock,
                                 hsync,
                                 vsync,
                                 pixel(7 downto 5),
                                 pixel(4 downto 2),
                                 pixel(1 downto 0));
  process
  begin


    for i in 1 to 50000 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    wait;
  end process;

end behavioural;
