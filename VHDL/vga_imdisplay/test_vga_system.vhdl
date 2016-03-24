library ieee;
use ieee.std_logic_1164.all;

entity test_vga_system is
end test_vga_system;

architecture behavioural of test_vga_system is
  component VGA_system is 
    generic (
      display_rows : natural := 480;
      display_cols : natural := 640
    );
    port (
      clock : in std_logic; -- 100 MHz Clock
      hsync : out std_logic := '0';
      vsync : out std_logic := '0';
      pixel_out : out std_logic_vector(7 downto 0) := (others => '0')
   );
  end component VGA_system;

  signal clock : std_logic;
  signal hsync : std_logic;
  signal vsync : std_logic;
  signal pixel_out: std_logic_vector(7 downto 0);

begin
  SYSTEM: VGA_system port map (
                       clock,
                       hsync,
                       vsync,
                       pixel_out
                     );

  process
  begin
    for i in 1 to 500000 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1'; -- Delay2 -> Read
      wait for 1 ns;
    end loop;
    wait;
  end process;

end behavioural;
