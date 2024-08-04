library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_stage is
    port (
        Instruction    : in std_logic_vector(31 downto 0);
        ReadData1_out  : out std_logic_vector(31 downto 0);
        ReadData2_out  : out std_logic_vector(31 downto 0);
        Immediate_out  : out std_logic_vector(31 downto 0);
        RegDst_out     : out std_logic;
        ALUOp_out      : out std_logic_vector(3 downto 0);
        ALUSrc_out     : out std_logic;
        RegWrite_out   : out std_logic;
        MemRead_out    : out std_logic;
        MemWrite_out   : out std_logic;
        MemToReg_out   : out std_logic
    );
end ID_stage;

architecture Behavioral of ID_stage is
begin
    process (Instruction)
    begin
        case Instruction(31 downto 26) is
            when "000000" => -- R-type
                ReadData1_out <= (others => '0'); 
                ReadData2_out <= (others => '0'); 
                Immediate_out <= (others => '0');
                RegDst_out <= '1';
                ALUOp_out <= "0010"; 
                ALUSrc_out <= '0';
                RegWrite_out <= '1';
                MemRead_out <= '0';
                MemWrite_out <= '0';
                MemToReg_out <= '0';
            when "100011" => -- LW
                ReadData1_out <= (others => '0'); 
                ReadData2_out <= (others => '0'); 
                Immediate_out <= Instruction(15 downto 0) & "0000000000000000";
                RegDst_out <= '0';
                ALUOp_out <= "0000"; 
                ALUSrc_out <= '1';
                RegWrite_out <= '1';
                MemRead_out <= '1';
                MemWrite_out <= '0';
                MemToReg_out <= '1';
            when "101011" => -- SW
                ReadData1_out <= (others => '0'); 
                ReadData2_out <= (others => '0'); 
                Immediate_out <= Instruction(15 downto 0) & "0000000000000000";
                RegDst_out <= '0';
                ALUOp_out <= "0000"; 
                ALUSrc_out <= '1';
                RegWrite_out <= '0';
                MemRead_out <= '0';
                MemWrite_out <= '1';
                MemToReg_out <= '0';
            when others =>
                ReadData1_out <= (others => '0');
                ReadData2_out <= (others => '0');
                Immediate_out <= (others => '0');
                RegDst_out <= '0';
                ALUOp_out <= (others => '0');
                ALUSrc_out <= '0';
                RegWrite_out <= '0';
                MemRead_out <= '0';
                MemWrite_out <= '0';
                MemToReg_out <= '0';
        end case;
    end process;
end Behavioral;

-- 40012358013
-- 40012358014
