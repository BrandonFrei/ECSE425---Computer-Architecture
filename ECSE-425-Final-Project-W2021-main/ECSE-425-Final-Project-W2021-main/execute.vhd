LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY execute IS
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
		
		-- R instruction signals
		shamt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		immediate : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		-- J type instruction signall
		Jtype_address: IN STD_LOGIC_VECTOR(25 downto 0); -- This is address output from decode.vhd
		
		address_in: IN STD_LOGIC_VECTOR(31 downto 0); -- This is PC address
		
		read_data_rs: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		read_data_rt: IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		address_out: OUT STD_LOGIC_VECTOR(31 downto 0);
		write_data_rd: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);		
END execute;

ARCHITECTURE behavioral OF execute IS
	
	-- This is double the size of read_data_rs; other 2 are same size
	signal product: STD_LOGIC_VECTOR(63 downto 0);
	signal memory_address: STD_LOGIC_VECTOR(31 downto 0);
	signal high_register: STD_LOGIC_VECTOR(31 downto 0);
	signal low_register: STD_LOGIC_VECTOR( 31 downto 0);
	signal branch_jump_offset: STD_LOGIC_VECTOR(31 downto 0);
	signal sign_extend_bit: STD_LOGIC;
	signal shift_amount: INTEGER;
	signal extended_immediate: STD_LOGIC_VECTOR(31 downto 0);
	
	begin 
	
	ALU_process: PROCESS(clock)
	
	begin
		if (Rinst = '1') then 
			case funct is 
				-- ADD (add)
				when "100000" =>
					write_data_rd <= STD_LOGIC_VECTOR(signed(read_data_rs) + signed(read_data_rt));
				-- SUBTRACT (sub)
				when "100010" =>
					write_data_rd <= STD_LOGIC_VECTOR(signed(read_data_rs) - signed(read_data_rt));
				-- MULTIPLY (mult)
				when "011000" =>
					product <= (others => '0');
					product <= STD_LOGIC_VECTOR(signed(read_data_rs) * signed(read_data_rt));
					high_register <= product(63 downto 32);
					low_register <= product(31 downto 0);
				-- DIVIDE (div)
				when "011010" =>
					high_register <= STD_LOGIC_VECTOR(signed(read_data_rs) mod signed(read_data_rt));
					low_register <= STD_LOGIC_VECTOR(signed(read_data_rs) / signed(read_data_rt));
				-- Move from HI ( mfhi)
				when "010000" =>
					write_data_rd <= high_register;
				-- Move from LOW ( mflo)
				when "010001" =>
					write_data_rd <= low_register;
				-- SET LESS THAN (slt)
				when "101010" =>
					if read_data_rs <  read_data_rt then
						write_data_rd <= std_logic_vector(to_unsigned(1, write_data_rd'length));
					else
						write_data_rd <= std_logic_vector(to_unsigned(0, write_data_rd'length));
					end if;
				-- AND (and)
				when "100100" =>
					write_data_rd <= read_data_rs AND read_data_rt;
				-- OR (or)
				when "100101" =>
					write_data_rd <= read_data_rs OR read_data_rt;
				-- NOR (nor)
				when "100110" =>
					write_data_rd <= read_data_rs NOR read_data_rt;
				-- XOR (xor)
				when "100111" =>
					write_data_rd <= read_data_rs XOR read_data_rt;
				-- Shift Left Logical (sll)
				when "000000" =>
					shift_amount <= to_integer(unsigned(shamt));
					write_data_rd <= STD_LOGIC_VECTOR(shift_left(unsigned(read_data_rs), shift_amount));
				
				-- Shift Right Logical (srl)
				when "000010" =>
					shift_amount <= to_integer(unsigned(shamt));
					write_data_rd <= STD_LOGIC_VECTOR(shift_right(unsigned(read_data_rs), shift_amount));
				
				-- Shift Right Arithmetic (sra)
				when "000011" =>
					shift_amount <= to_integer(unsigned(shamt));
					write_data_rd <= STD_LOGIC_VECTOR(shift_right(signed(read_data_rs), shift_amount));
	
				-- Jump register (jr); Read the address stored in some source register (typically %r31)
				when "001000" =>
					address_out <= read_data_rs;
				when others =>
					address_out <= address_in;
			end case;
				
		elsif (Jinst = '1') then 
			case opcode is
				-- Jump (j)
				when "000010" => 
					branch_jump_offset(1 downto 0) <= (others => '0');
					branch_jump_offset(27 downto 2) <= Jtype_address(25 downto 0);
					branch_jump_offset(31 downto 28) <= address_in(31 downto 28);
					address_out <= branch_jump_offset;
				-- Jump and Link (jal)
				when "000011" =>
					branch_jump_offset(1 downto 0) <= (others => '0');
					branch_jump_offset(27 downto 2) <= Jtype_address(25 downto 0);
					branch_jump_offset(31 downto 28) <= address_in(31 downto 28);
					address_out <= branch_jump_offset;
					write_data_rd <= address_in;
				when others =>
					address_out <= address_in;
			end case;
		
		elsif (Iinst = '1') then  
			case opcode is
				-- ADD Immediate (addi)
				when "001000" =>
						write_data_rd <= STD_LOGIC_VECTOR(signed(read_data_rs) + signed(immediate));
				-- Set Less Than Immediate (slti)
				when "001010" =>
					if read_data_rs <  immediate then
						write_data_rd <= std_logic_vector(to_unsigned(1, write_data_rd'length));
					else
						write_data_rd <= std_logic_vector(to_unsigned(0, write_data_rd'length));
					end if;
				-- And Immediate (andi)
				when "001100" =>
						-- Zero-extended immediate operand
						extended_immediate <= (others => '0');
						extended_immediate(15 downto 0) <= immediate;
						write_data_rd <= read_data_rs AND extended_immediate;
				-- Or Immediate (ori)
				when "001101" =>
						extended_immediate <= (others => '0');
						extended_immediate(15 downto 0) <= immediate;
						write_data_rd <= read_data_rs OR extended_immediate;
				-- Xor Immediate (xori)
				when "001110" =>
						extended_immediate <= (others => '0');
						extended_immediate(15 downto 0) <= immediate;
						write_data_rd <= read_data_rs XOR extended_immediate;
				-- Branch on Equal (beq)
				when "000100" =>
					if (read_data_rs = read_data_rt) then
						branch_jump_offset(1 downto 0) <= (others => '0');
						branch_jump_offset(17 downto 2) <= immediate;
						sign_extend_bit <= branch_jump_offset(1);
						branch_jump_offset(31 downto 18) <= (others => sign_extend_bit);
						address_out <= STD_LOGIC_VECTOR(unsigned(address_in) + unsigned(branch_jump_offset));
					end if;
				-- Branch on Not equal (bne)
				when "000101" =>
					if (read_data_rs /= read_data_rt) then
						branch_jump_offset(1 downto 0) <= (others => '0');
						branch_jump_offset(17 downto 2) <= immediate;
						sign_extend_bit <= branch_jump_offset(1);
						branch_jump_offset(31 downto 18) <= (others => sign_extend_bit);
						address_out <= STD_LOGIC_VECTOR(unsigned(address_in) + unsigned(branch_jump_offset));
					end if;
				-- Load upper immediate (lui)
				when "001111" =>
					write_data_rd(31 downto 16) <= immediate;
					write_data_rd(15 downto 0) <= (others => '0');
				-- Load Word (lw)
				when "100011" =>
					sign_extend_bit <= immediate(15);
					extended_immediate <= (others => sign_extend_bit);
					extended_immediate(15 downto 0) <= immediate;
					memory_address <= STD_LOGIC_VECTOR(unsigned(read_data_rs) + unsigned(extended_immediate));
					address_out <= memory_address;
					
				-- Store Word (lw)
				when "101011" =>
					memory_address <= STD_LOGIC_VECTOR(unsigned(read_data_rs) + unsigned(immediate));
					write_data_rd <= read_data_rt;
					address_out <= memory_address;
				when others =>
					address_out <= address_in;
			end case;
				
		end if; 

	END PROCESS;

END behavioral;
