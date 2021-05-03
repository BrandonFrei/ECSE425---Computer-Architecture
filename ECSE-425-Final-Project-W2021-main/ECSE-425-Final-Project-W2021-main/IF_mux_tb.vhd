library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_tb is
end mux_tb;

architecture behavior of mux_tb is

component IF_mux is
Port ( 	selector 	: in std_logic;
	muxinput1 	: in std_logic_vector(31 downto 0);
	muxinput2	: in std_logic_vector(31 downto 0);
	mux_output 	: out std_logic_vector(31 downto 0)
);
end component;

-- test signals 
constant clk_period : time := 1 ns;
signal  selector 	: std_logic := '0';
signal	muxinput1 	: std_logic_vector(31 downto 0) := x"00000004";
signal	muxinput2	: std_logic_vector(31 downto 0) := x"00000001";
signal	mux_output	: std_logic_vector(31 downto 0);

begin

mux : IF_mux
port map (
	selector 	=> selector,
	muxinput1 	=> muxinput1,
	muxinput2	=> muxinput2,
	mux_output 	=> mux_output
);

clk_process : process
begin
  selector <= '0';
  wait for clk_period;
  selector <= '1';
  wait for clk_period;
end process;
	
end;