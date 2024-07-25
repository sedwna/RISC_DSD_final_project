library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ID_stage is
    port (
        clk           : in std_logic;
        reset         : in std_logic;
        Instr_in      : in std_logic_vector(31 downto 0);
        RegWrite_in   : in std_logic;
        WriteReg_in   : in std_logic_vector(4 downto 0);
        WriteData_in  : in std_logic_vector(31 downto 0);
        ReadData1_out : out std_logic_vector(31 downto 0);
        ReadData2_out : out std_logic_vector(31 downto 0);
        ImmExt_out    : out std_logic_vector(31 downto 0)
    );
end ID_stage;

architecture Behavioral of ID_stage is

    -- Register File (32 registers x 32 bits)
    type regfile_array is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal regfile : regfile_array := (others => (others => '0'));

    -- Internal signals for decoding
    signal opcode : std_logic_vector(6 downto 0);
    signal rd     : std_logic_vector(4 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal rs1    : std_logic_vector(4 downto 0);
    signal rs2    : std_logic_vector(4 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    signal imm    : std_logic_vector(31 downto 0);

begin

    -- Decode the instruction fields
    opcode <= Instr_in(6 downto 0);
    rd     <= Instr_in(11 downto 7);
    funct3 <= Instr_in(14 downto 12);
    rs1    <= Instr_in(19 downto 15);
    rs2    <= Instr_in(24 downto 20);
    funct7 <= Instr_in(31 downto 25);

    -- Register file read
    ReadData1_out <= regfile(conv_integer(rs1));
    ReadData2_out <= regfile(conv_integer(rs2));

    -- Register file write (synchronous)
    process(clk, reset)
    begin
        if reset = '1' then
            regfile <= (others => (others => '0')); -- Reset register file
        elsif rising_edge(clk) then
            if RegWrite_in = '1' and WriteReg_in /= "00000" then
                regfile(conv_integer(WriteReg_in)) <= WriteData_in;
            end if;
        end if;
    end process;

    -- Immediate generation (assuming RV32I)
    process(Instr_in)
    begin
        case opcode is
            when "0010011" => -- I-type
                imm <= (others => Instr_in(31)) & Instr_in(30 downto 20);
            when "0000011" => -- Load instructions (I-type)
                imm <= (others => Instr_in(31)) & Instr_in(30 downto 20);
            when "0100011" => -- S-type
                imm <= (others => Instr_in(31)) & Instr_in(30 downto 25) & Instr_in(11 downto 7);
            when "1100011" => -- B-type
                imm <= (others => Instr_in(31)) & Instr_in(7) & Instr_in(30 downto 25) & Instr_in(11 downto 8) & '0';
            when "0110111", "0010111" => -- U-type
                imm <= Instr_in(31 downto 12) & (others => '0');
            when "1101111" => -- J-type
                imm <= (others => Instr_in(31)) & Instr_in(19 downto 12) & Instr_in(20) & Instr_in(30 downto 21) & '0';
            when others =>
                imm <= (others => '0');
        end case;
    end process;

    -- Output the immediate value
    ImmExt_out <= imm;

end Behavioral;
