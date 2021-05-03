LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decode_tb IS
END decode_tb;

ARCHITECTURE behaviour OF decode_tb IS

--Declare the component that you are testing:
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

    --all the input signals with initial values
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
	constant register_size : INTEGER := 32;
	
	SIGNAL instruction: STD_LOGIC_VECTOR(31 downto 0);


BEGIN

    --dut => Device Under Test
    dut: decode GENERIC MAP(
            register_size => 32
                )
                PORT MAP(
                    clk,
					instruction,
                    rs,
                    rt,
                    rd,
                    address,
                    shamt,
                    funct,
					opcode,
					immediate,
					Rinst,
					Jinst,
					Iinst
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
        wait for clk_period;
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