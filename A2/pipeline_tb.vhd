LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY pipeline_tb IS
END pipeline_tb;

ARCHITECTURE behaviour OF pipeline_tb IS

COMPONENT pipeline IS
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk: STD_LOGIC := '0';
SIGNAL s_a, s_b, s_c, s_d, s_e : INTEGER := 0;
SIGNAL s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output : INTEGER := 0;

CONSTANT clk_period : time := 1 ns;

BEGIN
dut: pipeline
PORT MAP(clk, s_a, s_b, s_c, s_d, s_e, s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 

stim_process: PROCESS
    TYPE test_vec_t IS RECORD
        a, b, c, d, e : INTEGER;
    END RECORD;

    CONSTANT tests : ARRAY (natural range <>) OF test_vec_t := (
        (a => 5,  b => 7,  c => 2, d => 3, e => 1),
        (a => 10, b => -2, c => 1, d => 5, e => -3),
        (a => -4, b => 9,  c => -3, d => 2, e => 6)
    );

    VARIABLE exp_op1, exp_op2, exp_op3, exp_op4, exp_op5, exp_final : INTEGER;
BEGIN
    -- Feed all test inputs into the pipeline
    FOR i IN tests'range LOOP
        s_a <= tests(i).a;
        s_b <= tests(i).b;
        s_c <= tests(i).c;
        s_d <= tests(i).d;
        s_e <= tests(i).e;
        WAIT FOR clk_period;
    END LOOP;

    -- Wait for pipeline to fully flush (6 stages)
    WAIT FOR 6 * clk_period;

    -- Now check results for each test
    FOR i IN tests'range LOOP
        exp_op1 := tests(i).a + tests(i).b;
        exp_op2 := exp_op1 * 42;
        exp_op3 := tests(i).c * tests(i).d;
        exp_op4 := tests(i).a - tests(i).e;
        exp_op5 := exp_op3 * exp_op4;
        exp_final := exp_op2 - exp_op5;

        -- Re-apply inputs
        s_a <= tests(i).a;
        s_b <= tests(i).b;
        s_c <= tests(i).c;
        s_d <= tests(i).d;
        s_e <= tests(i).e;

        -- Check op1 after 1 clock cycle
        WAIT FOR clk_period;
        ASSERT s_op1 = exp_op1
            REPORT "op1 mismatch at test " & integer'image(i) &
                   ": expected " & integer'image(exp_op1) &
                   ", got " & integer'image(s_op1)
            SEVERITY failure;

        -- Check op2 after 2 clock cycles
        WAIT FOR clk_period;
        ASSERT s_op2 = exp_op2
            REPORT "op2 mismatch at test " & integer'image(i) &
                   ": expected " & integer'image(exp_op2) &
                   ", got " & integer'image(s_op2)
            SEVERITY failure;

        -- Check op3 after 3 clock cycles
        WAIT FOR clk_period;
        ASSERT s_op3 = exp_op3
            REPORT "op3 mismatch at test " & integer'image(i) &
                   ": expected " & integer'image(exp_op3) &
                   ", got " & integer'image(s_op3)
            SEVERITY failure;

        -- Check op4 after 4 clock cycles
        WAIT FOR clk_period;
        ASSERT s_op4 = exp_op4
            REPORT "op4 mismatch at test " & integer'image(i) &
                   ": expected " & integer'image(exp_op4) &
                   ", got " & integer'image(s_op4)
            SEVERITY failure;

        -- Check op5 after 5 clock cycles
        WAIT FOR clk_period;
        ASSERT s_op5 = exp_op5
            REPORT "op5 mismatch at test " & integer'image(i) &
                   ": expected " & integer'image(exp_op5) &
                   ", got " & integer'image(s_op5)
            SEVERITY failure;

        -- Check final_output after 6 clock cycles
        WAIT FOR clk_period;
        ASSERT s_final_output = exp_final
            REPORT "final_output mismatch at test " & integer'image(i) &
                   ": expected " & integer'image(exp_final) &
                   ", got " & integer'image(s_final_output)
            SEVERITY failure;
    END LOOP;
    
    REPORT "All tests passed!" SEVERITY note;
    WAIT;
END PROCESS stim_process;
END;
