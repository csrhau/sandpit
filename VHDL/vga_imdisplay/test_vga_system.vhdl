library ieee;
use ieee.std_logic_1164.all;
use work.init_funcs.all;
use std.textio.all;

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
    variable vsync_holder : std_logic;
    variable hsync_holder : std_logic;
    variable log_line, data_line : line;
    file file_pointer: text is out "vga_log.txt";

  begin
    for i in 1 to 2000000 loop
      vsync_holder := vsync;
      clock <= '0';
      wait for 5 ns;
      clock <= '1'; -- Delay2 -> Read
      wait for 5 ns;
      clock <= '0';
      wait for 5 ns;
      clock <= '1'; -- Read -> Update
      wait for 5 ns;
       clock <= '0';
      wait for 5 ns;
      clock <= '1'; -- Update -> Delay1
      wait for 5 ns;
 
      write(data_line, now); -- write the line.
      write(data_line, ':'); -- write the line.

      -- Write the hsync
      write(data_line, ' ');
      write(data_line, chr(hsync)); -- write the line.

      -- Write the vsync
      write(data_line, ' ');
      write(data_line, chr(vsync)); -- write the line.

      -- Write the red
      write(data_line, ' ');
      write(data_line, str(red)); -- write the line.

      -- Write the green
      write(data_line, ' ');
      write(data_line, str(green)); -- write the line.

      -- Write the blue
      write(data_line, ' ');
      write(data_line, str(blue)); -- write the line.

      writeline(file_pointer, data_line); -- write the contents into the file.


      clock <= '0';
      wait for 5 ns;
      clock <= '1'; -- Delay1 -> Delay2
      wait for 5 ns;
 
    end loop;
    wait;
  end process;

end behavioural;
