library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;
entity control_tb is end control_tb;
architecture sim of control_tb is
  signal opcode  : std_logic_vector(3 downto 0) := (others => '0');
  signal alu_sel : std_logic_vector(2 downto 0);
  signal acc_we, z_we : std_logic;
begin
  dut : entity work.control port map (opcode, alu_sel, acc_we, z_we);
  process
    variable errors : integer := 0;
    procedure chk(op : integer; sel : std_logic_vector(2 downto 0); en : std_logic) is
    begin
      opcode <= std_logic_vector(to_unsigned(op, 4)); wait for 10 ns;
      if acc_we /= en or z_we /= en or (en = '1' and alu_sel /= sel) then
        report "Control mismatch for opcode " & integer'image(op) severity error;
        errors := errors + 1;
      end if;
    end procedure;
  begin
    chk(0, "000", '0');   -- NOP
    chk(1, "000", '1');   -- LDI
    chk(2, "001", '1');   -- ADD
    chk(3, "010", '1');   -- SUB
    chk(4, "011", '1');   -- AND
    chk(5, "100", '1');   -- OR
    for op in 6 to 15 loop chk(op, "000", '0'); end loop;  -- unused -> NOP
    if errors = 0 then report "CONTROL_TB: ALL TESTS PASSED"; end if;
    wait;
  end process;
end sim;
