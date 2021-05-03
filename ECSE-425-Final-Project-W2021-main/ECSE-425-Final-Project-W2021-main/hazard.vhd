library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard is
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

end hazard;

architecture behaviour of hazard is

begin

process (clock)
begin
	
	if((ID_EX_MemRead = '1') and (IF_ID_rs = ID_EX_rt or IF_ID_rt = ID_EX_rt)) then
		stall <= '1';
	else
		stall <= '0'; 
	end if;
	
end process;

end behaviour;
