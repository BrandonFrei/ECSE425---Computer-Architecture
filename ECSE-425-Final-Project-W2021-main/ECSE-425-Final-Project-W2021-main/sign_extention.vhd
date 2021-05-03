--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sign_extend IS
	GENERIC(
		register_size : INTEGER := 32
	);
	PORT (
		input_data: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		
		output_data: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	);
END decode;

architecture sign_extention of sign_extend is
	begin
	process
		
		output_data(15 downto 0) <= input_data((15 downto 0) ;
		
		if (input_data(15) = '1') then
			output_data(31 downto 16) <= "1111111111111111";
			-- sign extend input
		elsif (input_data(15) = '0') then
			output_data(31 downto 16) <= "0000000000000000";
		end if;
		
	end process;
	
end sign_extention;
