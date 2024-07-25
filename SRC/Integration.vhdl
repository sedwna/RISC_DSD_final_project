library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RISC_V_Processor is
    port (
        clk : in std_logic;
        reset : in std_logic
    );
end RISC_V_Processor;

architecture Behavioral of RISC_V_Processor is

    -- Signals between stages
    signal PC, NextPC : std_logic_vector(31 downto 0);
    signal Instruction : std_logic_vector(31 downto 0);
    signal ReadData1, ReadData2, ImmExt : std_logic_vector(31 downto 0);
    signal ALUResult, WriteData, Addr, ReadData : std_logic_vector(31 downto 0);
    signal MemWrite, MemRead, RegWrite, MemToReg, Zero, ALUControl : std_logic;
    signal WriteReg : std_logic_vector(4 downto 0);

begin

    -- IF_stage instantiation
    U_IF : entity work.IF_stage
        port map (
            clk => clk,
            reset => reset,
            PC_out => PC,
            NextPC_out => NextPC,
            Instruction_out => Instruction
        );

    -- ID_stage instantiation
    U_ID : entity work.ID_stage
        port map (
            clk => clk,
            reset => reset,
            Instr_in => Instruction,
            ReadData1_out => ReadData1,
            ReadData2_out => ReadData2,
            ImmExt_out => ImmExt,
            RegWrite_in => RegWrite,
            WriteReg_in => WriteReg,
            WriteData_in => WriteData
        );

    -- EX_stage instantiation
    U_EX : entity work.EX_stage
        port map (
            clk => clk,
            reset => reset,
            ReadData1_in => ReadData1,
            ReadData2_in => ReadData2,
            ImmExt_in => ImmExt,
            ALUControl_in => ALUControl,
            ALUResult_out => ALUResult,
            Zero_out => Zero
        );

    -- MEM_stage instantiation
    U_MEM : entity work.MEM_stage
        port map (
            clk => clk,
            reset => reset,
            Addr_in => ALUResult,
            WriteData_in => WriteData,
            MemWrite_in => MemWrite,
            MemRead_in => MemRead,
            ReadData_out => ReadData
        );

    -- WB_stage instantiation
    U_WB : entity work.WB_stage
        port map (
            clk => clk,
            reset => reset,
            MemToReg_in => MemToReg,
            ALUResult_in => ALUResult,
            ReadData_in => ReadData,
            WriteData_out => WriteData
        );

    -- Control Unit instantiation
    U_Control : entity work.Control_Unit
        port map (
            Instr_in => Instruction,
            ALUControl_out => ALUControl,
            MemWrite_out => MemWrite,
            MemRead_out => MemRead,
            RegWrite_out => RegWrite,
            MemToReg_out => MemToReg
        );

end Behavioral;
