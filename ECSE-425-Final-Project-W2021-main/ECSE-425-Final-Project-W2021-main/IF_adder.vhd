library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IF_adder is
Port ( 	input1 	: in std_logic_vector(31 downto 0);
		input2	: in std_logic_vector(31 downto 0);
		adder_output 	: out std_logic_vector(31 downto 0)
);
end IF_adder ;

architecture behavioral of IF_adder is

begin

	adder_output <= input1 + input2;

end behavioral;

