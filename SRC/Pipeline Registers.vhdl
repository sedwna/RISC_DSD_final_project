library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity register is
    port (
        clk           : in std_logic;
        reset         : in std_logic;

        MemToReg_in   : in std_logic;
        ALUResult_in  : in std_logic_vector(31 downto 0);
        ReadData_in   : in std_logic_vector(31 downto 0);
        WriteReg_in   : in std_logic_vector(4 downto 0);
        RegWrite_in   : in std_logic;

        MemToReg_out  : out std_logic;
        ALUResult_out : out std_logic_vector(31 downto 0);
        ReadData_out  : out std_logic_vector(31 downto 0);
        WriteReg_out  : out std_logic_vector(4 downto 0);
        RegWrite_out  : out std_logic
    );
end register;

architecture Behavioral of register is
begin
    process (clk, reset)
    begin
        if reset = '1' then

            MemToReg_out <= '0';
            ALUResult_out <= (others => '0');
            ReadData_out <= (others => '0');
            WriteReg_out <= (others => '0');
            RegWrite_out <= '0';
        elsif rising_edge(clk) then

            MemToReg_out <= MemToReg_in;
            ALUResult_out <= ALUResult_in;
            ReadData_out <= ReadData_in;
            WriteReg_out <= WriteReg_in;
            RegWrite_out <= RegWrite_in;
        end if;
    end process;
end Behavioral;

-- 40012358013
-- 40012358014
