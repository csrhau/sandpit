library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;

entity vga_sequencer is
  generic (
    display_rows : natural := 480;
    display_cols : natural := 640
  );
  port (
    clock : in std_logic; -- 100 MHz Clock
    output_enable : out std_logic := '0';
    -- TODO make this out natural range vga_memory'range;
    read_address : out natural range vga_memory'range := 0;
    hsync : out std_logic := '1';
    vsync : out std_logic := '1'
 );
end vga_sequencer;

architecture behavioural of vga_sequencer is
  type sync_state is (SRead, SUpdate, SDelay1, SDelay2);
  signal state : sync_state := SDelay1; -- Give the system time to get ready

  constant H_PULSE_START : natural := display_cols + 16; -- front porch is 16 columns
  constant H_PULSE_END: natural := H_PULSE_START + 96; -- Pulse is 96 columns
  constant H_LINE_END: natural := H_PULSE_END + 48 - 1; -- back porch is 48 columns 

  constant V_PULSE_START : natural := display_rows + 10; -- front porch is 10 rows
  constant V_PULSE_END: natural := V_PULSE_START + 2; -- Pulse is 2 rows
  constant V_LINE_END: natural := V_PULSE_END + 33 - 1; -- back porch is 33 rows 

  signal h_count : natural range H_LINE_END downto 0 := 0;
  signal v_count : natural range V_LINE_END downto 0 := 0;

begin

  process(clock)
  begin
    if rising_edge(clock) then
      case state is
        when SRead =>
          if h_count < display_cols and v_count < display_rows then
            output_enable <= '1';
            read_address <= v_count * display_cols + h_count;
          else
            output_enable <= '0';
            read_address <= 0;
          end if;
          state <= SUpdate;
        when SUpdate =>
          if h_count >= H_PULSE_START and h_count < H_PULSE_END then
            hsync <= '0';
          else
            hsync <= '1';
          end if;
          if v_count >= V_PULSE_START and v_count < V_PULSE_END then
            vsync <= '0';
          else
            vsync <= '1';
          end if;
          -- UPDATE COUNTERS
          if h_count = H_LINE_END then
            h_count <= 0;
            if v_count = V_LINE_END then
              v_count <= 0;
            else
              v_count <= v_count + 1;
            end if;
          else -- not at a row/col border
            h_count <= h_count + 1;
          end if;
          state <= SDelay1;
        when SDelay1 =>
          state <= SDelay2;
        when SDelay2 =>
          state <= SRead;
      end case;
    end if; -- end rising_edge if
  end process;
end behavioural;
