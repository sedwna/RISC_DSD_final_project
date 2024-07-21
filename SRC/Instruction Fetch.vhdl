library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- This is the correct library for numeric operations

entity IF_stage is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           PC_out : out  STD_LOGIC_VECTOR(31 downto 0);
           Instr_out : out  STD_LOGIC_VECTOR(31 downto 0));
end IF_stage;

architecture Behavioral of IF_stage is
    signal PC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    type RAM_TYPE is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal Instruction_Memory : RAM_TYPE := (others => (others => '0'));
begin
    process(clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            PC <= std_logic_vector(unsigned(PC) + 4); -- Add 4 to PC
        end if;
    end process;
    
    Instr_out <= Instruction_Memory(to_integer(unsigned(PC(31 downto 2))));
    PC_out <= PC;
end Behavioral;
