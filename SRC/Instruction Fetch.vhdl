library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity IF_stage is
    port (
        clk       : in std_logic;
        reset     : in std_logic;
        PC_in     : in std_logic_vector(31 downto 0);
        PC_out    : out std_logic_vector(31 downto 0);
        Instr_out : out std_logic_vector(31 downto 0)
    );
end IF_stage;

architecture Behavioral of IF_stage is
    type memory_array is array (0 to 1023) of std_logic_vector(31 downto 0);
    signal instruction_memory : memory_array := (
        0 => x"00000000", 
        1 => x"00000000",
        2 => x"00000000",

        others => (others => '0')
    );

    signal PC_reg : std_logic_vector(31 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(clk) then
            PC_reg <= PC_in;
        end if;
    end process;

    PC_out <= PC_reg;
    Instr_out <= instruction_memory(to_integer(unsigned(PC_reg(11 downto 2))));

end Behavioral;

-- 40012358013
-- 40012358014
