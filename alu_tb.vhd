library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;
entity alu_tb is end alu_tb;
architecture sim of alu_tb is
  signal a, b, y : std_logic_vector(7 downto 0) := (others => '0');
  signal sel : std_logic_vector(2 downto 0) := "000";
begin
  dut : entity work.alu port map (a, b, sel, y);
  process
    variable errors : integer := 0;
    procedure chk(av, bv : integer; s : std_logic_vector(2 downto 0); exp : integer; name : string) is
    begin
      a <= std_logic_vector(to_unsigned(av, 8)); b <= std_logic_vector(to_unsigned(bv, 8));
      sel <= s; wait for 10 ns;
      if to_integer(unsigned(y)) /= exp then
        report name & " failed: a=" & integer'image(av) & " b=" & integer'image(bv) &
               " got " & integer'image(to_integer(unsigned(y))) & " expected " & integer'image(exp)
               severity error;
        errors := errors + 1;
      end if;
    end procedure;
  begin
    chk(16#00#, 16#3C#, "000", 16#3C#, "LDI");
    chk(16#3C#, 16#0F#, "001", 16#4B#, "ADD");
    chk(16#FF#, 16#01#, "001", 16#00#, "ADD wrap");
    chk(16#4B#, 16#0B#, "010", 16#40#, "SUB");
    chk(16#00#, 16#01#, "010", 16#FF#, "SUB wrap");
    chk(16#4A#, 16#4A#, "010", 16#00#, "SUB zero");
    chk(16#40#, 16#F0#, "011", 16#40#, "AND");
    chk(16#AA#, 16#55#, "011", 16#00#, "AND zero");
    chk(16#40#, 16#0A#, "100", 16#4A#, "OR");
    chk(16#F0#, 16#0F#, "100", 16#FF#, "OR full");
    if errors = 0 then report "ALU_TB: ALL TESTS PASSED"; end if;
    wait;
  end process;
end sim;
