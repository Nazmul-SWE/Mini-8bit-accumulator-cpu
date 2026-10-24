-- Step 2: Program ROM, 16 x 12 bits, combinational read. Appendix B, Set 1.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom is
  port ( addr  : in  std_logic_vector(3 downto 0);
         instr : out std_logic_vector(11 downto 0) );
end rom;

architecture rtl of rom is
  type rom_t is array (0 to 15) of std_logic_vector(11 downto 0);
  constant PROG : rom_t := (
    0 => x"13C",   -- LDI 0x3C
    1 => x"20F",   -- ADD 0x0F
    2 => x"30B",   -- SUB 0x0B
    3 => x"4F0",   -- AND 0xF0
    4 => x"50A",   -- OR  0x0A
    5 => x"34A",   -- SUB 0x4A
    6 => x"301",   -- SUB 0x01
    others => x"000");  -- NOP
begin
  instr <= PROG(to_integer(unsigned(addr)));
end rtl;
