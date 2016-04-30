library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.test_utils.all;


entity test_test_utils is
end test_test_utils;


architecture behavioural of test_test_utils is
begin
  process
    variable test_chr : character;
    variable test_str : string(1 to 8);
  begin

    test_chr := '0';
    assert sl2chr('0') = test_chr report "Mismatch" severity error;
    test_chr := '1';
    assert sl2chr('1') = test_chr report "Mismatch" severity error;
    test_chr := 'X';
    assert sl2chr('X') = test_chr report "Mismatch" severity error;
    test_chr := 'U';
    assert sl2chr('U') = test_chr report "Mismatch" severity error;
    test_chr := 'H';
    assert sl2chr('H') = test_chr report "Mismatch" severity error;
    test_chr := 'L';
    assert sl2chr('L') = test_chr report "Mismatch" severity error;
    test_chr := 'Z';
    assert sl2chr('Z') = test_chr report "Mismatch" severity error;
    test_chr := '-';
    assert sl2chr('-') = test_chr report "Mismatch" severity error;
    -- Sanity check to make sure that I'm not just comparing chars (should not compile)
    -- test_chr := 'Y';
    -- assert sl2chr('Y') = test_chr report "Mismatch" severity error;

    test_str := "01XUHLZ-";
    assert slv2str("01XUHLZ-") = test_str report "Mismatch" severity error;

    test_str := "01010101";
    assert slv2str("01010101") = test_str report "Mismatch" severity error;


    wait;
  end process;
end behavioural;
