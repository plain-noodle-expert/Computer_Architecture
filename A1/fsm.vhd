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
TYPE state_type IS (IDLE, READY, SINGLE_C, SINGLE_END, MULTI_C, MULTI_C_END);
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
                    state <= READY;
                else
                    state <= IDLE;
                end if;
            when READY => -- One '/' detected
                if input = SLASH_CHARACTER then
                    state <= SINGLE_C; -- Single-line comment start
                elsif input = STAR_CHARACTER then
                    state <= MULTI_C ; -- Multi-line comment start
                else
                    state <= IDLE; -- Not a comment
                end if;
            when SINGLE_C => -- Inside single-line comment
                if input = NEW_LINE_CHARACTER then
                    state <= SINGLE_END;
                else
                    state <= SINGLE_C; -- Still inside single-line comment
                end if;
            when SINGLE_END => -- End of single-line comment
                state <= IDLE;
            when MULTI_C => -- Inside multi-line comment
                if input = STAR_CHARACTER then
                    state <= MULTI_C_END;
                else
                    state <= MULTI_C; -- Still inside multi-line comment
                end if;
            when MULTI_C_END => -- End '*' detected in multi-line comment
                if input = SLASH_CHARACTER then
                    state <= IDLE; -- End of multi-line comment
                elsif input = STAR_CHARACTER then
                    state <= MULTI_C_END;
                else
                    state <= MULTI_C; -- Still inside multi-line comment
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
        when MULTI_C_END =>
            output <= '1'; -- Still inside multi-line comment
        when others =>
            output <= '0'; -- Not in a comment
    end case;

end process;
end behavioral;