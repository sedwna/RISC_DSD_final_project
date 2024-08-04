library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity WB_stage is
    port (
        clk          : in std_logic;
        reset        : in std_logic;
        MemToReg_in  : in std_logic;  -- Control signal: 1 for load instructions, 0 for ALU result
        ALUResult_in : in std_logic_vector(31 downto 0); -- ALU result from EX stage
        ReadData_in  : in std_logic_vector(31 downto 0); -- Data read from memory (MEM stage)
        WriteReg_in  : in std_logic_vector(4 downto 0);  -- Register address to write to
        RegWrite_in  : in std_logic;  -- Control signal: Write enable for the register file
        WriteData_out: out std_logic_vector(31 downto 0) -- Data to write to the register file
    );
end WB_stage;

architecture Behavioral of WB_stage is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            WriteData_out <= (others => '0');
        elsif rising_edge(clk) then
            if RegWrite_in = '1' then
                if MemToReg_in = '1' then
                    WriteData_out <= ReadData_in;
                else
                    WriteData_out <= ALUResult_in; 
                end if;
            end if;
        end if;
    end process;
end Behavioral;

-- 40012358013
-- 40012358014
