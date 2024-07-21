library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Correct library for numeric operations and conversions

entity MEM_stage is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Addr : in  STD_LOGIC_VECTOR(31 downto 0);
           WriteData : in  STD_LOGIC_VECTOR(31 downto 0);
           MemWrite, MemRead : in  STD_LOGIC;
           ReadData : out  STD_LOGIC_VECTOR(31 downto 0));
end MEM_stage;

architecture Behavioral of MEM_stage is
    type RAM_TYPE is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal Data_Memory : RAM_TYPE := (others => (others => '0'));
    signal read_data_internal : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            Data_Memory <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if MemWrite = '1' then
                Data_Memory(to_integer(unsigned(Addr(31 downto 2)))) <= WriteData;
            end if;
        end if;
    end process;
    
    process(MemRead, Addr)
    begin
        if MemRead = '1' then
            read_data_internal <= Data_Memory(to_integer(unsigned(Addr(31 downto 2))));
        else
            read_data_internal <= (others => '0');
        end if;
    end process;

    ReadData <= read_data_internal;
end Behavioral;
