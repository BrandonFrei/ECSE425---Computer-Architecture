LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY registers_tb IS
END registers_tb;

ARCHITECTURE behaviour OF registers_tb IS

--Declare the component that you are testing:
    COMPONENT registers IS
        GENERIC(
			register_size : INTEGER := 32;
			reg_delay : time := 1 ns;
			clock_period : time := 1 ns
        );
        PORT (
			clock: IN STD_LOGIC;
			writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rs: IN INTEGER RANGE 0 to register_size - 1;
			reg_read: IN STD_LOGIC;
			reg_write: IN STD_LOGIC;
			read_data: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			waitrequest: OUT STD_LOGIC
        );
    END COMPONENT;

    --all the input signals with initial values
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
    signal writedata: std_logic_vector(31 downto 0);
    signal address: INTEGER RANGE 0 TO 32-1;
    signal memwrite: STD_LOGIC := '0';
    signal memread: STD_LOGIC := '0';
    signal readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal waitrequest: STD_LOGIC;

BEGIN

    --dut => Device Under Test
    dut: registers GENERIC MAP(
            register_size => 5
                )
                PORT MAP(
                    clk,
                    writedata,
                    address,
                    memwrite,
                    memread,
                    readdata,
                    waitrequest
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