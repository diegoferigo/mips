library ieee;
use ieee.std_logic_1164.all;

ENTITY TestBenchRAM is
END TestBenchRAM;

ARCHITECTURE TestBench_RAM of TestBenchRAM is

	component Memory
		port (  
			inRAM     : in  std_logic_vector(31 downto 0); -- the address from alu
			WriteData : in  std_logic_vector(31 downto 0); -- the data from 2nd register
			MemWrite  : in  std_logic;                     -- the write signal from the OutputControl
			MemRead   : in  std_logic;                     -- the read signal from the OutputControl
			outRAM    : out std_logic_vector(31 downto 0);-- the output if is a read operation
			reset     : in  std_logic);  
	end component;

	signal CLK: std_ulogic;
	signal Rst: std_ulogic;
	signal inRAM     : std_logic_vector(31 downto 0);
	signal WriteData : std_logic_vector(31 downto 0);
	signal MemWrite  : std_logic;
	signal MemRead   : std_logic;
	signal outRAM    : std_logic_vector(31 downto 0);

BEGIN
--
	--Unit Under Test:
	UUT:  Memory
		port map (inRAM, WriteData, MemWrite, MemRead, outRAM, Rst);

	clock: process
		variable clktmp : std_ulogic:='1';
		variable reset  : std_ulogic:='1';
	begin
		clktmp:= NOT clktmp;
		CLK <= clktmp;
		if (reset = '1') then
			Rst <= reset;
			reset := '0';
		else
			Rst <= '0';
		end if;
		wait for 50 ns;   
	end process;
--
	stimilus: process(CLK)
	begin
		if (rising_edge(CLK)) then
			inRAM     <= "00000000000000000000000000000110";
			WriteData <= "11000000000000000000000000000011";
			MemWrite  <= '1' after 2 ns;
			MemRead   <= '0';
		end if;
	end process;
--
END TestBench_RAM;