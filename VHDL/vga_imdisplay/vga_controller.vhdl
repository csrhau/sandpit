library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_types.all;

entity vga_controller is
  generic (
    display_rows : natural := 480;
    display_cols : natural := 640
  );
  port (
    clock : in std_logic; -- 100 MHz Clock
    pixel_in : in std_logic_vector(7 downto 0);
    read_req : out std_logic := '0';
    -- TODO make this out natural range vga_memory'range;
    read_address : out natural range vga_memory'range;
    hsync : out std_logic := '0';
    vsync : out std_logic := '0';
    pixel_out : out std_logic_vector(7 downto 0) := (others => '0')
 );
end vga_controller;

architecture behavioural of vga_controller is
  type sync_state is (SRead, SUpdate, SDelay1, SDelay2);
  signal state : sync_state := SRead;

  constant H_PULSE_START : natural := display_cols + 16; -- front porch is 16 columns
  constant H_PULSE_END: natural := H_PULSE_START + 96; -- Pulse is 96 columns
  constant H_LINE_END: natural := H_PULSE_END + 48 - 1; -- back porch is 48 columns 

  constant V_PULSE_START : natural := display_rows + 10; -- front porch is 10 rows
  constant V_PULSE_END: natural := V_PULSE_START + 2; -- Pulse is 2 rows
  constant V_LINE_END: natural := V_PULSE_END + 33 - 1; -- back porch is 33 rows 

  signal h_count : natural range H_LINE_END downto 0 := 0;
  signal v_count : natural range V_LINE_END downto 0 := 0;

  signal s_read_req: std_logic := '0';

begin

  process(clock)
  begin
    if rising_edge(clock) then
      case state is
        when SRead =>
          if h_count < display_cols and v_count < display_rows then
            s_read_req <= '1';
            read_address <= v_count * display_cols + h_count;
          else
            s_read_req <= '0';
            read_address <= 0;
          end if;
          state <= SUpdate;
        when SUpdate =>
          if s_read_req = '1' then -- New pixel_out to display
            pixel_out <= pixel_in;
            s_read_req <= '0';
          else
            pixel_out <= "00000000";
          end if;

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
  read_req <= s_read_req;
end behavioural;
