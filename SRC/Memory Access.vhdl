library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MEM_stage is
    port (
        clk           : in std_logic;
        reset         : in std_logic;
        Addr_in       : in std_logic_vector(31 downto 0);
        WriteData_in  : in std_logic_vector(31 downto 0);
        MemWrite_in   : in std_logic;
        MemRead_in    : in std_logic;
        ReadData_out  : out std_logic_vector(31 downto 0)
    );
end MEM_stage;

architecture Behavioral of MEM_stage is
    type memory_type is array (0 to 1023) of std_logic_vector(31 downto 0);
    signal memory : memory_type := (others => (others => '0'));
    signal addr : integer;

begin


    process(Addr_in)
    begin
        addr <= conv_integer(Addr_in(11 downto 2)); 
    end process;


    process(clk)
    begin
        if rising_edge(clk) then
            if MemWrite_in = '1' then
                memory(addr) <= WriteData_in;
            end if;

            if MemRead_in = '1' then
                ReadData_out <= memory(addr); 
            else
                ReadData_out <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;

-- 40012358013
-- 40012358014
