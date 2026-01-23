LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE behaviour OF fsm_tb IS

COMPONENT comments_fsm IS
PORT (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_output: STD_LOGIC := '0';
SIGNAL s_input: std_logic_vector(7 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;
CONSTANT SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
CONSTANT STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
CONSTANT NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";


BEGIN
dut: comments_fsm
PORT MAP(clk, s_reset, s_input, s_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;

--TODO: Thoroughly test your FSM
stim_process: PROCESS
	VARIABLE single_comment : BOOLEAN := FALSE;
	VARIABLE multi_comment : BOOLEAN := FALSE;
	VARIABLE potential_comment : BOOLEAN := FALSE;
	VARIABLE potential_end_multi_comment : BOOLEAN := FALSE;
	TYPE singel_comment_test_array_1 IS ARRAY (0 TO 5) OF std_logic_vector(7 downto 0);
	CONSTANT s_test_vectors_1 : singel_comment_test_array_1 := (
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000001", -- 'A'
		"01000010", -- 'B'
		NEW_LINE_CHARACTER, -- '\n'
		"01000011" -- 'C'
	);

	TYPE single_comment_test_array_2 IS ARRAY (0 TO 7) OF std_logic_vector(7 downto 0);
	CONSTANT s_test_vectors_2 : single_comment_test_array_2 := (
		"01000001", -- 'A'
		SLASH_CHARACTER, -- '/'
		"01000010", -- 'B'
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000011", -- 'C'
		NEW_LINE_CHARACTER, -- '\n'
		"01000100" -- 'D'
	);

	TYPE single_comment_test_array_3 IS ARRAY (0 TO 7) OF std_logic_vector(7 downto 0);
	CONSTANT s_test_vectors_3 : single_comment_test_array_3 := (
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000001", -- 'A'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		NEW_LINE_CHARACTER, -- '\n'
		"01000010" -- 'B'
	);

	TYPE multi_comment_test_array_1 IS ARRAY (0 TO 9) OF std_logic_vector(7 downto 0);
	CONSTANT m_test_vectors_1 : multi_comment_test_array_1 := (
		"01000001", -- 'A'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000010", -- 'B'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		"01000011", -- 'C'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000100" -- 'D'
	);

	TYPE multi_comment_test_array_2 IS ARRAY (0 TO 16) OF std_logic_vector(7 downto 0);
	CONSTANT m_test_vectors_2 : multi_comment_test_array_2 := (
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		NEW_LINE_CHARACTER, -- '\n'
		"01000001", -- 'A'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000010", -- 'B'
		STAR_CHARACTER, -- '*'
		"01000011", -- 'C'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000100", -- 'D'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		"01000101" -- 'E'
	);

	TYPE mixed_comment_test_array IS ARRAY (0 TO 18) OF std_logic_vector(7 downto 0);
	CONSTANT mix_test_vectors : mixed_comment_test_array := (
		"01000001", -- 'A'
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000010", -- 'B'
		NEW_LINE_CHARACTER, -- '\n'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000011", -- 'C'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000100", -- 'D'
		NEW_LINE_CHARACTER, -- '\n'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000101", -- 'E'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		"01000110" -- 'F'
	);

	TYPE singel_answer_1 IS ARRAY (0 TO 5) OF STD_LOGIC;
	CONSTANT s_answer_1 : singel_answer_1 := (
		'0', -- '/'
		'0', -- '/'
		'1', -- 'A'
		'1', -- 'B'
		'1', -- '\n'
		'0'  -- 'C'
	);

	TYPE singel_answer_2 IS ARRAY (0 TO 7) OF STD_LOGIC;
	CONSTANT s_answer_2 : singel_answer_2 := (
		'0', -- 'A'
		'0', -- '/'
		'0', -- 'B'
		'0', -- '/'
		'0', -- '/'
		'1', -- 'C'
		'1', -- '\n'
		'0'  -- 'D'
	);

	TYPE singel_answer_3 IS ARRAY (0 TO 7) OF STD_LOGIC;
	CONSTANT s_answer_3 : singel_answer_3 := (
		'0', -- '/'
		'0', -- '/'
		'1', -- '*'
		'1', -- 'A'
		'1', -- '*'
		'1', -- '/'
		'1', -- '\n'
		'0'  -- 'B'
	);

	TYPE multi_answer_1 IS ARRAY (0 TO 9) OF STD_LOGIC;
	CONSTANT m_answer_1 : multi_answer_1 := (
		'0', -- 'A'
		'0', -- '/'
		'0', -- '*'
		'1', -- 'B'
		'1', -- '*'
		'1', -- '/'
		'0', -- 'C'
		'0', -- '/'
		'0', -- '*'
		'1'  -- 'D'
	);

	TYPE multi_answer_2 IS ARRAY (0 TO 16) OF STD_LOGIC;
	CONSTANT m_answer_2 : multi_answer_2 := (
		'0', -- '/'
		'0', -- '*'
		'1', -- '\n'
		'1', -- 'A'
		'1', -- '*'
		'1', -- '/'
		'0', -- '/'
		'0', -- 'B'
		'0', -- '*'
		'0', -- 'C'
		'0', -- '*'
		'0', -- '/'
		'0', -- '*'
		'1', -- 'D'
		'1', -- '*'
		'1', -- '/'
		'0'  -- 'E'
	);

	TYPE mixed_answer IS ARRAY (0 TO 18) OF STD_LOGIC;
	CONSTANT mix_answer : mixed_answer := (
		'0', -- 'A'
		'0', -- '/'
		'0', -- '/'
		'1', -- 'B'
		'1', -- '\n'
		'0', -- '/'
		'0', -- '*'
		'1', -- 'C'
		'1', -- '*'
		'1', -- '/'
		'0', -- '/'
		'0', -- 'D'
		'0', -- '\n'
		'0', -- '/'
		'0', -- '*'
		'1', -- 'E'
		'1', -- '*'
		'1', -- '/'
		'0'  -- 'F'
	);
BEGIN
-- Reset the FSM
	REPORT "Resetting the FSM";
	s_reset <= '1';
	WAIT FOR clk_period*1;
	s_reset <= '0';
	WAIT FOR clk_period*1;

	REPORT "Start Test Case 1: Single Line Comments";
	FOR i IN s_test_vectors_1'RANGE LOOP
		s_input <= s_test_vectors_1(i);
		WAIT FOR 1 * clk_period;
		IF s_output /= s_answer_1(i) THEN
			REPORT "Test case 1 failed at index " & INTEGER'IMAGE(i)
			SEVERITY ERROR;
		END IF;
	END LOOP;

	REPORT "Start Test Case 2: Single Line Comments with interleaved code";
	FOR i IN s_test_vectors_2'RANGE LOOP
		s_input <= s_test_vectors_2(i);
		WAIT FOR 1 * clk_period;
		IF s_output /= s_answer_2(i) THEN
			REPORT "Test case 2 failed at index " & INTEGER'IMAGE(i)
			SEVERITY ERROR;
		END IF;
	END LOOP;

	REPORT "Start Test Case 3: Single Line Comments";
	FOR i IN s_test_vectors_3'RANGE LOOP
		s_input <= s_test_vectors_3(i);
		WAIT FOR 1 * clk_period;
		IF s_output /= s_answer_3(i) THEN
			REPORT "Test case 3 failed at index " & INTEGER'IMAGE(i)
			SEVERITY ERROR;
		END IF;
	END LOOP;

	REPORT "Start Test Case 4: Multi-Line Comments with interleaved code";
	FOR i IN m_test_vectors_1'RANGE LOOP
		s_input <= m_test_vectors_1(i);
		WAIT FOR 1 * clk_period;
		IF s_output /= m_answer_1(i) THEN
			REPORT "Test case 4 failed at index " & INTEGER'IMAGE(i)
			SEVERITY ERROR;
		END IF;
	END LOOP;

	REPORT "Start Test Case 5: Complex Multi-Line Comments with interleaved code";
	FOR i IN m_test_vectors_2'RANGE LOOP
		s_input <= m_test_vectors_2(i);
		WAIT FOR 1 * clk_period;
		IF s_output /= m_answer_2(i) THEN
			REPORT "Test case 5 failed at index " & INTEGER'IMAGE(i)
			SEVERITY ERROR;
		END IF;
	END LOOP;

	REPORT "Start Test Case 6: Mixed Comments";
	FOR i IN mix_test_vectors'RANGE LOOP
		s_input <= mix_test_vectors(i);
		WAIT FOR 1 * clk_period;
		IF s_output /= mix_answer(i) THEN
			REPORT "Test case 6 failed at index " & INTEGER'IMAGE(i)
			SEVERITY ERROR;
		END IF;
	END LOOP;

	WAIT;
END PROCESS stim_process;
END;
