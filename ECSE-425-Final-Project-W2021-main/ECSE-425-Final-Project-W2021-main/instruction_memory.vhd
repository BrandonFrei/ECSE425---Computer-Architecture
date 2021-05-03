--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

ENTITY memory IS
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
END memory;

ARCHITECTURE rtl OF memory IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
BEGIN

	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
		FILE machine_code               : text;
		VARIABLE row                    : line;
		-- variable v_data_read            : t_integer_array(1 to NUM_COL);
		VARIABLE v_data_read            : STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		VARIABLE v_data_row_counter     : integer := 0;
	
		BEGIN
		
		IF (now < 1 ns)THEN
			file_open(machine_code,"benchmark1.txt", READ_MODE);
		
			WHILE (not endfile(machine_code)) LOOP
				readline(machine_code, row);
				
				read(row, v_data_read);
				
				ram_block(v_data_row_counter * 4) <= v_data_read(31 downto 24);
				ram_block(v_data_row_counter * 4 + 1) <= v_data_read(23 downto 16);
				ram_block(v_data_row_counter * 4 + 2) <= v_data_read(15 downto 8);
				ram_block(v_data_row_counter * 4 + 3) <= v_data_read(7 	downto 0);
				
				v_data_row_counter := v_data_row_counter + 1;
			
			END LOOP;
		END IF;
		file_close(machine_code);
		
		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (memwrite = '1') THEN
				ram_block(address) <= writedata	   (31 downto 24);
				ram_block(address + 1) <= writedata(23 downto 16);
				ram_block(address + 2) <= writedata(15 downto 8);
				ram_block(address + 3) <= writedata(7 downto 0);

			END IF;
		read_address_reg <= address;
		END IF;
	END PROCESS;

	readdata(31 downto 24) <= ram_block(read_address_reg + 0);
	readdata(23 downto 16) <= ram_block(read_address_reg + 1);
	readdata(15 downto 8) <= ram_block(read_address_reg + 2);
	readdata(7 downto 0) <= ram_block(read_address_reg + 3);
	


	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;

		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;
	waitrequest <= write_waitreq_reg and read_waitreq_reg;


END rtl;
