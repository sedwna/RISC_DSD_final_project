library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tb is
end tb;

architecture Test of tb is

    -- Signal declarations
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal MemToReg_in  : std_logic;
    signal ALUResult_in : std_logic_vector(31 downto 0);
    signal ReadData_in  : std_logic_vector(31 downto 0);
    signal WriteReg_in  : std_logic_vector(4 downto 0);
    signal RegWrite_in  : std_logic;
    signal WriteData_out: std_logic_vector(31 downto 0);

    -- Instantiate the Unit Under Test (UUT)
    component WB_stage
        port (
            clk          : in std_logic;
            reset        : in std_logic;
            MemToReg_in  : in std_logic;
            ALUResult_in : in std_logic_vector(31 downto 0);
            ReadData_in  : in std_logic_vector(31 downto 0);
            WriteReg_in  : in std_logic_vector(4 downto 0);
            RegWrite_in  : in std_logic;
            WriteData_out: out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Instantiate UUT
    uut: WB_stage port map (
        clk => clk,
        reset => reset,
        MemToReg_in => MemToReg_in,
        ALUResult_in => ALUResult_in,
        ReadData_in => ReadData_in,
        WriteReg_in => WriteReg_in,
        RegWrite_in => RegWrite_in,
        WriteData_out => WriteData_out
    );

    -- Test sequence
    stimulus_process: process
    begin
        -- Initialize inputs
        reset <= '1';
        MemToReg_in <= '0';
        ALUResult_in <= (others => '0');
        ReadData_in <= (others => '0');
        WriteReg_in <= (others => '0');
        RegWrite_in <= '0';
        wait for 20 ns;

        -- Deassert reset and apply first set of inputs
        reset <= '0';
        MemToReg_in <= '0';
        ALUResult_in <= x"0000000A"; -- 10 in hex
        ReadData_in <= x"00000020";  -- 32 in hex
        WriteReg_in <= "00001";      -- Register 1
        RegWrite_in <= '1';
        wait for 20 ns;

        -- Test with MemToReg_in = 1 (write data from memory)
        MemToReg_in <= '1';
        wait for 20 ns;

        -- Test with RegWrite_in = 0 (no write)
        RegWrite_in <= '0';
        wait for 20 ns;

        -- Apply another set of values
        MemToReg_in <= '0';
        ALUResult_in <= x"0000000F"; -- 15 in hex
        ReadData_in <= x"00000040";  -- 64 in hex
        WriteReg_in <= "00010";      -- Register 2
        RegWrite_in <= '1';
        wait for 20 ns;

        -- Stop simulation
        wait;
    end process;

end Test;
