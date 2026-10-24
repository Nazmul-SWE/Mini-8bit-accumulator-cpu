library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;
entity rom_tb is end rom_tb;
architecture sim of rom_tb is
  signal addr  : std_logic_vector(3 downto 0) := (others => '0');
  signal instr : std_logic_vector(11 downto 0);
  type exp_t is array (0 to 15) of std_logic_vector(11 downto 0);
  constant EXP : exp_t := (x"13C",x"20F",x"30B",x"4F0",x"50A",x"34A",x"301",
                           others => x"000");
begin
  dut : entity work.rom port map (addr, instr);
  process
    variable errors : integer := 0;
  begin
    for i in 0 to 15 loop
      addr <= std_logic_vector(to_unsigned(i, 4)); wait for 10 ns;
      if instr /= EXP(i) then
        report "ROM mismatch at address " & integer'image(i) severity error; errors := errors + 1;
      end if;
    end loop;
    if errors = 0 then report "ROM_TB: ALL TESTS PASSED"; end if;
    wait;
  end process;
end sim;
