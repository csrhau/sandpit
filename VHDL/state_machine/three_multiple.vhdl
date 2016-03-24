library ieee;
use ieee.std_logic_1164.all;
use work.three_multiple_types.all;

entity three_multiple is
  port (
    clock : in std_logic; -- Needs clocking, to detect if a solid '1' is actually a '11'
    input : in std_logic; 
    output : out std_logic;
    state : out three_state
  );
end entity three_multiple;

architecture behavioural of three_multiple is
  signal state_s : three_state := SAccept;
begin
  process(clock)
  begin
    if rising_edge(clock) then
      case state_s is
        when SAccept =>
          if input = '1' then
            state_s <= S1;
            output <= '0';
          else
            state_s <= SAccept;
            output <= '1';
          end if;
        when S1 =>
          if input = '1' then
            state_s <= SAccept;
            output <= '1';
          else
            state_s <= S2;
            output <= '0';
          end if;
        when S2 =>
          if input = '1' then
            state_s <= S2;
            output <= '0';
          else
            state_s <= S1;
            output <= '0';
          end if;
      end case;
    end if;
  end process;

  state <= state_s;
end behavioural;
