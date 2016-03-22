library ieee;
use ieee.std_logic_1164.all;

entity vga_sync is
  generic (
    display_rows : integer := 640;
    display_cols : integer := 480;
    display_color : std_logic_vector(7 downto 0) := "11111111"
  );
  port (
    clock : in std_logic;
    hsync : out std_logic := '0';
    vsync : out std_logic := '0';
    red : out STD_LOGIC_VECTOR (2 downto 0);
    green : out STD_LOGIC_VECTOR (2 downto 0);
    blue : out STD_LOGIC_VECTOR (2 downto 1)
 );
end vga_sync;

architecture behavioural of vga_sync is

  constant H_PULSE_START : integer := display_cols + 16; -- front porch is 16 columns
  constant H_PULSE_END: integer := H_PULSE_START + 96; -- Pulse is 96 columns
  constant H_LINE_END: integer := H_PULSE_END + 48 - 1; -- back porch is 48 columns 

  constant V_PULSE_START : integer := display_rows + 10; -- front porch is 10 rows
  constant V_PULSE_END: integer := V_PULSE_START + 2; -- Pulse is 2 rows
  constant V_LINE_END: integer := V_PULSE_END + 33 - 1; -- back porch is 33 rows 

  signal h_count : integer range H_LINE_END downto 0 := 0;
  signal v_count : integer range V_LINE_END downto 0 := 0;

begin

  process(clock)
  begin
    if rising_edge(clock) then
      if h_count < display_cols and v_count < display_rows then
        red <= display_color(7 downto 5);
        green <= display_color(4 downto 2);
        blue <= display_color(1 downto 0);
      else
        red <= "000";
        green <= "000";
        blue <= "00";
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
    end if;
  end process;

end behavioural;
