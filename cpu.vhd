-- Step 6: Top level. Connects PC, ROM, Control, ALU, ACC/Z.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu is
  port ( clk, reset : in  std_logic;
         q          : out std_logic_vector(7 downto 0);  -- ACC
         z          : out std_logic;
         pc_o       : out std_logic_vector(3 downto 0) );
end cpu;

architecture structural of cpu is
  signal pc_s    : std_logic_vector(3 downto 0);
  signal instr   : std_logic_vector(11 downto 0);
  signal alu_sel : std_logic_vector(2 downto 0);
  signal acc_we, z_we : std_logic;
  signal acc_s, alu_y : std_logic_vector(7 downto 0);
begin
  u_pc  : entity work.pc     port map (clk, reset, pc_s);
  u_rom : entity work.rom    port map (pc_s, instr);
  u_ctl : entity work.control port map (instr(11 downto 8), alu_sel, acc_we, z_we);
  u_alu : entity work.alu    port map (acc_s, instr(7 downto 0), alu_sel, alu_y);
  u_reg : entity work.acc_z  port map (clk, reset, acc_we, z_we, alu_y, acc_s, z);
  q    <= acc_s;
  pc_o <= pc_s;
end structural;
