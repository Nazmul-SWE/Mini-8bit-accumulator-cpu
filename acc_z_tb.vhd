library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity acc_z_tb is end acc_z_tb;
architecture sim of acc_z_tb is
  signal clk, reset, acc_we, z_we : std_logic := '0';
  signal d, q : std_logic_vector(7 downto 0) := (others => '0');
  signal z : std_logic;
  signal done : boolean := false;
begin
  dut : entity work.acc_z port map (clk, reset, acc_we, z_we, d, q, z);
  clk <= not clk after 5 ns when not done else '0';
  process
    variable errors : integer := 0;
    procedure step(dv : std_logic_vector(7 downto 0); aw, zw : std_logic;
                   expq : std_logic_vector(7 downto 0); expz : std_logic; name : string) is
    begin
      d <= dv; acc_we <= aw; z_we <= zw;
      wait until rising_edge(clk); wait for 1 ns;
      if q /= expq or z /= expz then
        report name & " failed" severity error; errors := errors + 1;
      end if;
    end procedure;
  begin
    reset <= '1';
    step(x"FF", '1', '1', x"00", '1', "Reset priority");
    reset <= '0';
    step(x"3C", '1', '1', x"3C", '0', "Load 3C");
    step(x"00", '1', '1', x"00", '1', "Load 00 sets Z");
    step(x"55", '0', '0', x"00", '1', "NOP holds");
    step(x"55", '1', '0', x"55", '1', "ACC only, Z unchanged");
    step(x"00", '0', '1', x"55", '1', "Z only");
    reset <= '1';
    step(x"AA", '1', '1', x"00", '1', "Reset again");
    if errors = 0 then report "ACC_Z_TB: ALL TESTS PASSED"; end if;
    done <= true; wait;
  end process;
end sim;
