-- Step 4: ALU. 8-bit combinational, works on ACC and the 8-bit immediate.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
  port ( a       : in  std_logic_vector(7 downto 0);  -- ACC
         b       : in  std_logic_vector(7 downto 0);  -- immediate
         alu_sel : in  std_logic_vector(2 downto 0);
         y       : out std_logic_vector(7 downto 0) );
end alu;

architecture rtl of alu is
begin
  process(a, b, alu_sel)
  begin
    case alu_sel is
      when "000"  => y <= b;                                              -- LDI
      when "001"  => y <= std_logic_vector(unsigned(a) + unsigned(b));    -- ADD
      when "010"  => y <= std_logic_vector(unsigned(a) - unsigned(b));    -- SUB (mod 256)
      when "011"  => y <= a and b;                                        -- AND
      when "100"  => y <= a or b;                                         -- OR
      when others => y <= a;
    end case;
  end process;
end rtl;
