library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding is
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

end forwarding;

architecture behaviour of forwarding is

begin

process (clock)
begin
	-- EX Hazard
	if((EX_MEM_RegWrite = '1') and (EX_MEM_rd /= 0) and (EX_MEM_rd = ID_EX_rs)) then
		ALU_InputA <= "10";
	end if; 
	
	if((EX_MEM_RegWrite = '1') and (EX_MEM_rd /= 0) and (EX_MEM_rd = ID_EX_rt)) then
		ALU_InputB <= "10";
	end if;
	 
	-- MEM Hazard
	if((MEM_WB_RegWrite = '1') and (MEM_WB_rd /= 0) and (EX_MEM_rd /= ID_EX_rs) and (MEM_WB_rd = ID_EX_rs)) then
		ALU_InputA <= "01";
	end if; 
	
	if((MEM_WB_RegWrite = '1') and (MEM_WB_rd /= 0) and (EX_MEM_rd /= ID_EX_rt) and (MEM_WB_rd = ID_EX_rt)) then
		ALU_InputB <= "01";
	end if; 
	
end process;

end behaviour;
