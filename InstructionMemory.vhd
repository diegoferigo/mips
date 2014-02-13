library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY InstructionMemory IS
	port (  
		inIM  : in  std_logic_vector(31 downto 0);
		outIM : out std_logic_vector(31 downto 0));
END InstructionMemory;

ARCHITECTURE InstructionMemory_1 of InstructionMemory is

	-- 2^32-1 x 32bit array to store the IM
	type mem_type is array (natural range <>) of std_logic_vector(7 downto 0);
	signal mem: mem_type(0 to 1023) := (
		-- Initialise first cycle
		0 => "00000000",
		1 => "00000000",
		2 => "00000000",
		3 => "00000000",
		-- Instruction 1_
		4 => "101011" & "00",	--op: store word
		                        --rs: location of register containing the memory start point (e.g. num 3)
		5 => "011" & "00100",   --rt: location of register containing the number to store (e.g. num 4)
		6 => "00000000",        --offset (e.g. 0)
		7 => "00000000",
		-- Instruction 2:
		8 => "100011" & "00",   --op: load word
		                        --rs: number 0 (register with the memory start point)
		9 => "001" & "00101",   --rt: location of register where load the number (e.g. num 5)
		10 => "00000000",       --offset (e.g. 6)
		11 => "00000110",
        -- Instruction 3:
        12 => "000000" & "00",  --op: 0x00 arithmetic
		                        --rs: register with 1st operand (3)
		13 => "011" & "00100",  --rt: register with 2nd operand (4)
		14 => "00111" & "000",  --rd: destination register (7)
		                        --shift: unused
		15 => "00" & "100000",  --funct: 0x20 add
		-- Instruction 4:
		--16 => "000010" & "00",
		--17 => "00000000",
		--18 => "00000000",
		--19 => "00000011",
		-- Instruction 5
		16 => "000100" & "00",
		17 => "011" & "01010",
		18 => "00000000",
		19 => "00000001",
		others=> (others => '0'));

	signal FullInstruction: std_logic_vector(31 downto 0); -- to merge the 4 memory bytes

BEGIN
--
	FullInstruction <= mem(to_integer(unsigned(inIM)))   & mem(to_integer(unsigned(inIM))+1) &
	                   mem(to_integer(unsigned(inIM))+2) & mem(to_integer(unsigned(inIM))+3);
	outIM <= FullInstruction;
--
END InstructionMemory_1;