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
      hsync : out std_logic;
      vsync : out std_logic;
      red : out std_logic_vector(2 downto 0);
      green : out std_logic_vector(2 downto 0);
      blue : out std_logic_vector(2 downto 1)
   );
  end component VGA_system;

  signal clock : std_logic;
  signal hsync : std_logic;
  signal vsync : std_logic;
  signal red : std_logic_vector(2 downto 0);
  signal green : std_logic_vector(2 downto 0);
  signal blue : std_logic_vector(2 downto 1);

begin
  SYSTEM: VGA_system port map (
                       clock,
                       hsync,
                       vsync,
                       red,
                       green,
                       blue
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
