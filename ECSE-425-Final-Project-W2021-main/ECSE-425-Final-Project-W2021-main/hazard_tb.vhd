LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY hazard_tb IS
END hazard_tb;

ARCHITECTURE behaviour OF hazard_tb IS
	component hazard is
		GENERIC(
			register_size : INTEGER := 32;
			clock_period : time := 1 ns
			);
		PORT (
			clock: IN STD_LOGIC;
			
			IF_ID_rs: IN INTEGER RANGE 0 to register_size - 1;
			IF_ID_rt: IN INTEGER RANGE 0 to register_size - 1;
			
			ID_EX_rs: IN INTEGER RANGE 0 to register_size - 1;
			ID_EX_rt: IN INTEGER RANGE 0 to register_size - 1;
			
			ID_EX_MemRead: IN STD_LOGIC;
			
			stall: out STD_LOGIC
		);
	end component;
	
	SIGNAL clk : std_logic := '0';
    	constant clk_period : time := 1 ns;	
    	signal IF_ID_rs: INTEGER RANGE 0 to 32 - 1;
    	signal IF_ID_rt: INTEGER RANGE 0 to 32 - 1;
    	signal ID_EX_rs: INTEGER RANGE 0 to 32 - 1;
    	signal ID_EX_rt: INTEGER RANGE 0 to 32 - 1;
    	signal ID_EX_MemRead: STD_LOGIC;
    	signal stall: STD_LOGIC;
    	
    	begin
    	
    	dut: hazard  
    	port map(
	    clock => clk,
	    
	    IF_ID_rs => IF_ID_rs, 
	    IF_ID_rt => IF_ID_rt,
	    ID_EX_rs => ID_EX_rs, -- Not important
	    ID_EX_rt => ID_EX_rt,
	    ID_EX_MemRead => ID_EX_MemRead,
	    stall => stall
	);
	
	clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process;
	
	test: process
		begin 
		ID_EX_rt <= 6;
		
		IF_ID_rs <= 7;
		IF_ID_rt <= 8;
		ID_EX_MemRead <= '1';
		wait for clk_period;
	end process;
	
end;
	
