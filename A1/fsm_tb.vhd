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

	TYPE test_array_1 IS ARRAY (0 TO 5) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_1 : test_array_1 := (
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000001", -- 'A'
		"01000010", -- 'B'
		NEW_LINE_CHARACTER, -- '\n'
		"01000011" -- 'C'
	);
	TYPE answer_array_1 IS ARRAY (0 TO 5) OF STD_LOGIC;
	CONSTANT answer_1 : answer_array_1 := (
		'0', -- '/'
		'0', -- '/'
		'1', -- 'A'
		'1', -- 'B'
		'1', -- '\n'
		'0'  -- 'C'
	);

	TYPE test_array_2 IS ARRAY (0 TO 7) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_2 : test_array_2 := (
		"01000001", -- 'A'
		SLASH_CHARACTER, -- '/'
		"01000010", -- 'B'
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		"01000011", -- 'C'
		NEW_LINE_CHARACTER, -- '\n'
		SLASH_CHARACTER -- '/'
	);
	TYPE answer_array_2 IS ARRAY (0 TO 7) OF STD_LOGIC;
	CONSTANT answer_2 : answer_array_2 := (
		'0', -- 'A'
		'0', -- '/'
		'0', -- 'B'
		'0', -- '/'
		'0', -- '/'
		'1', -- 'C'
		'1', -- '\n'
		'0'  -- '/'
	);

	TYPE test_array_3 IS ARRAY (0 TO 3) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_3 : test_array_3 := (
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		NEW_LINE_CHARACTER, -- '\n'
		"01000001" -- 'A'
	);
	TYPE answer_array_3 IS ARRAY (0 TO 3) OF STD_LOGIC;
	CONSTANT answer_3 : answer_array_3 := (
		'0', -- '/'
		'0', -- '/'
		'1', -- '\n'
		'0'  -- 'A'
	);

	TYPE test_array_4 IS ARRAY (0 TO 13) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_4 : test_array_4 := (
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000010", -- 'B'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		STAR_CHARACTER, -- '*'
		STAR_CHARACTER, -- '*'
		"01000100", -- 'D'
		NEW_LINE_CHARACTER, -- '\n'
		STAR_CHARACTER, -- '*',
		SLASH_CHARACTER, -- '/'
		"01000101" -- 'E'
	);
	TYPE answer_array_4 IS ARRAY (0 TO 13) OF STD_LOGIC;
	CONSTANT answer_4 : answer_array_4 := (
		'0', -- '/'
		'0', -- '*'
		'1', -- 'B'
		'1', -- '*'
		'1', -- '/'
		'0', -- '/'
		'0', -- '*'
		'1', -- '*'
		'1', -- '*'
		'1', -- 'D'
		'1', -- '\n'
		'1', -- '*'
		'1', -- '/'
		'0'  -- 'E'
	);

	TYPE test_array_5 IS ARRAY (0 TO 3) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_5 : test_array_5 := (
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		NEW_LINE_CHARACTER, -- '\n'
		STAR_CHARACTER -- '*'
	);
	TYPE answer_array_5 IS ARRAY (0 TO 3) OF STD_LOGIC;
	CONSTANT answer_5 : answer_array_5 := (
		'0', -- '/'
		'0', -- '/'
		'1', -- '\n'
		'0' -- '*'
	);

	TYPE test_array_6 IS ARRAY (0 TO 18) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_6 : test_array_6 := (
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
	TYPE answer_array_6 IS ARRAY (0 TO 18) OF STD_LOGIC;
	CONSTANT answer_6 : answer_array_6 := (
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

	TYPE test_array_7 IS ARRAY (0 TO 7) OF std_logic_vector(7 downto 0);
	CONSTANT test_vectors_7 : test_array_7 := (
		SLASH_CHARACTER, -- '/'
		SLASH_CHARACTER, -- '/'
		STAR_CHARACTER, -- '*'
		"01000001", -- 'A'
		STAR_CHARACTER, -- '*'
		SLASH_CHARACTER, -- '/'
		NEW_LINE_CHARACTER, -- '\n'
		"01000010" -- 'B'
	);
	TYPE answer_array_7 IS ARRAY (0 TO 7) OF STD_LOGIC;
	CONSTANT answer_7 : answer_array_7 := (
		'0', -- '/'
		'0', -- '/'
		'1', -- '*'
		'1', -- 'A'
		'1', -- '*'
		'1', -- '/'
		'1', -- '\n'
		'0'  -- 'B'
	);
BEGIN
-- Reset the FSM
	REPORT "Resetting the FSM";
	s_reset <= '1';
	WAIT FOR clk_period*1;
	s_reset <= '0';
	WAIT FOR clk_period*1;
	ASSERT (s_output = '0')
		REPORT "Reset failed"
		SEVERITY ERROR;

	-- REPORT "Start Test Case 1: Single Line Comments";
	-- FOR i IN test_vectors_1'RANGE LOOP
	-- 	s_input <= test_vectors_1(i);
	-- 	WAIT FOR 1 * clk_period;
	-- 	ASSERT (s_output = answer_1(i))
	-- 		REPORT "Test case 1 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_1(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
	-- 		SEVERITY ERROR;
	-- END LOOP;

	-- s_reset <= '1';
	-- WAIT FOR clk_period*1;
	-- s_reset <= '0';
	-- WAIT FOR clk_period*1;
	-- ASSERT (s_output = '0')
	-- 	REPORT "Reset failed after test case 1"
	-- 	SEVERITY ERROR;

	-- REPORT "Start Test Case 2: Single Line Comments with interleaved code";
	-- FOR i IN test_vectors_2'RANGE LOOP
	-- 	s_input <= test_vectors_2(i);
	-- 	WAIT FOR 1 * clk_period;
	-- 	ASSERT (s_output = answer_2(i))
	-- 		REPORT "Test case 2 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_2(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
	-- 		SEVERITY ERROR;
	-- END LOOP;

	-- s_reset <= '1';
	-- WAIT FOR clk_period*1;
	-- s_reset <= '0';
	-- WAIT FOR clk_period*1;

	REPORT "Start Test Case 3: Single Line Comments";
	FOR i IN test_vectors_3'RANGE LOOP
		s_input <= test_vectors_3(i);
		WAIT FOR 1 * clk_period;
		ASSERT (s_output = answer_3(i))
			REPORT "Test case 3 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_3(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
			SEVERITY ERROR;
	END LOOP;

	-- s_reset <= '1';
	-- WAIT FOR clk_period*1;
	-- s_reset <= '0';
	-- WAIT FOR clk_period*1;

	-- REPORT "Start Test Case 4: Multi-Line Comments with interleaved code";
	-- FOR i IN test_vectors_4'RANGE LOOP
	-- 	s_input <= test_vectors_4(i);
	-- 	WAIT FOR 1 * clk_period;
	-- 	ASSERT (s_output = answer_4(i))
	-- 		REPORT "Test case 4 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_4(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
	-- 		SEVERITY ERROR;
	-- END LOOP;

	-- s_reset <= '1';
	-- WAIT FOR clk_period*1;
	-- s_reset <= '0';
	-- WAIT FOR clk_period*1;

	-- REPORT "Start Test Case 5: Complex Multi-Line Comments with interleaved code";
	-- FOR i IN test_vectors_5'RANGE LOOP
	-- 	s_input <= test_vectors_5(i);
	-- 	WAIT FOR 1 * clk_period;
	-- 	ASSERT (s_output = answer_5(i))
	-- 		REPORT "Test case 5 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_5(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
	-- 		SEVERITY ERROR;
	-- END LOOP;

	-- s_reset <= '1';
	-- WAIT FOR clk_period*1;
	-- s_reset <= '0';
	-- WAIT FOR clk_period*1;

	-- REPORT "Start Test Case 6: Mixed Comments";
	-- FOR i IN test_vectors_6'RANGE LOOP
	-- 	s_input <= test_vectors_6(i);
	-- 	WAIT FOR 1 * clk_period;
	-- 	ASSERT (s_output = answer_6(i))
	-- 		REPORT "Test case 6 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_6(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
	-- 		SEVERITY ERROR;
	-- END LOOP;

	-- s_reset <= '1';
	-- WAIT FOR clk_period*1;
	-- s_reset <= '0';
	-- WAIT FOR clk_period*1;

	-- REPORT "Start Test Case 7: Multi-Line Comment followed by Single-Line Comment";
	-- FOR i IN test_vectors_7'RANGE LOOP
	-- 	s_input <= test_vectors_7(i);
	-- 	WAIT FOR 1 * clk_period;
	-- 	ASSERT (s_output = answer_7(i))
	-- 		REPORT "Test case 7 failed at index " & INTEGER'IMAGE(i) & " Expected: " & STD_LOGIC'IMAGE(answer_7(i)) & " Got: " & STD_LOGIC'IMAGE(s_output)
	-- 		SEVERITY ERROR;
	-- END LOOP;

	WAIT;
END PROCESS stim_process;
END;
