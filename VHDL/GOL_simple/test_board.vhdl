library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.board_config.all;
use std.textio.all;


entity test_board is 
end test_board;


architecture behavioural of test_board is
  constant GLIDER: board_state := ((0, 0, 0, 0, 0, 0),
                                   (0, 0, 1, 0, 0, 0),
                                   (0, 0, 0, 1, 0, 0),
                                   (0, 1, 1, 1, 0, 0),
                                   (0, 0, 0, 0, 0, 0),
                                   (0, 0, 0, 0, 0, 0));

  component board is 
    generic (
      init_state : board_state
    );
    port (
      clock : in std_logic;
      state : out board_state
    );
  end component;

  procedure print_state(mat: board_state) is
    variable l : line;  
  begin
    writeline (output, l);
    for i in ROWS downto 0 loop
      for j in COLS downto 0 loop
        write (l, ' ');
        write (l, mat(i,j));
      end loop;
      writeline (output, l);
    end loop;
  end print_state;



  signal clock: std_logic;
  signal interconnect: board_state;
begin 

  testboard: board generic map (init_state => GLIDER)
                   port map (clock, interconnect);

  process 
    constant T0: board_state := GLIDER;
    constant T1: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 1, 0, 1, 0, 0),
                                 (0, 0, 1, 1, 0, 0),
                                 (0, 0, 1, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0));

    constant T2: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 1, 0, 0),
                                 (0, 1, 0, 1, 0, 0),
                                 (0, 0, 1, 1, 0, 0),
                                 (0, 0, 0, 0, 0, 0));

    constant T3: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 0, 1, 0, 0, 0),
                                 (0, 0, 0, 1, 1, 0),
                                 (0, 0, 1, 1, 0, 0),
                                 (0, 0, 0, 0, 0, 0));

    -- T4 is the end of a cycle - glider is period 4. 
    constant T4: board_state := ((0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 0, 0, 0),
                                 (0, 0, 0, 1, 0, 0),
                                 (0, 0, 0, 0, 1, 0),
                                 (0, 0, 1, 1, 1, 0),
                                 (0, 0, 0, 0, 0, 0));
  
begin
  wait for 1 ns; -- setup and hold time
  -- Starts in correct initial state
  assert interconnect = T0
    report "Board should start in glider configuration"
    severity error;
    
    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T1
      report "Board should proceed to state T1" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T2
      report "Board should proceed to state T2" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T3
      report "Board should proceed to state T3" severity error;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    assert interconnect = T4
      report "Board should proceed to state T4" severity error;

    -- At this point we've proven the glider progresses through one of its cycles, 
    -- but we still need to see it navigate the entire space and return to start.
    -- This takes an extra 16 steps.

    for i in 1 to 16 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
      print_state(interconnect);
    end loop;
    assert interconnect = T0
        report "Board should proceed to state T4" severity error;

  wait;
end process;


end behavioural;
