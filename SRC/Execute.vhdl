library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_stage is
    port (

        ALUControl : in std_logic_vector(3 downto 0);
        A          : in std_logic_vector(31 downto 0);
        B          : in std_logic_vector(31 downto 0);
        Result     : out std_logic_vector(31 downto 0)
    );
end EX_stage;

architecture Behavioral of EX_stage is
begin
    process (ALUControl, A, B)
    begin
        case ALUControl is
            when "0000" => 
                Result <= std_logic_vector(signed(A) + signed(B));
            when "0001" => 
                Result <= std_logic_vector(signed(A) - signed(B));
            when "0010" => 
                Result <= A and B;
            when "0011" => 
                Result <= A or B;
            when "0100" => 
                Result <= A xor B;
            when "1000" => -- Shift Left Logical 
                Result <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when "1001" => -- Shift Right Logical
                Result <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when others =>
                Result <= (others => '0');
        end case;
    end process;
end Behavioral;

-- 40012358013
-- 40012358014
