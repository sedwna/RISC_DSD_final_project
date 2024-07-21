library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- This is the correct library for numeric operations

entity ID_stage is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Instr_in : in  STD_LOGIC_VECTOR(31 downto 0);
           PC_in : in  STD_LOGIC_VECTOR(31 downto 0);
           RegWrite : in  STD_LOGIC;
           WriteReg : in  STD_LOGIC_VECTOR(4 downto 0);
           WriteData : in  STD_LOGIC_VECTOR(31 downto 0);
           ReadData1, ReadData2 : out  STD_LOGIC_VECTOR(31 downto 0));
end ID_stage;

architecture Behavioral of ID_stage is
    type reg_file is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal Register_File : reg_file := (others => (others => '0'));
begin
    process(clk, reset)
    begin
        if reset = '1' then
            Register_File <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if RegWrite = '1' then
                Register_File(to_integer(unsigned(WriteReg))) <= WriteData;
            end if;
        end if;
    end process;
    
    ReadData1 <= Register_File(to_integer(unsigned(Instr_in(19 downto 15))));
    ReadData2 <= Register_File(to_integer(unsigned(Instr_in(24 downto 20))));
end Behavioral;
