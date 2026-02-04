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

function err_msg(stage_name : string; cycle : integer; expected : integer; got : integer) return string is
begin
    return stage_name & " mismatch at cycle " & integer'image(cycle) &
           ": expected " & integer'image(expected) &
           ", got " & integer'image(got);
end function;

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
    CONSTANT pipe_depth : natural := 6;

    TYPE test_vec_t IS RECORD
        a, b, c, d, e : INTEGER;
    END RECORD;

    TYPE test_array_t IS ARRAY (natural range <>) OF test_vec_t;
    CONSTANT tests : test_array_t(0 to 5) := (
        0 => (a => 5,  b => 7,  c => 2,  d => 3,  e => 1),
        1 => (a => 10, b => -2, c => 1,  d => 5,  e => -3),
        2 => (a => -4, b => 9,  c => -3, d => 2,  e => 6),
        3 => (a => 8,  b => 0,  c => 4,  d => -1, e => 2),
        4 => (a => -6, b => -6, c => 3,  d => 3,  e => -2),
        5 => (a => 12, b => 5,  c => -2, d => -4, e => 7)
    );

    CONSTANT zero_vec : test_vec_t := (a => 0, b => 0, c => 0, d => 0, e => 0);

    TYPE stim_t IS RECORD
        valid : BOOLEAN;
        test_index : natural;
    END RECORD;

    TYPE stim_array_t IS ARRAY (natural range <>) OF stim_t;
    CONSTANT stim_seq : stim_array_t := (
        (valid => TRUE,  test_index => 0),
        (valid => TRUE,  test_index => 1),
        (valid => TRUE,  test_index => 2),
        (valid => TRUE,  test_index => 3),
        (valid => TRUE,  test_index => 4),
        (valid => TRUE,  test_index => 5),
        (valid => TRUE,  test_index => 2),
        (valid => TRUE,  test_index => 4),
        (valid => TRUE,  test_index => 1),
        (valid => FALSE, test_index => 0),
        (valid => FALSE, test_index => 0),
        (valid => FALSE, test_index => 0),
        (valid => FALSE, test_index => 0),
        (valid => FALSE, test_index => 0),
        (valid => FALSE, test_index => 0)
    );

    TYPE bool_array_t IS ARRAY (natural range <>) OF BOOLEAN;

    VARIABLE curr_vec : test_vec_t := zero_vec;
    VARIABLE curr_valid : BOOLEAN := FALSE;
    VARIABLE cycle : INTEGER := 0;
    VARIABLE seen_filling, seen_full, seen_draining : BOOLEAN := FALSE;

    VARIABLE valid_pipe : bool_array_t(0 to pipe_depth - 1) := (others => FALSE);
    VARIABLE next_valid_pipe : bool_array_t(0 to pipe_depth - 1);

    VARIABLE v_op1, v_op2, v_op3, v_op4, v_op5, v_final : INTEGER := 0;
    VARIABLE v_diff_ae, v_diff_ae_1, v_diff_ae_2 : INTEGER := 0;
    VARIABLE v_cd, v_cd_1 : INTEGER := 0;
    VARIABLE v_op2_1, v_op2_2, v_op2_3, v_op3_1 : INTEGER := 0;

    VARIABLE n_op1, n_op2, n_op3, n_op4, n_op5, n_final : INTEGER := 0;
    VARIABLE n_diff_ae, n_diff_ae_1, n_diff_ae_2 : INTEGER := 0;
    VARIABLE n_cd, n_cd_1 : INTEGER := 0;
    VARIABLE n_op2_1, n_op2_2, n_op2_3, n_op3_1 : INTEGER := 0;

    VARIABLE stage_count : INTEGER := 0;
