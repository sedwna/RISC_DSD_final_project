library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WB_stage is
    Port ( WriteData : in  STD_LOGIC_VECTOR(31 downto 0);
           WriteReg : in  STD_LOGIC_VECTOR(4 downto 0);
           RegWrite : out  STD_LOGIC;
           Data_out : out  STD_LOGIC_VECTOR(31 downto 0));
end WB_stage;

architecture Behavioral of WB_stage is
begin
    Data_out <= WriteData;
end Behavioral;
