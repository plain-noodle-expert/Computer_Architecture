library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Do not modify the port map of this structure
entity comments_fsm is
port (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
end comments_fsm;

architecture behavioral of comments_fsm is

-- The ASCII value for the '/', '*' and end-of-line characters
constant SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
constant STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
constant NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";
-- IDLE (A)
-- READY (B)
-- SINGLE_READY (C)
-- SINGLE_C (E, inside single-line comment)
-- MULTI_READY (D)
-- MULTI_C (G, inside multi-line comment)
-- MULTI_END_READY (H)
-- END_C (F, end of comment but still output 1)
TYPE state_type IS (IDLE, READY, SINGLE_READY, SINGLE_C, MULTI_READY, MULTI_C, MULTI_END_READY, END_C);
SIGNAL state : state_type;

begin

-- Insert your processes here
state_update: process (clk, reset)
begin
    if reset = '1' then
        state <= IDLE;
    elsif rising_edge(clk) then
        case state is
            when IDLE =>
                if input = SLASH_CHARACTER then
                    state <= READY; -- A -> B
                else
                    state <= IDLE;
                end if;
            when READY => -- One '/' detected
                if input = SLASH_CHARACTER then
                    state <= SINGLE_READY; -- Single-line comment start
                elsif input = STAR_CHARACTER then
                    state <= MULTI_READY ; -- Multi-line comment start
                else
                    state <= IDLE; -- Not a comment
                end if;
            when SINGLE_READY => -- C, double '/' detected
                if input = NEW_LINE_CHARACTER then
                    state <= END_C; -- F
                else
                    state <= SINGLE_C; -- E, Still inside single-line comment
                end if;
            when MULTI_READY => -- D, '/*' detected
                if input = STAR_CHARACTER then
                    state <= MULTI_END_READY; -- H, possible end of multi-line comment
                else
                    state <= MULTI_C; -- G, Still inside multi-line comment
                end if;
            when MULTI_C => -- G, inside multi-line comment
                if input = STAR_CHARACTER then
                    state <= MULTI_END_READY; -- H, possible end of multi-line comment
                else
                    state <= MULTI_C; -- G, Still inside multi-line comment
                end if;
            when MULTI_END_READY => -- H, possible end of multi-line comment
                if input = SLASH_CHARACTER then
                    state <= END_C; -- F, End of comment
                elsif input = STAR_CHARACTER then
                    state <= MULTI_END_READY; -- Still possible end
                else
                    state <= MULTI_C; -- G, Back to inside multi-line comment
                end if;
            when END_C => -- End of single-line comment
                if input = SLASH_CHARACTER then
                    state <= READY; -- Check for new comment start
                else
                    state <= IDLE; -- Back to idle
                end if;
        end case;
    end if;
end process;

output_logic: process (state, input)
begin
    output <= '0'; -- Default output
    case state is
        when SINGLE_C =>
            output <= '1'; -- Inside single-line comment
        when MULTI_C =>
            output <= '1'; -- Inside multi-line comment
        when MULTI_END_READY =>
            output <= '1'; -- Still inside multi-line comment
        when END_C =>
            output <= '1'; -- End of a comment but still output 1
        when others =>
            output <= '0'; -- Not in a comment
    end case;

end process;
end behavioral;