library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;
use std.textio.all;


entity test_vga_sequencer is
end test_vga_sequencer;

architecture behavioural of test_vga_sequencer is
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

  constant min_addr : std_logic_vector(18 downto 0) := (others => '0');

  signal clock, output_enable, hsync, vsync : std_logic;
  signal read_address: natural range vga_memory'range;

begin
  SEQUENCER: vga_sequencer generic map (
                             display_rows => 4,
                             display_cols => 4
                           )
                            port map (
                              clock,
                              output_enable,
                              read_address, 
                              hsync,
                              vsync
                            );
  process
    variable read_step : natural range vga_memory'range := 0;
    variable oline: line;
  begin

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Delay1 -> Delay2
    wait for 1 ns;
    assert output_enable = '0'
      report "Delay state should not request a read" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Delay2 -> Read
    wait for 1 ns;
    assert output_enable = '0'
      report "Delay state should not request a read" severity error;



    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Read -> Update
    wait for 1 ns;
    assert output_enable = '1'
      report "Read state should requeste a read" severity error;

    assert read_address = read_step
      report "Read should have specified an address" severity error;

    read_step := 1;
    clock <= '0';
    wait for 1 ns;
    clock <= '1';  -- Update -> Delay1
    wait for 1 ns;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Delay1 -> Delay2
    wait for 1 ns;
    assert output_enable = '1'
      report "Read request should remain active" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1'; -- Delay2 -> Read
    wait for 1 ns;
    assert output_enable = '1'
      report "Read enable should remain activ" severity error;



    wait;
  end process;


end behavioural;