BEGIN
    FOR step IN stim_seq'range LOOP
        curr_valid := stim_seq(step).valid;
        IF curr_valid THEN
            curr_vec := tests(stim_seq(step).test_index);
        ELSE
            curr_vec := zero_vec;
        END IF;

        s_a <= curr_vec.a;
        s_b <= curr_vec.b;
        s_c <= curr_vec.c;
        s_d <= curr_vec.d;
        s_e <= curr_vec.e;

        -- Compute next-state expectations mirroring the DUT pipeline
        n_op1 := curr_vec.a + curr_vec.b;
        n_diff_ae := curr_vec.a - curr_vec.e;
        n_cd := curr_vec.c * curr_vec.d;

        n_op2 := v_op1 * 42;
        n_diff_ae_1 := v_diff_ae;
        n_cd_1 := v_cd;

        n_op3 := v_cd_1;
        n_diff_ae_2 := v_diff_ae_1;
        n_op2_1 := v_op2;

        n_op4 := v_diff_ae_2;
        n_op2_2 := v_op2_1;
        n_op3_1 := v_op3;

        n_op5 := v_op3_1 * v_op4;
        n_op2_3 := v_op2_2;

        n_final := v_op5 - v_op2_3;

        next_valid_pipe(0) := curr_valid;
        FOR stage IN 1 TO pipe_depth - 1 LOOP
            next_valid_pipe(stage) := valid_pipe(stage - 1);
        END LOOP;

        WAIT FOR clk_period;
        cycle := cycle + 1;

        v_op1 := n_op1;
        v_diff_ae := n_diff_ae;
        v_cd := n_cd;
        v_op2 := n_op2;
        v_diff_ae_1 := n_diff_ae_1;
        v_cd_1 := n_cd_1;
        v_op3 := n_op3;
        v_diff_ae_2 := n_diff_ae_2;
        v_op2_1 := n_op2_1;
        v_op4 := n_op4;
        v_op2_2 := n_op2_2;
        v_op3_1 := n_op3_1;
        v_op5 := n_op5;
        v_op2_3 := n_op2_3;
        v_final := n_final;

        valid_pipe := next_valid_pipe;

        stage_count := 0;
        FOR idx IN valid_pipe'range LOOP
            IF valid_pipe(idx) THEN
                stage_count := stage_count + 1;
            END IF;
        END LOOP;

        IF (NOT seen_filling) AND curr_valid AND (stage_count < pipe_depth) THEN
            seen_filling := TRUE;
        END IF;

        IF (NOT seen_full) AND (stage_count = pipe_depth) THEN
            seen_full := TRUE;
        END IF;

        IF (NOT seen_draining) AND (NOT curr_valid) AND (stage_count > 0) THEN
            seen_draining := TRUE;
        END IF;

        ASSERT s_op1 = v_op1
            REPORT err_msg("op1", cycle, v_op1, s_op1)
            SEVERITY failure;
        ASSERT s_op2 = v_op2
            REPORT err_msg("op2", cycle, v_op2, s_op2)
            SEVERITY failure;
        ASSERT s_op3 = v_op3
            REPORT err_msg("op3", cycle, v_op3, s_op3)
            SEVERITY failure;
        ASSERT s_op4 = v_op4
            REPORT err_msg("op4", cycle, v_op4, s_op4)
            SEVERITY failure;
        ASSERT s_op5 = v_op5
            REPORT err_msg("op5", cycle, v_op5, s_op5)
            SEVERITY failure;
        ASSERT s_final_output = v_final
            REPORT err_msg("final_output", cycle, v_final, s_final_output)
            SEVERITY failure;
    END LOOP;

    ASSERT seen_filling
        REPORT "Pipeline never observed in filling state" SEVERITY failure;
    ASSERT seen_full
        REPORT "Pipeline never observed while full" SEVERITY failure;
    ASSERT seen_draining
        REPORT "Pipeline never observed while draining" SEVERITY failure;

    REPORT "All tests passed with fill/full/drain coverage!" SEVERITY note;
    WAIT;
END PROCESS stim_process;
END;
