-- Step 7: Testbench. Clock, RESET for one rising edge, then run 7 instructions
-- and check ACC / Z / next-PC against Appendix B (Set 1).
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_tb is end cpu_tb;

architecture sim of cpu_tb is
  signal clk, reset, z : std_logic := '0';
  signal q    : std_logic_vector(7 downto 0);
  signal pc_o : std_logic_vector(3 downto 0);
  signal done : boolean := false;

  -- VHDL-93 replacement for to_hstring (ISE does not support VHDL-2008)
  function to_hex(v : std_logic_vector) return string is
    constant HEX : string(1 to 16) := "0123456789ABCDEF";
    variable n   : integer := (v'length + 3) / 4;
    variable pad : std_logic_vector(n*4-1 downto 0) := (others => '0');
    variable res : string(1 to n);
    variable nib : integer;
  begin
    pad(v'length-1 downto 0) := v;
    for i in 1 to n loop
      nib := 0;
      for j in 3 downto 0 loop
        nib := nib * 2;
        if pad((n-i)*4 + j) = '1' then nib := nib + 1; end if;
      end loop;
      res(i) := HEX(nib + 1);
    end loop;
    return res;
  end function;

  type exp_acc_t is array (0 to 7) of std_logic_vector(7 downto 0);
  type exp_z_t   is array (0 to 7) of std_logic;
  type exp_pc_t  is array (0 to 7) of std_logic_vector(3 downto 0);
  constant EXP_ACC : exp_acc_t := (x"00",x"3C",x"4B",x"40",x"40",x"4A",x"00",x"FF");
  constant EXP_Z   : exp_z_t   := ('1','0','0','0','0','0','1','0');
  constant EXP_PC  : exp_pc_t  := (x"0",x"1",x"2",x"3",x"4",x"5",x"6",x"7");
begin
  dut : entity work.cpu port map (clk, reset, q, z, pc_o);

  clk <= not clk after 5 ns when not done else '0';

  stim : process
    variable errors : integer := 0;
  begin
    reset <= '1';
    wait until rising_edge(clk);          -- cycle 0: RESET edge
    wait for 1 ns; reset <= '0';
    for i in 0 to 7 loop
      if i > 0 then wait until rising_edge(clk); wait for 1 ns; end if;
      report "Cycle " & integer'image(i) & "  ACC=" & to_hex(q) &
             "  Z=" & std_logic'image(z) & "  nextPC=" & to_hex(pc_o);
      if q /= EXP_ACC(i) or z /= EXP_Z(i) or pc_o /= EXP_PC(i) then
        report "MISMATCH at cycle " & integer'image(i) severity error;
        errors := errors + 1;
      end if;
    end loop;
    if errors = 0 then report "ALL TESTS PASSED" severity note;
    else report integer'image(errors) & " MISMATCHES" severity failure; end if;
    done <= true;
    wait;
  end process;
end sim;
