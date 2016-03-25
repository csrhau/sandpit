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
    hsync : out std_logic;
    vsync : out std_logic;
    red : out std_logic_vector(2 downto 0) := (others => '0');
    green : out std_logic_vector(2 downto 0) := (others => '0');
    blue : out std_logic_vector(2 downto 1) := (others => '0')
 );
end entity VGA_system;

architecture structural of vga_system is 
  component VGA_ROM is 
    generic (
      contents : vga_memory
    );
    port (
      clock : in std_logic;
      enable: in std_logic;
      address : in natural range vga_memory'range;
      data : out std_logic_vector(7 downto 0)
    );
  end component VGA_ROM;
  component vga_sequencer is
    generic (
      display_rows : natural := 480;
      display_cols : natural := 640
    );
    port (
      clock : in std_logic; -- 100 MHz Clock
      output_enable : out std_logic;
      read_address : out natural range vga_memory'range;
      hsync : out std_logic;
      vsync : out std_logic
    );
  end component vga_sequencer;

  signal address : natural range vga_memory'range;
  signal output_enable : std_logic;
  signal pixel_out : std_logic_vector(7 downto 0);

begin

  MEMORY: VGA_ROM generic map (contents => read_file("images/f14.mif").all)
                  port map (
                    clock,
                    output_enable,
                    address, 
                    pixel_out
                  );

  SEQUENCER: vga_sequencer generic map (
                              display_rows,
                              display_cols
                            )
                            port map (
                              clock,
                              output_enable,
                              address,
                              hsync, 
                              vsync
                            );

  -- Split color channels
  red <= pixel_out(7 downto 5);
  green <= pixel_out(4 downto 2);
  blue <= pixel_out(1 downto 0);

end structural;
