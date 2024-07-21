library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pipeline_Registers is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           -- IF/ID
           IF_ID_PC_in : in  STD_LOGIC_VECTOR(31 downto 0);
           IF_ID_Instr_in : in  STD_LOGIC_VECTOR(31 downto 0);
           IF_ID_PC_out : out  STD_LOGIC_VECTOR(31 downto 0);
           IF_ID_Instr_out : out  STD_LOGIC_VECTOR(31 downto 0);
           -- ID/EX
           ID_EX_PC_in : in  STD_LOGIC_VECTOR(31 downto 0);
           ID_EX_Instr_in : in  STD_LOGIC_VECTOR(31 downto 0);
           ID_EX_PC_out : out  STD_LOGIC_VECTOR(31 downto 0);
           ID_EX_Instr_out : out  STD_LOGIC_VECTOR(31 downto 0));
end Pipeline_Registers;

architecture Behavioral of Pipeline_Registers is
    signal IF_ID_PC_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal IF_ID_Instr_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal ID_EX_PC_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal ID_EX_Instr_reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            IF_ID_PC_reg <= (others => '0');
            IF_ID_Instr_reg <= (others => '0');
            ID_EX_PC_reg <= (others => '0');
            ID_EX_Instr_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- IF/ID Pipeline Register
            IF_ID_PC_reg <= IF_ID_PC_in;
            IF_ID_Instr_reg <= IF_ID_Instr_in;
            -- ID/EX Pipeline Register
            ID_EX_PC_reg <= ID_EX_PC_in;
            ID_EX_Instr_reg <= ID_EX_Instr_in;
        end if;
    end process;

    -- Output signals
    IF_ID_PC_out <= IF_ID_PC_reg;
    IF_ID_Instr_out <= IF_ID_Instr_reg;
    ID_EX_PC_out <= ID_EX_PC_reg;
    ID_EX_Instr_out <= ID_EX_Instr_reg;
end Behavioral;
