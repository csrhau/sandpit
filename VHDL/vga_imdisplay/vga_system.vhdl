library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;
use work.init_funcs.all;

entity VGA_system is 
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
end entity VGA_system;

architecture structural of vga_system is 
  component VGA_ROM is 
    generic (
      contents : vga_memory
    );
    port (
      clock : in std_logic;
      address : in natural range vga_memory'range;
      data : out std_logic_vector(7 downto 0)
    );
  end component VGA_ROM;
  component vga_controller is
    generic (
      display_rows : natural := 480;
      display_cols : natural := 640
    );
    port (
      clock : in std_logic; -- 100 MHz Clock
      pixel_in : in std_logic_vector(7 downto 0);
      read_req : out std_logic := '0';
      read_address : out natural range vga_memory'range := 0;
      hsync : out std_logic := '0';
      vsync : out std_logic := '0';
      pixel_out : out std_logic_vector(7 downto 0) := (others => '0')
    );
  end component vga_controller;

  signal address_s : natural range vga_memory'range;
  signal pixel_data_s : std_logic_vector(7 downto 0);
  signal read_req_s : std_logic := '0';

begin

  MEMORY: VGA_ROM generic map (contents => read_file("images/f14.mif").all)
                  port map (
                    clock,
                    address_s, 
                    pixel_data_s
                  );

  CONTROLLER: vga_controller generic map (
                               display_rows,
                               display_cols
                             )
                             port map (
                               clock,
                               pixel_data_s,
                               read_req_s,
                               address_s,
                               hsync,
                               vsync,
                               pixel_out
                             );

end structural;
