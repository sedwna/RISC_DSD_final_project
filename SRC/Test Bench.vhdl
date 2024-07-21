library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Pipelined_RISCV is
end tb_Pipelined_RISCV;

architecture Behavioral of tb_Pipelined_RISCV is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
begin
    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Instantiate the Unit Under Test (UUT)
    UUT : entity work.Pipelined_RISCV
        Port map ( clk => clk, reset => reset);

    -- Test procedure
    stimulus : process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Add stimulus here
        
        -- Wait for sufficient time to observe the behavior
        wait for 1000 ns;
        
        -- End simulation
        wait;
    end process;
end Behavioral;
