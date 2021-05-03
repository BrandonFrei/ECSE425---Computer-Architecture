LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY forwarding_tb IS
END forwarding_tb;

ARCHITECTURE behaviour OF forwarding_tb IS
	component forwarding is
		GENERIC(
			register_size : INTEGER := 32;
			clock_period : time := 1 ns
			);
		PORT (
			clock: IN STD_LOGIC;
			
			ID_EX_rs: IN INTEGER RANGE 0 to register_size - 1;
			ID_EX_rt: IN INTEGER RANGE 0 to register_size - 1;
			
			-- Use to check for EX hazard 		
			EX_MEM_rd: IN INTEGER RANGE 0 to register_size - 1;
			
			EX_MEM_RegWrite: IN STD_LOGIC; 
			
			-- Use to check for MEM hazard
			MEM_WB_rd: IN INTEGER RANGE 0 to register_size - 1;
			
			MEM_WB_RegWrite: IN STD_LOGIC;
			
			-- Forwarding out 
			ALU_InputA: OUT STD_LOGIC_VECTOR(1 downto 0);
			ALU_InputB: OUT STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;
	
	signal clk : std_logic := '0';
    	constant clk_period : time := 1 ns;
    		
    	signal ID_EX_rs: INTEGER RANGE 0 to 32 - 1;
    	signal ID_EX_rt: INTEGER RANGE 0 to 32 - 1;
    	signal EX_MEM_rd: INTEGER RANGE 0 to 32 - 1;
    	signal MEM_WB_rd: INTEGER RANGE 0 to 32 - 1;
    	
    	signal EX_MEM_RegWrite: STD_LOGIC;
    	signal MEM_WB_RegWrite: STD_LOGIC;
    	
    	signal ALU_InputA: STD_LOGIC_VECTOR(1 downto 0);
    	signal ALU_InputB: STD_LOGIC_VECTOR(1 downto 0);
    	
    	begin
    	
    	dut: forwarding  
    	port map(
	    clock => clk,
	    
	    ID_EX_rs => ID_EX_rs,
	    ID_EX_rt => ID_EX_rt,
	    
	    EX_MEM_rd => EX_MEM_rd,
	    MEM_WB_rd => MEM_WB_rd,
	    
	    EX_MEM_RegWrite => EX_MEM_RegWrite,
	    MEM_WB_RegWrite => MEM_WB_RegWrite,
	    
	    ALU_InputA => ALU_InputA,
	    ALU_InputB => ALU_InputB
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
		-- Write test here
		
		-- Check for ForwardA = 10
		EX_MEM_RegWrite <= '1'; 
		EX_MEM_rd <= 1; 
		ID_EX_rs <= 1;
		ID_EX_rt <= 0;
		wait for clk_period;
		
		-- Check for ForwardB = 10
		EX_MEM_RegWrite <= '1'; 
		EX_MEM_rd <= 1; 
		ID_EX_rs <= 0;
		ID_EX_rt <= 1;
		wait for clk_period;
		
		-- Check for ForwardA = 01
		MEM_WB_RegWrite <= '1'; 
		MEM_WB_rd <= 2;
		EX_MEM_rd <= 1;
		ID_EX_rs <= 2;
		wait for clk_period;
		
		-- Check for ForwardB = 01 
		MEM_WB_RegWrite <= '1'; 
		MEM_WB_rd <= 2;
		EX_MEM_rd <= 1;
		ID_EX_rt <= 2;
		wait for clk_period;
		
	end process;
	
end;
	
