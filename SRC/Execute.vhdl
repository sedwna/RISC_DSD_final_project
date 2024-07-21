library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Use the correct package for signed and unsigned types

entity EX_stage is
    Port (
        ReadData1, ReadData2 : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(2 downto 0);
        Result : out  STD_LOGIC_VECTOR(31 downto 0);
        Zero : out  STD_LOGIC
    );
end EX_stage;

architecture Behavioral of EX_stage is
    signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(ReadData1, ReadData2, ALUControl)
    begin
        case ALUControl is
            when "000" =>
                ALUResult <= std_logic_vector(signed(ReadData1) + signed(ReadData2));
            when "001" =>
                ALUResult <= std_logic_vector(signed(ReadData1) - signed(ReadData2));
            when "010" =>
                ALUResult <= ReadData1 and ReadData2;
            when "011" =>
                ALUResult <= ReadData1 or ReadData2;
            when "100" =>
                if signed(ReadData1) < signed(ReadData2) then
                    ALUResult <= (others => '0');
                    ALUResult(0) <= '1';
                else
                    ALUResult <= (others => '0');
                end if;
            when others =>
                ALUResult <= (others => '0');
        end case;

        if ALUResult = x"00000000" then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;

    Result <= ALUResult; -- Output the result
end Behavioral;
