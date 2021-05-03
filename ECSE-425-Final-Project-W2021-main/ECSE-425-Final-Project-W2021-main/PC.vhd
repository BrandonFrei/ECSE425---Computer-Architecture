library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
Port (  clock : in std_logic;
		PC_input : in std_logic_vector(31 downto 0) := x"00000000";
		PC_output : out std_logic_vector(31 downto 0) := x"00000000"
);

end PC;

architecture behaviour of PC is

signal PC_inter : std_logic_vector(31 downto 0) := x"00000000";

begin

--process (clock, reset)
process (clock, PC_input)
begin

--	if (clock = '0') then
--		--PC_output <= PC_inter;
--		PC_inter <= PC_input;
--	elsif (clock'event and clock = '0') then 	
--		PC_inter <= PC_input;
--	elsif (clock'event and clock = '1') then 	
--		--PC_inter <= PC_input;
--		PC_output <= PC_inter;
--	end if;
	
	if (clock'event and clock = '1') then 
		--PC_inter <= PC_input;
		--PC_output <= PC_inter;

		PC_output <= PC_input;
		
	end if;
	
end process;

end behaviour;