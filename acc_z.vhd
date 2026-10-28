-- Step 5: ACC (8-bit) and Z flag (1-bit). Sync active-high reset: ACC=0x00, Z=1.
-- (R register omitted: Set 1 has no STA/LDR.)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity acc_z is
  port ( clk, reset : in  std_logic;
         acc_we     : in  std_logic;
         z_we       : in  std_logic;
         d          : in  std_logic_vector(7 downto 0);  -- ALU result
         q          : out std_logic_vector(7 downto 0);
         z          : out std_logic );
end acc_z;

architecture rtl of acc_z is
  signal acc_r : std_logic_vector(7 downto 0) := (others => '0');
  signal z_r   : std_logic := '1';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        acc_r <= (others => '0');
        z_r   <= '1';
      else
        if acc_we = '1' then acc_r <= d; end if;
        if z_we = '1' then
          if d = x"00" then z_r <= '1'; else z_r <= '0'; end if;
        end if;
      end if;
    end if;
  end process;
  q <= acc_r;
  z <= z_r;
end rtl;
