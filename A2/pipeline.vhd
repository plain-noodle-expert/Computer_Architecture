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
signal sum_stage1       : integer := 0;
signal a_stage1, a_stage2, a_stage3 : integer := 0;
signal e_stage1, e_stage2, e_stage3 : integer := 0;
signal c_stage1, c_stage2           : integer := 0;
signal d_stage1, d_stage2           : integer := 0;

signal mult42_stage2, mult42_stage3, mult42_stage4, mult42_stage5 : integer := 0;
signal cd_stage3, cd_stage4     : integer := 0;
signal diff_stage4              : integer := 0;
signal product_stage5           : integer := 0;
signal final_stage6             : integer := 0;
begin

process (clk)
begin
    if rising_edge(clk) then
        -- Stage 1: capture inputs and compute (a + b)
        sum_stage1 <= a + b;
        a_stage1   <= a;
        e_stage1   <= e;
        c_stage1   <= c;
        d_stage1   <= d;

        -- Stage 2: multiply by 42 and pass operands downstream
        mult42_stage2 <= sum_stage1 * 42;
        a_stage2      <= a_stage1;
        e_stage2      <= e_stage1;
        c_stage2      <= c_stage1;
        d_stage2      <= d_stage1;

        -- Stage 3: compute (c * d) while aligning remaining data
        cd_stage3     <= c_stage2 * d_stage2;
        a_stage3      <= a_stage2;
        e_stage3      <= e_stage2;
        mult42_stage3 <= mult42_stage2;

        -- Stage 4: compute (a - e) and forward terms
        diff_stage4   <= a_stage3 - e_stage3;
        cd_stage4     <= cd_stage3;
        mult42_stage4 <= mult42_stage3;

        -- Stage 5: compute c*d*(a - e) while azligning left side
        product_stage5 <= cd_stage4 * diff_stage4;
        mult42_stage5  <= mult42_stage4;

        -- Stage 6: final subtraction
        final_stage6 <= mult42_stage5 - product_stage5;
    end if;
end process;

op1 <= sum_stage1;
op2 <= mult42_stage2;
op3 <= cd_stage3;
op4 <= diff_stage4;
op5 <= product_stage5;
final_output <= final_stage6;

end behavioral;
