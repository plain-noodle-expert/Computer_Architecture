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
	VARIABLE potential_comment : BOOLEAN := FALSE;
	VARIABLE single_comment : BOOLEAN := FALSE;
	VARIABLE multi_comment : BOOLEAN := FALSE;
	VARIABLE potential_end_multi_comment : BOOLEAN := FALSE;
BEGIN
-- Reset the FSM
	REPORT "Resetting the FSM";
	s_reset <= '1';
	WAIT FOR clk_period*1;
	s_reset <= '0';
	WAIT FOR clk_period*1;
	REPORT "Example case, reading a meaningless character";
	FOR i IN 0 TO 255 LOOP
	-- 47: slash, 42: star, 10: new line
		s_input <= std_logic_vector(to_unsigned(i, 8));
		WAIT FOR 1 * clk_period;
		IF single_comment OR multi_comment THEN
			ASSERT (s_output = '1') REPORT "When inside a comment, the output should be '1'" SEVERITY ERROR;
		ELSE
			ASSERT (s_output = '0') REPORT "When not inside a comment, the output should be '0'" SEVERITY ERROR;
		END IF;
		IF single_comment THEN
			IF i = 10 THEN -- '\n' ends single-line comment
				potential_comment := FALSE;
				single_comment := FALSE;
			END IF;
		END IF;
		IF multi_comment THEN
			IF potential_end_multi_comment THEN
				IF i = 47 THEN
					potential_comment := FALSE;
					multi_comment := FALSE;
					potential_end_multi_comment := FALSE;
				ELSIF i = 42 THEN
					potential_end_multi_comment := FALSE;
				END IF;
			ELSIF i = 42 THEN
				potential_end_multi_comment := TRUE;
			END IF;
		END IF;
		IF potential_comment THEN
			IF (i = 47)  THEN
				single_comment := TRUE;
			ELSIF (i = 42) THEN
				multi_comment := TRUE;
			ELSE
				potential_comment := FALSE;
			END IF;
		ELSIF (i = 47) THEN
			potential_comment := TRUE;
		END IF;
	END LOOP;
		REPORT "_______________________";

	WAIT;
END PROCESS stim_process;
END;
