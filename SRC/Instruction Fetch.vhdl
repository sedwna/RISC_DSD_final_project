library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IF_stage is
    port (
        clk : in std_logic;
        reset : in std_logic;
        PC_in : in std_logic_vector(31 downto 0);
        NextPC : out std_logic_vector(31 downto 0);
        Instr_out : out std_logic_vector(31 downto 0)
    );
end IF_stage;

architecture Behavioral of IF_stage is

    -- Internal signals
    signal PC : std_logic_vector(31 downto 0);

begin

    -- PC Register
    process(clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');  -- Reset PC to zero
        elsif rising_edge(clk) then
            PC <= PC_in;            -- Load the new PC value
        end if;
    end process;

    -- NextPC calculation (typically PC + 4 for RISC-V)
    NextPC <= PC + 4;

    -- Instruction Memory (For simplicity, assume a ROM-like array or predefined memory content)
    -- Here, we use a constant array for demonstration. In practice, this would be a ROM or a memory component.
    type memory_array is array (0 to 255) of std_logic_vector(31 downto 0);
    constant instruction_memory : memory_array := (
        0 => x"00000000", -- Example instruction
        1 => x"00000001", -- Example instruction
        -- More instructions...
        others => x"00000000"
    );

    -- Fetch the instruction from memory based on PC value
    Instr_out <= instruction_memory(conv_integer(PC(31 downto 2)));

end Behavioral;
