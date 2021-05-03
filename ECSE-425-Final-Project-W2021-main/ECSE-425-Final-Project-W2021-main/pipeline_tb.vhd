LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pipeline_tb IS
END pipeline_tb;

ARCHITECTURE behaviour OF pipeline_tb IS

--Declare the component that you are testing:
    COMPONENT pipeline IS
        GENERIC(
		register_size : INTEGER := 32;
		ram_size: INTEGER := 8192;
		reg_delay : time := 1 ns;
		clock_period : time := 1 ns;
		instruction_mem_size : INTEGER := 4096;
		mem_delay : time := 10 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		reset: IN STD_LOGIC
	);
    END COMPONENT;

    --all the input signals with initial values
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
	signal reset: STD_LOGIC;
		

BEGIN

    --dut => Device Under Test
    dut: pipeline GENERIC MAP(
        ram_size => 15
			)
			PORT MAP(
				clk,
				reset
			);

    clk_process : process
    BEGIN
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    test_process : process
    BEGIN
        wait for clk_period;
		wait for clk_period;
		wait for clk_period;
		wait for clk_period;
		wait for clk_period;
		wait;
        -- address <= 14; 
        -- writedata <= X"12";
        -- memwrite <= '1';
        
        -- --waits are NOT synthesizable and should not be used in a hardware design
        -- wait until rising_edge(waitrequest);
        -- memwrite <= '0';
        -- memread <= '1';
        -- wait until rising_edge(waitrequest);
        -- assert readdata = x"12" report "write unsuccessful" severity error;
        -- memread <= '0';
        -- wait for clk_period;
        -- address <= 12;memread <= '1';
        -- wait until rising_edge(waitrequest);
        -- assert readdata = x"0c" report "write unsuccessful" severity error;
        -- memread <= '0';
        -- wait;

    END PROCESS;

 

END;