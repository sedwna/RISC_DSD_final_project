library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pipelined_RISCV is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Pipelined_RISCV;

architecture Behavioral of Pipelined_RISCV is
    signal PC, Instr : STD_LOGIC_VECTOR(31 downto 0);
    signal IF_ID_PC, IF_ID_Instr : STD_LOGIC_VECTOR(31 downto 0);
    signal ID_EX_PC, ID_EX_Instr : STD_LOGIC_VECTOR(31 downto 0);
    -- Add more signals as needed
begin
    -- Instantiate IF Stage
    IF_stage_inst : entity work.IF_stage
        Port map ( clk => clk, reset => reset, PC_out => PC, Instr_out => Instr);
    
    -- Instantiate Pipeline Registers
    Pipeline_Registers_inst : entity work.Pipeline_Registers
        Port map ( clk => clk, reset => reset,
                   IF_ID_PC_in => PC, IF_ID_Instr_in => Instr,
                   IF_ID_PC_out => IF_ID_PC, IF_ID_Instr_out => IF_ID_Instr,
                   ID_EX_PC_in => IF_ID_PC, ID_EX_Instr_in => IF_ID_Instr,
                   ID_EX_PC_out => ID_EX_PC, ID_EX_Instr_out => ID_EX_Instr);
    
    -- Instantiate ID Stage
    ID_stage_inst : entity work.ID_stage
        Port map ( clk => clk, reset => reset, 
                   Instr_in => IF_ID_Instr, PC_in => IF_ID_PC,
                   RegWrite => '0', WriteReg => "00000", WriteData => (others => '0'),
                   ReadData1 => open, ReadData2 => open);

    -- Instantiate EX, MEM, and WB Stages similarly

end Behavioral;
