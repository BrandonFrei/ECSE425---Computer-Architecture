library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_tb is
end fetch_tb;

architecture behavior of fetch_tb is

component PC is
Port (  clock : in std_logic;
		--reset : in std_logic;
		PC_input : in std_logic_vector(31 downto 0) := x"00000000";
		PC_output : out std_logic_vector(31 downto 0) := x"00000000"
);
end component;

component IF_adder is
Port ( 	input1 	: in std_logic_vector(31 downto 0);
		input2	: in std_logic_vector(31 downto 0);
		adder_output 	: out std_logic_vector(31 downto 0)
);
end component;

component memory is 
GENERIC(
    ram_size : INTEGER := 4096;
    mem_delay : time := 10 ns;
    clock_period : time := 1 ns
);
PORT (
    clock: IN STD_LOGIC;
    writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    address: IN INTEGER RANGE 0 TO ram_size-1;
    memwrite: IN STD_LOGIC;
    memread: IN STD_LOGIC;
    readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    waitrequest: OUT STD_LOGIC
);
end component;
	
component IF_mux is
Port ( 	selector : in std_logic;
		muxinput1 	: in std_logic_vector(31 downto 0);
		muxinput2	: in std_logic_vector(31 downto 0);
		mux_output 	: out std_logic_vector(31 downto 0)
);
end component;
	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;

signal PC_output: STD_LOGIC_VECTOR (31 downto 0);
signal IF_mux_output: STD_LOGIC_VECTOR (31 downto 0);

signal number_four: STD_LOGIC_VECTOR (31 downto 0) := x"00000004";
signal adder_signal : STD_LOGIC_VECTOR (31 downto 0);

signal writedata: STD_LOGIC_VECTOR (31 downto 0);
signal address: INTEGER RANGE 0 TO 4096-1;
signal memwrite: STD_LOGIC;
signal memread: STD_LOGIC;
signal instruction : std_logic_vector(31 downto 0);
signal waitrequest: STD_LOGIC;

signal mux_selector : std_logic := '0';
signal EX_adder_result: STD_LOGIC_VECTOR (31 downto 0);

signal mux_output_test: STD_LOGIC_VECTOR (31 downto 0);

begin

-- Cannot use direct integer value of PC, dividing by 4 (half-byte incrementation to 1024 instead of 4096)
address <= to_integer(unsigned(PC_output(11 downto 0)));
-- address <= to_integer(unsigned(PC_output(11 downto 0)))/4;

IF_PC: PC 
	port map(
		clk, 
		IF_mux_output, 
		PC_output
	);
	
IF_adder_CPU: IF_adder 
	port map(
		number_four,
		PC_output,
		adder_signal
	);
	
instructions_memory_CPU: memory generic map(
	ram_size => 4096
	)
	port map(
		clk,
		writedata,
		address,
		memwrite,
		memread,
		instruction,
		waitrequest
	);	
	
IF_mux_CPU: IF_mux
	port map(
		mux_selector,
		adder_signal,
		EX_adder_result,
		IF_mux_output
		--mux_output_test
	);	

clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;

test_process : process
begin

-- put your tests here
--	PC_output <= x"00000000";
	--IF_mux_output <= x"00000004";
	mux_selector <= '0'; 
	memread <= '1';
	memwrite <= '0';
	-- writedata <= "00000000000000000000000000000000";
	
	-- EX_adder_result <= x"00000010";
	
	-- Reset for next test
	WAIT FOR clk_period;
	WAIT FOR clk_period;
	WAIT FOR clk_period;
	WAIT FOR clk_period;
	WAIT FOR clk_period;
	WAIT FOR clk_period;

--	PC_signal <= x"00000000";
--	IF_mux_output <= x"00000004";
	-- mux_selector <= '1';
	-- memread <= '1';
	-- memwrite <= '0';
	-- writedata <= "00000000000000000000000000000000";
	
	-- EX_adder_result <= x"00000010";
	
	-- Reset for next test
	WAIT FOR clk_period;
	
	wait;
	
end process;
	
end;