-- Step 3: Control Unit. Decodes opcode -> ALU select + write enables.
-- alu_sel: 000 pass imm (LDI) | 001 ADD | 010 SUB | 011 AND | 100 OR
-- Anything else (incl. 0000) is NOP: no enables asserted.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
  port ( opcode  : in  std_logic_vector(3 downto 0);
         alu_sel : out std_logic_vector(2 downto 0);
         acc_we  : out std_logic;
         z_we    : out std_logic );
end control;

architecture rtl of control is
begin
  process(opcode)
  begin
    alu_sel <= "000"; acc_we <= '1'; z_we <= '1';
    case opcode is
      when "0001" => alu_sel <= "000";   -- LDI
      when "0010" => alu_sel <= "001";   -- ADD
      when "0011" => alu_sel <= "010";   -- SUB
      when "0100" => alu_sel <= "011";   -- AND
      when "0101" => alu_sel <= "100";   -- OR
      when others => acc_we <= '0'; z_we <= '0';  -- NOP
    end case;
  end process;
end rtl;
