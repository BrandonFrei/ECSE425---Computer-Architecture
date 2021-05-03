LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ID_tb IS
END ID_tb;

ARCHITECTURE behaviour OF ID_tb IS

--Declare the component that you are testing:
	COMPONENT IF_fetch IS
		Port ( 	
			clock : in std_logic;
			mux_selector : in std_logic;
			EX_adder_result: in STD_LOGIC_VECTOR (31 downto 0);
			IF_mux_output: out STD_LOGIC_VECTOR (31 downto 0);
			instruction : out std_logic_vector(31 downto 0)
		);
	END component;

    COMPONENT decode IS
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
    END COMPONENT;
	
	COMPONENT registers is
	GENERIC(
		register_size : INTEGER := 32;
		reg_delay : time := 1 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		rs: IN INTEGER RANGE 0 to register_size - 1;
		rt: IN INTEGER RANGE 0 to register_size - 1;
		rd: IN INTEGER RANGE 0 to register_size - 1;
		
		read_data_1: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		read_data_2: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		alu_output_data: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		reg_read: IN STD_LOGIC;
		reg_write: IN STD_LOGIC;
		read_data: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
	end component;
	
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
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
	constant register_size : INTEGER := 32;
	
	-- initialized to zero assuming there are no branches
	signal mux_selector: std_logic := '0';
	signal EX_adder_result: STD_LOGIC_VECTOR (31 downto 0);
	signal IF_mux_output: STD_LOGIC_VECTOR (31 downto 0);
	
	-- signal of decode
	signal instructionID:STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal rs: INTEGER RANGE 0 to register_size - 1;
	signal rt: INTEGER RANGE 0 to register_size - 1;
	signal rd: INTEGER RANGE 0 to register_size - 1;
	signal addressID: STD_LOGIC_VECTOR (25 DOWNTO 0);
	signal shamtID : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal functID : STD_LOGIC_VECTOR(5 DOWNTO 0);
	signal opcodeID : STD_LOGIC_VECTOR(5 DOWNTO 0);
	signal immediateID : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal RinstID: STD_LOGIC;
	signal JinstID: STD_LOGIC;
	signal IinstID: STD_LOGIC;
	
	-- signal of registers
	-- registers signals
	signal rsReg: INTEGER RANGE 0 to register_size - 1;
	signal rtReg: INTEGER RANGE 0 to register_size - 1;
	signal rdReg: INTEGER RANGE 0 to register_size - 1;
	signal read_data_1: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal read_data_2: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal alu_output_data: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal reg_read: STD_LOGIC;
	signal reg_write: STD_LOGIC;
	signal read_data: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal waitrequestReg: STD_LOGIC;
	
	-- signal of execute
	SIGNAL Rinst: STD_LOGIC;
	SIGNAL Jinst: STD_LOGIC;
	SIGNAL Iinst: STD_LOGIC;
	SIGNAL shamt: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL funct : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Jtype_address: STD_LOGIC_VECTOR(25 downto 0);
	SIGNAL address_in: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL read_data_rs: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL read_data_rt: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL address_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL write_data_rd: STD_LOGIC_VECTOR(31 DOWNTO 0);
	


BEGIN

    --dut => Device Under Test
	fetch: IF_fetch
	port map(
		clock => clk,
		mux_selector => mux_selector,
		EX_adder_result => address_out,
		IF_mux_output => IF_mux_output,
		instruction => instructionID
	);
	
    dut: decode
	port map(
		clock => clk,
		instruction => instructionID,
		rs => rs,
		rt => rt,
		rd => rd,
		address => addressID,
		shamt => shamtID,
		funct => functID,
		opcode => opcodeID,
		immediate => immediateID,
		Rinst => RinstID,
		Jinst => JinstID,
		Iinst => IinstID
	);
	
	registers_inst: registers
	port map(
		clock => clk,
		rs => rs,
		rt => rt,
		rd => rd,
		read_data_1 => read_data_1,
		read_data_2 => read_data_2,
		alu_output_data => alu_output_data,
		reg_read => reg_read,
		reg_write => reg_write,
		read_data => read_data,
		waitrequest => waitrequestReg
	);
	
	execute_inst: execute
	port map(
	    clock => clk,

	    Rinst => RinstID,
	    Jinst => JinstID,
	    Iinst => IinstID,
	    shamt => shamtID,
		opcode => opcodeID,
	    funct => functID,
	    immediate => immediateID,
	    Jtype_address => addressID,

	    address_in => address_in,
	    read_data_rs => read_data_1,
	    read_data_rt => read_data_2,
	    address_out => address_out,
	    write_data_rd => write_data_rd
	);

    clk_process : process
    BEGIN
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    test_process : process
    BEGIN
	
	
		-- instructionID <= "00100000001000010000000000000001";
			
		-- -- if (RinstID = '1' or IinstID = '1') then
			-- -- reg_read <= '1';
		-- -- end if;
		
		wait for clk_period;
		wait for clk_period;
		wait for clk_period;
		
		wait;
		

		
		
		-- instructionID <= "00010001011010111111111111111111";
		-- address_in <= "00000000000000000000000000001000";
		
		
		-- instructionID <= "00000010110101111010100000100000";
		
		-- wait for clk_period;
		-- wait for clk_period;
		-- wait for clk_period;
		
		-- instructionID <= "00001000000000000000000000010000";
		
        -- address <= 14; 
        -- writedata <= X"12";
        -- memwrite <= '1';
        
        -- --waits are NOT synthesizable and should not be used in a hardware design
        -- wait until rising_edge(waitrequest);
        -- memwrite <= '0';
        -- memread <= '1';
        -- wait until rising_edge(waitrequest);
        -- assert readdata = x"12" report "write unsuccessful" severity error;
        -- memread <= '0';
        -- wait for clk_period;
        -- address <= 12;memread <= '1';
        -- wait until rising_edge(waitrequest);
        -- assert readdata = x"0c" report "write unsuccessful" severity error;
        -- memread <= '0';
        -- wait;

    END PROCESS;

 

END;