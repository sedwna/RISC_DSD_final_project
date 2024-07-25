library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity EX_stage is
    port (
        clk           : in std_logic;
        reset         : in std_logic;
        ALUControl_in : in std_logic_vector(3 downto 0);
        ALUSrc_in     : in std_logic;
        ALUOp_in      : in std_logic_vector(31 downto 0);
        ReadData1_in  : in std_logic_vector(31 downto 0);
        ReadData2_in  : in std_logic_vector(31 downto 0);
        ImmExt_in     : in std_logic_vector(31 downto 0);
        ALUResult_out : out std_logic_vector(31 downto 0);
        Zero_out      : out std_logic
    );
end EX_stage;

architecture Behavioral of EX_stage is

    signal ALUInput2 : std_logic_vector(31 downto 0);
    signal ALUResult : std_logic_vector(31 downto 0);
    signal Zero      : std_logic;

begin

    -- ALU Input Selection
    process(ALUSrc_in, ReadData2_in, ImmExt_in)
    begin
        if ALUSrc_in = '1' then
            ALUInput2 <= ImmExt_in;  -- Use immediate value
        else
            ALUInput2 <= ReadData2_in;  -- Use register value
        end if;
    end process;

    -- ALU Operations
    process(ALUControl_in, ReadData1_in, ALUInput2)
    begin
        case ALUControl_in is
            when "0000" =>  -- Addition
                ALUResult <= ReadData1_in + ALUInput2;
            when "0001" =>  -- Subtraction
                ALUResult <= ReadData1_in - ALUInput2;
            when "0010" =>  -- Logical AND
                ALUResult <= ReadData1_in and ALUInput2;
            when "0011" =>  -- Logical OR
                ALUResult <= ReadData1_in or ALUInput2;
            when "0100" =>  -- Logical XOR
                ALUResult <= ReadData1_in xor ALUInput2;
            when "0101" =>  -- Logical shift left
                ALUResult <= ReadData1_in sll conv_integer(ALUInput2(4 downto 0));
            when "0110" =>  -- Logical shift right
                ALUResult <= ReadData1_in srl conv_integer(ALUInput2(4 downto 0));
            when "0111" =>  -- Arithmetic shift right
                ALUResult <= ReadData1_in sra conv_integer(ALUInput2(4 downto 0));
            when "1000" =>  -- Set less than
                if ReadData1_in < ALUInput2 then
                    ALUResult <= (others => '1');
                else
                    ALUResult <= (others => '0');
                end if;
            when "1001" =>  -- Set less than unsigned
                if unsigned(ReadData1_in) < unsigned(ALUInput2) then
                    ALUResult <= (others => '1');
                else
                    ALUResult <= (others => '0');
                end if;
            when others =>
                ALUResult <= (others => '0');  -- Default case
        end case;

        -- Set the Zero flag
        if ALUResult = (others => '0') then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;

    -- Output assignments
    ALUResult_out <= ALUResult;
    Zero_out <= Zero;

end Behavioral;
