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
signal stage_op1, stage_op2, stage_op3         : integer := 0;
signal stage_op4, stage_op5, stage_final       : integer := 0;
signal op2_1, op2_2, op2_3, op3_1              : integer := 0;
signal diff_ae, diff_ae_1, diff_ae_2           : integer := 0;
signal cd, cd_1                                : integer := 0;

begin

process (clk)
begin
    if rising_edge(clk) then
        -- Stage 1
        stage_op1 <= a + b;
        diff_ae <= a - e;
        cd <= c*d;

        -- Stage 2
        stage_op2 <= stage_op1 * 42;
        diff_ae_1 <= diff_ae;
        cd_1 <= cd;

        -- Stage 3
        stage_op3 <= cd_1;
        diff_ae_2 <= diff_ae_1;
        op2_1 <= stage_op2;

        -- Stage 4
        stage_op4 <= diff_ae_2;
        op2_2 <= op2_1;
        op3_1 <= stage_op3;

        -- Stage 5
        stage_op5 <= op3_1 * stage_op4;
        op2_3 <= op2_2;

        -- Stage 6: final subtraction
        stage_final <= stage_op5 - op2_3;
    end if;
end process;

op1 <= stage_op1;
op2 <= stage_op2;
op3 <= stage_op3;
op4 <= stage_op4;
op5 <= stage_op5;
final_output <= stage_final;

end behavioral;
