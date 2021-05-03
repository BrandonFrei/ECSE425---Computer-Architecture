library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_back is
Port ( 	clock : in std_logic;
		ALU_result 	: in std_logic_vector(31 downto 0);
		mem_readdata	: in std_logic_vector(31 downto 0);
		WB_mux_output 	: out std_logic_vector(31 downto 0)
);
end write_back;

architecture wb_behavioral of write_back is

component IF_mux is
Port ( 	selector : in std_logic;
		input1 	: in std_logic_vector(31 downto 0);
		input2	: in std_logic_vector(31 downto 0);
		mux_output 	: out std_logic_vector(31 downto 0)
);
end component;

BEGIN

-- edit (change from clock)
WB_mux_CPU: IF_mux port map(clock, ALU_result, mem_readdata, WB_mux_output);

-- WIP: mux output to register file

END wb_behavioral;