library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;
use std.textio.all;


entity test_vga_controller is
end test_vga_controller;

architecture behavioural of test_vga_controller is
  component vga_controller is
    generic (
      display_rows : natural := 480;
      display_cols : natural := 640
    );
    port (
      clock : in std_logic; -- 100 MHz Clock
      pixel_in : in std_logic_vector(7 downto 0); -- Color returned from memory
      read_req : out std_logic := '0';
      read_address : out natural range vga_memory'range;
      hsync : out std_logic := '0';
      vsync : out std_logic := '0';
      pixel_out : out std_logic_vector(7 downto 0)
   );
  end component vga_controller;

  constant min_addr : std_logic_vector(18 downto 0) := (others => '0');

  signal clock, read_req, hsync, vsync : std_logic;
  signal pixel_in : std_logic_vector(7 downto 0);
  signal read_address: natural range vga_memory'range;
  signal pixel_out  : std_logic_vector(7 downto 0);


begin
  CONTROLLER: vga_controller generic map (display_rows => 4,
                                          display_cols => 4)
                             port map (clock,
                                       pixel_in,
                                       read_req, read_address, 
                                       hsync, vsync,
                                       pixel_out);
  process
    variable read_step : natural range vga_memory'range := 0;
    variable oline: line;
  begin

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Read -> Update
    wait for 1 ns;
    assert read_req = '1'
      report "Read state should requeste a read" severity error;

    assert read_address = read_step
      report "Read should have specified an address" severity error;

    read_step := 1;
    clock <= '0';
    wait for 1 ns;
    pixel_in <= "01010101";
    clock <= '1';  -- Update -> Delay1
    wait for 1 ns;
    assert read_req = '0'
      report "Update state should not request a read" severity error;
    assert pixel_out = "01010101"
      report "Display should have written a pixel_out value" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Delay1 -> Delay2
    wait for 1 ns;
    assert read_req = '0'
      report "Delay state should not request a read" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Delay2 -> Read
    wait for 1 ns;
    assert read_req = '0'
      report "Delay state should not request a read" severity error;


    for i in 1 to 50000 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1'; -- Delay2 -> Read
      wait for 1 ns;
    end loop;
   


    wait;
  end process;


end behavioural;
