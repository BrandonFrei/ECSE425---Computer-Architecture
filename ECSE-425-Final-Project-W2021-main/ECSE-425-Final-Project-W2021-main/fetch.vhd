library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_fetch is
Port ( 	clock : in std_logic;
		mux_selector : in std_logic;
		EX_adder_result: in STD_LOGIC_VECTOR (31 downto 0);
		IF_mux_output: out STD_LOGIC_VECTOR (31 downto 0);
		instruction : out std_logic_vector(31 downto 0)
);
end IF_fetch;

architecture behavioral of IF_fetch is

component PC is
Port (  clock : in std_logic;
		--reset : in std_logic;
		PC_input : in std_logic_vector(31 downto 0) := x"00000000";
		PC_output : out std_logic_vector(31 downto 0)
);
end component;

component IF_adder is
Port ( 	input1 	: in std_logic_vector(31 downto 0);
		input2	: in std_logic_vector(31 downto 0);
		adder_output 	: out std_logic_vector(31 downto 0)
);
end component;

component IF_mux is
Port ( 	selector : in std_logic;
		muxinput1 	: in std_logic_vector(31 downto 0);
		muxinput2	: in std_logic_vector(31 downto 0);
		mux_output 	: out std_logic_vector(31 downto 0)
);
end component;

-- Components
component memory IS
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

-- Signals
signal adder_signal : STD_LOGIC_VECTOR (31 downto 0);
signal PC_signal: STD_LOGIC_VECTOR (31 downto 0);
signal IF_mux_output_signal: STD_LOGIC_VECTOR (31 downto 0);
signal number_four: STD_LOGIC_VECTOR (31 downto 0) := x"00000004";

signal writedata: STD_LOGIC_VECTOR (31 downto 0);
signal address: INTEGER RANGE 0 TO 4096-1;
signal memwrite: STD_LOGIC;
signal memread: STD_LOGIC;
signal waitrequest: STD_LOGIC;

signal memory_address: INTEGER RANGE 0 TO 4096-1;

-- Behavior
BEGIN
	-- Signal and port assignment
	
	-- process(clock, PC_signal)
	--	if (clock'event and clock = '1') then 	
	--		PC_signal <= mux_output;
	--	end if;
	--  end process;

	--PC_signal <= IF_mux_output_signal when (clock'event and clock = '1');

	IF_PC: PC port map(clock, IF_mux_output_signal, PC_signal);
	IF_adder_CPU: IF_adder port map(number_four, PC_signal, adder_signal);
	IF_mux_CPU: IF_mux port map(mux_selector, adder_signal, EX_adder_result, IF_mux_output_signal);

	-- Cannot use direct integer value of PC, dividing by 4 (half-byte incrementation to 1024 instead of 4096)
	-- address <= to_integer(unsigned(PC_output(11 downto 0)));
	memory_address <= to_integer(unsigned(PC_signal(11 downto 0)));
	
	instructions_memory_CPU: memory generic map(ram_size => 4096) port map(clock, writedata, memory_address, memwrite, memread, instruction, waitrequest); -- Unsure about instruction signal


END behavioral;