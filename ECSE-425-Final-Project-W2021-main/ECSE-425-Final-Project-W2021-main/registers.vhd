LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

ENTITY registers IS
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
END registers;

ARCHITECTURE reg of registers IS


	TYPE REGISTER_DEF IS ARRAY(31 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REGISTERS: REGISTER_DEF := (1 => "00000000000000000000000000000111", 
									   22 => "00000000000000000000000000000110",
									   23 => "00000000000000000000000000000100", OTHERS=> "00000000000000000000000000000000");

BEGIN 
	reg_init_process: PROCESS (clock)
	
		-- FILE register_file              : text;
		file register_file : text open write_mode is "register_file.txt";
		
		VARIABLE row                    : line;
		-- variable v_data_read            : t_integer_array(1 to NUM_COL);
		VARIABLE v_data_write            : STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		VARIABLE v_data_row_counter     : integer := 0;
	
		BEGIN
		
		IF (now < 1 ns) THEN
			-- file_open(register_file,"register_file.txt", WRITE_MODE);
			
			v_data_write := "00000000000000000000000000000000";
			
			WHILE (v_data_row_counter < 32) LOOP
				-- Write value to line
				-- NOTE: IF STATEMENT FOR TESTING!!!!
				if (v_data_row_counter = 1) then 
					v_data_write := "00000000000000000000000000000111";
					write(row, v_data_write);
					-- Write line to the file
					writeline(register_file ,row);
					v_data_write := "00000000000000000000000000000000";
				
				else 
				
					write(row, v_data_write);
					-- Write line to the file
					writeline(register_file ,row);
				end if;
				
				v_data_row_counter:= v_data_row_counter + 1;
				
			END LOOP;
		END IF;
	
	END process;
	
	
	-- register_read: process (reg_read)
	-- begin
		-- IF (reg_read = '1') THEN
		-- read from registers
			-- read_data_1 <= REGISTERS(rs);
			-- read_data_2 <= REGISTERS(rt);	
		-- end if;
	-- end process;
	
		
	PROCESS (clock)
	BEGIN
		IF (clock'event) THEN
		-- read from registers
			read_data_1 <= REGISTERS(rs);
			read_data_2 <= REGISTERS(rt);	
		end if;
	end process;
	
	
	register_write: process (clock, reg_write)
	begin
		IF (reg_write = '1') THEN
			REGISTERS(rd) <= alu_output_data; -- write back
		end if;
	end process;
	
	
END ARCHITECTURE;
		