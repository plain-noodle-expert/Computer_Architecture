library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline is
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
end pipeline;

architecture behavioral of pipeline is
-- stage 1: op1, a-e, cd
-- stage 2: op2, (a-e)1, cd_1
-- stage 3: op3, op2_1, (a-e)2
-- stage 4: op4, op3_1, op2_2
-- stage 5: op5, op2_3
-- stage 6: final_output
signal op2_1, op2_2, op2_3, op3_1              : integer := 0;
signal diff_ae, diff_ae_1, diff_ae_2           : integer := 0;
signal cd, cd_1                                : integer := 0;

begin

process (clk)
begin
    if rising_edge(clk) then
        -- Stage 1
        op1 <= a + b;
        diff_ae <= a - e;
        cd <= c*d;

        -- Stage 2
        op2 <= op1 * 42;
        diff_ae_1 <= diff_ae;
        cd_1 <= cd;

        -- Stage 3
        op3 <= cd_1;
        diff_ae_2 <= diff_ae_1;
        op2_1 <= op2;

        -- Stage 4
        op4 <= diff_ae_2;
        op2_2 <= op2_1;
        op3_1 <= op3;

        -- Stage 5
        op5 <= op3_1 * op4;
        op2_3 <= op2_2;

        -- Stage 6: final subtraction
        final_output <= op5 - op2_3;
    end if;
end process;

end behavioral;
