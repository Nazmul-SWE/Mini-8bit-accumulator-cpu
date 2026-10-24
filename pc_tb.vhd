library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;
entity pc_tb is end pc_tb;
architecture sim of pc_tb is
  signal clk, reset : std_logic := '0';
  signal pc_out : std_logic_vector(3 downto 0);
  signal done : boolean := false;
begin
  dut : entity work.pc port map (clk, reset, pc_out);
  clk <= not clk after 5 ns when not done else '0';
  process
    variable errors : integer := 0;
  begin
    reset <= '1'; wait until rising_edge(clk); wait for 1 ns;
    assert pc_out = x"0" report "Reset failed" severity error;
    reset <= '0';
    for i in 1 to 17 loop                       -- counts up and wraps 15 -> 0
      wait until rising_edge(clk); wait for 1 ns;
      if pc_out /= std_logic_vector(to_unsigned(i mod 16, 4)) then
        report "PC mismatch at step " & integer'image(i) severity error; errors := errors + 1;
      end if;
    end loop;
    reset <= '1'; wait until rising_edge(clk); wait for 1 ns;   -- reset mid-run
    if pc_out /= x"0" then report "Mid-run reset failed" severity error; errors := errors + 1; end if;
    if errors = 0 then report "PC_TB: ALL TESTS PASSED"; end if;
    done <= true; wait;
  end process;
end sim;
