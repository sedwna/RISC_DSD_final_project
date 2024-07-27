library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Integration is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic
        -- Define other global inputs/outputs as needed
    );
end Integration;

architecture Behavioral of Integration is

    -- Signals for inter-stage communication
    signal PC_in, PC_out, NextPC_out    : std_logic_vector(31 downto 0);
    signal Instruction_in, Instruction_out : std_logic_vector(31 downto 0);
    signal ImmExt_out, ReadData1, ReadData2 : std_logic_vector(31 downto 0);
    signal ALUResult_out, ReadData_MEM, ALUResult_WB : std_logic_vector(31 downto 0);
    signal Zero_out, MemRead, MemWrite, MemToReg_WB, RegWrite_WB : std_logic;
    signal WriteReg_in, WriteReg_out, WriteReg_WB : std_logic_vector(4 downto 0);
    signal RegWrite_in, ALUSrc_in, MemWrite_in, MemRead_in : std_logic;
    signal ALUControl_in : std_logic_vector(3 downto 0);
    signal WriteData_WB : std_logic_vector(31 downto 0); -- Added signal declaration

    -- Component declarations
    component IF_stage
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            PC_in      : in  std_logic_vector(31 downto 0);
            PC_out     : out std_logic_vector(31 downto 0);
            Instr_out  : out std_logic_vector(31 downto 0)
        );
    end component;

    component ID_stage
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            Instruction_in: in  std_logic_vector(31 downto 0);
            ImmExt_out    : out std_logic_vector(31 downto 0);
            ReadData1_out : out std_logic_vector(31 downto 0);
            ReadData2_out : out std_logic_vector(31 downto 0);
            WriteReg_out  : out std_logic_vector(4 downto 0);
            RegWrite_out  : out std_logic;
            ALUSrc_out    : out std_logic;
            ALUControl_out: out std_logic_vector(3 downto 0);
            MemWrite_out  : out std_logic;
            MemRead_out   : out std_logic;
            MemToReg_out  : out std_logic
        );
    end component;

    component EX_stage
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            ReadData1_in  : in  std_logic_vector(31 downto 0);
            ReadData2_in  : in  std_logic_vector(31 downto 0);
            ImmExt_in     : in  std_logic_vector(31 downto 0);
            ALUControl_in : in  std_logic_vector(3 downto 0);
            ALUSrc_in     : in  std_logic;
            ALUResult_out : out std_logic_vector(31 downto 0);
            Zero_out      : out std_logic
        );
    end component;

    component MEM_stage
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            ALUResult_in  : in  std_logic_vector(31 downto 0);
            ReadData2_in  : in  std_logic_vector(31 downto 0);
            MemWrite_in   : in  std_logic;
            MemRead_in    : in  std_logic;
            MemWrite_out  : out std_logic;
            MemRead_out   : out std_logic;
            ReadData_MEM  : out std_logic_vector(31 downto 0)
        );
    end component;

    component WB_stage
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            MemToReg_in   : in  std_logic;
            ALUResult_in  : in  std_logic_vector(31 downto 0);
            ReadData_in   : in  std_logic_vector(31 downto 0);
            WriteReg_in   : in  std_logic_vector(4 downto 0);
            RegWrite_in   : in  std_logic;
            WriteReg_out  : out std_logic_vector(4 downto 0);
            RegWrite_out  : out std_logic;
            WriteData_out : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Instantiate the IF stage
    IF_stage_inst : IF_stage
        port map (
            clk        => clk,
            reset      => reset,
            PC_in      => PC_in,
            PC_out     => NextPC_out,
            Instr_out  => Instruction_out
        );

    -- Instantiate the ID stage
    ID_stage_inst : ID_stage
        port map (
            clk           => clk,
            reset         => reset,
            Instruction_in => Instruction_out,
            ImmExt_out    => ImmExt_out,
            ReadData1_out => ReadData1,
            ReadData2_out => ReadData2,
            WriteReg_out  => WriteReg_out,
            RegWrite_out  => RegWrite_in,
            ALUSrc_out    => ALUSrc_in,
            ALUControl_out => ALUControl_in,
            MemWrite_out  => MemWrite_in,
            MemRead_out   => MemRead_in,
            MemToReg_out  => MemToReg_WB
        );

    -- Instantiate the EX stage
    EX_stage_inst : EX_stage
        port map (
            clk           => clk,
            reset         => reset,
            ReadData1_in  => ReadData1,
            ReadData2_in  => ReadData2,
            ImmExt_in     => ImmExt_out,
            ALUControl_in => ALUControl_in,
            ALUSrc_in     => ALUSrc_in,
            ALUResult_out => ALUResult_out,
            Zero_out      => Zero_out
        );

    -- Instantiate the MEM stage
    MEM_stage_inst : MEM_stage
        port map (
            clk           => clk,
            reset         => reset,
            ALUResult_in  => ALUResult_out,
            ReadData2_in  => ReadData2,
            MemWrite_in   => MemWrite_in,
            MemRead_in    => MemRead_in,
            MemWrite_out  => MemWrite,
            MemRead_out   => MemRead,
            ReadData_MEM  => ReadData_MEM
        );

    -- Instantiate the WB stage
    WB_stage_inst : WB_stage
        port map (
            clk           => clk,
            reset         => reset,
            MemToReg_in   => MemToReg_WB,
            ALUResult_in  => ALUResult_out,
            ReadData_in   => ReadData_MEM,
            WriteReg_in   => WriteReg_out,
            RegWrite_in   => RegWrite_in,
            WriteReg_out  => WriteReg_WB,
            RegWrite_out  => RegWrite_WB,
            WriteData_out => WriteData_WB -- Use the declared signal
        );

end Behavioral;
