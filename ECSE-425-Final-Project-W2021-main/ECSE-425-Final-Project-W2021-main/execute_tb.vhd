LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY execute_tb IS
END execute_tb;

ARCHITECTURE behaviour OF execute_tb IS

--Declare the component that you are testing:
    COMPONENT execute IS
        GENERIC(
		ram_size : INTEGER := 4096;
		mem_delay : time := 10 ns;
		clock_period : time := 1 ns;
		register_size : INTEGER := 32
	);
	PORT (
		clock: IN STD_LOGIC;
		
		Rinst: IN STD_LOGIC;
		Jinst: IN STD_LOGIC;
		Iinst: IN STD_LOGIC;
		
		shamt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		immediate : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Jtype_address: IN STD_LOGIC_VECTOR(25 downto 0);
		
		address_in: IN STD_LOGIC_VECTOR(31 downto 0);
		read_data_rs: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		read_data_rt: IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		address_out: OUT STD_LOGIC_VECTOR(31 downto 0);
		write_data_rd: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    --all the input signals with initial values
	SIGNAL clk : std_logic := '0';
    	constant clk_period : time := 1 ns;
	
	SIGNAL Rinst: STD_LOGIC;
	SIGNAL Jinst: STD_LOGIC;
	SIGNAL Iinst: STD_LOGIC;
	
	SIGNAL shamt : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL funct : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Jtype_address: STD_LOGIC_VECTOR(25 downto 0);
	
	SIGNAL address_in: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL read_data_rs: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL read_data_rt: STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL address_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL write_data_rd: STD_LOGIC_VECTOR(31 DOWNTO 0);


	BEGIN

	dut: execute 
	port map(
	    clock => clk,

	    Rinst => Rinst,
	    Jinst => Jinst,
	    Iinst => Iinst,
	    shamt => shamt,
	    funct => funct,
	    opcode => opcode,
	    immediate => immediate,
	    Jtype_address => Jtype_address,

	    address_in => address_in,
	    read_data_rs => read_data_rs,
	    read_data_rt => read_data_rt,
	    address_out => address_out,
	    write_data_rd => write_data_rd
	);
	
	clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process;
	
	test: process
		begin 
		-- R type instructions:
		Rinst <= '1';
		Jinst <= '0';
		Iinst <= '0'; 
		
		--ADDITION TEST: 
		funct <= "100000";
		read_data_rs <= (others => '0');
		read_data_rs(2 downto 0) <= "001"; 
		read_data_rt <= (others => '0');
		read_data_rt(2 downto 0) <= "010";
		wait for clk_period;
		
		--SUBTRACTION TEST: 
		funct <= "100010";
		read_data_rs <= (others => '0');
		read_data_rs(2 downto 0) <= "011"; 
		read_data_rt <= (others => '0');
		read_data_rt(2 downto 0) <= "010";
		wait for clk_period;
		
		--MULTIPLICATION TEST:
		--funct <= "011000";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "010"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		--funct <= "010000"; -- should return all zeores
		--wait for clk_period; 
		--funct <= "010001"; -- should return 100 or 4
		--wait for clk_period;
		
		--DIVISION TEST:
		--funct <= "011010";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "100"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		--funct <= "010000"; -- should return all zeores
		--wait for clk_period; 
		--funct <= "010001"; -- should return 010 or 2
		--wait for clk_period;
		
		--SET LESS THAN:
		--funct <= "101010";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "001"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		
		--AND TEST: 
		--funct <= "100100";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "111"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		
		--OR TEST: 
		--funct <= "100101";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		
		--NOR TEST: 
		--funct <= "100110";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "001"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		
		--XOR TEST: 
		--funct <= "100111";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--wait for clk_period;
		
		--Shift Left Logical TEST:
		--funct <= "000000";
		--shamt <= "00100";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "001";  
		--wait for clk_period;
		
		--Shift Right Logical TEST:
		--funct <= "000010";
		--shamt <= "00010";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "100";  
		--wait for clk_period;
		
		--Shift Right Arithmetic TEST:
		--funct <= "000011";
		--shamt <= "00010";
		--read_data_rs <= (others => '0');
		--read_data_rs(31) <= '1';
		--read_data_rs(2 downto 0) <= "100";  
		--wait for clk_period;
		
		-- JUMP REGISTER TEST: 
		--funct <= "001000";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101";
		--wait for clk_period;
		
		-- J type instructions:
		Rinst <= '0';
		Jinst <= '1';
		Iinst <= '0'; 
		
		--JUMP TEST:
		--funct <= "000010";
		--Jtype_address <= (others => '0');
		--address_in <= (others => '0');
		--Jtype_address(2 downto 0) <= "001"; 
		--address_in(31 downto 28) <= "1111";
		--wait for clk_period;
		
		--JUMP AND LINK TEST:
		--funct <= "000011";
		--Jtype_address <= (others => '0');
		--address_in <= (others => '0');
		--Jtype_address(2 downto 0) <= "001"; 
		--address_in(31 downto 28) <= "1111";
		--wait for clk_period;
		
		-- I type instructions:
		Rinst <= '0';
		Jinst <= '0';
		Iinst <= '1'; 
		
		--ADD IMMEDIATE TEST:
		funct <= "001000";
		read_data_rs <= (others => '0');
		immediate <= (others => '0');
		read_data_rs(2 downto 0) <= "001"; 
		immediate(2 downto 0) <= "001";
		wait for clk_period;
		
		wait;
		
		--Set Less Than Immediate TEST:
		--funct <= "001010";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "001"; 
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--wait for clk_period;
		
		--AND IMMEDIATE TEST: 
		--funct <= "001100";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "111"; 
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--wait for clk_period;
		
		--OR IMMEDIATE TEST: 
		--funct <= "001101";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101"; 
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--wait for clk_period;
		
		--XOR IMMEDIATE TEST: 
		--funct <= "001110";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101"; 
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--wait for clk_period;
		
		--BRANCH ON EQUAL TEST: 
		--funct <= "000100";
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--address_in <= (others => '0');
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "101";
		--wait for clk_period;
		
		--BRANCH ON EQUAL TEST: 
		--funct <= "000101";
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--address_in <= (others => '0'); 
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "111"; 
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "101";
		--wait for clk_period;
		
		--LOAD WORD TEST:
		--funct <= "100011";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101"; 
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--wait for clk_period;
		
		--STORE WORD TEST:
		--funct <= "101011";
		--read_data_rs <= (others => '0');
		--read_data_rs(2 downto 0) <= "101";
		--read_data_rt <= (others => '0');
		--read_data_rt(2 downto 0) <= "010";
		--immediate <= (others => '0');
		--immediate(2 downto 0) <= "010";
		--wait for clk_period;
		
	end process;
	
end;

