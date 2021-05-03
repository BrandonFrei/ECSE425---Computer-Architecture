library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_mux is
Port ( 	selector : in std_logic;
		muxinput1 	: in std_logic_vector(31 downto 0);
		muxinput2	: in std_logic_vector(31 downto 0); -- not sure if to include
		mux_output 	: out std_logic_vector(31 downto 0) -- not sure about instruction size
);
end IF_mux ;

architecture behavioral of IF_mux is

begin

process(selector, muxinput1, muxinput2)

begin
	-- Not sure if 'U' clock output could mess with condition statements here
	if selector = '0' then 
		mux_output <= muxinput1;
	else
		mux_output <= muxinput2;
	end if;
	
end process;

end behavioral;