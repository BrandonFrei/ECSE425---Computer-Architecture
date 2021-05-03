--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decode IS
	GENERIC(
		ram_size : INTEGER := 4096;
		mem_delay : time := 10 ns;
		clock_period : time := 1 ns;
		register_size : INTEGER := 32
	);
	PORT (
		clock: IN STD_LOGIC;
		instruction: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		rs: OUT INTEGER RANGE 0 to register_size - 1;
		rt: OUT INTEGER RANGE 0 to register_size - 1;
		rd: OUT INTEGER RANGE 0 to register_size - 1;
		
		address: OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
		
		
		shamt : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		funct : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		opcode : OUT  STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		immediate : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		Rinst: OUT STD_LOGIC;
		Jinst: OUT STD_LOGIC;
		Iinst: OUT STD_LOGIC
	);
END decode;

ARCHITECTURE dcd OF decode IS
	
	TYPE SPECIAL_REGISTER_DEF IS ARRAY(1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SPECIAL_REGISTERS: SPECIAL_REGISTER_DEF;
	
	
	BEGIN
	
	decode: PROCESS (CLOCK)
	
	VARIABLE temp_code: STD_LOGIC_VECTOR(5 downto 0);
	
	begin
		
		temp_code := instruction(31 downto 26);
		
		opcode <= instruction(31 downto 26);
		
		-- IF OPCODE = 0000000
			-- THEN IT IS R type
			-- read R1 and R2
			-- output Rs, Rt, Rd
			 
		IF (temp_code = "000000") THEN
			rs <= to_integer(unsigned(instruction(25 downto 21)));
			rt <= to_integer(unsigned(instruction(20 downto 16)));
			rd <= to_integer(unsigned(instruction(15 downto 11)));
			shamt <= instruction(10 downto 6);
			funct <= instruction(5 downto 0);
			
			Rinst <= '1';
			Jinst <= '0';
			Iinst <= '0';
				
			-- process funct
				-- case add
				-- case subtract
				-- case mult
				-- case div
				-- HOW TO MAP FUNCT TO ALU OPCODE?
			
		ELSIF (temp_code(5 downto 1) = "00001" ) THEN
			address <= instruction(25 downto 0);
			
			Rinst <= '0';
			Jinst <= '1';
			Iinst <= '0';
				
			
		ELSE 
			-- ASSUME IT IS I INSTRUCTION
			immediate <= instruction(15 downto 0);
			rs <= to_integer(unsigned(instruction(25 downto 21)));
			rt <= to_integer(unsigned(instruction(20 downto 16)));
			
			Rinst <= '0';
			Jinst <= '0';
			Iinst <= '1';
				
			
		END IF;
		
	END PROCESS;
	
END dcd;
