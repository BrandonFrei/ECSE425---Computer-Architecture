--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

ENTITY memory_access IS
	GENERIC(
		ram_size : INTEGER := 4096;
		mem_delay : time := 10 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		
		-- from decode stage
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		-- from execute
		address: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		-- output to write back 
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		
		-- control signals to determine whether we write or read to memory
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		
		-- signals between mem access and data memory (same as cache assignemnt)
		m_address: out STD_LOGIC_VECTOR (31 downto 0);
		m_read : out std_logic;
		m_readdata : in std_logic_vector (31 downto 0);
		m_write : out std_logic;
		m_writedata : out std_logic_vector (31 downto 0);
		m_waitrequest : in std_logic
		
	);
END memory_access;

architecture mem_acc of memory_access IS

begin

	-- write mem process
	process (memwrite, memread) -- might also depend 
		begin
		
		-- set memory address to input address of stage
		m_address <= address;
		
		if (memwrite = '1') then 
			m_write <= '1';
			m_writedata <= writedata;
		
	-- read mem process
		elsif (memread = '1') then 
			m_read <= '1';
		end if;
	end process;	
	readdata <= m_readdata;
end mem_acc;
		



