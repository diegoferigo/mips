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
              
		--4 => "101011" & "00", --op: store word
		                        --rs: number 4 (memory start point)
		--5 => "100" & "00011", --rt: location of register containing the number to store (e.g. num 3)
		--6 => "00000000",      --offset (e.g. 0)
		--7 => "00000001",
		others=> (others => '0'));

	signal FullInstruction: std_logic_vector(31 downto 0); -- to merge the 4 memory bytes

BEGIN
	-- Allocate some instruction
	--
	--TODO
	--(1) store word memory
	--(2) load word memory
	--(3) perform an addition/shift etc
	--
	--mem(0)  <= "101011" & "00"; --op: store word
	                              --rs: number 4 (memory start point)
	--mem(1)  <= "100" & "00011"; --rt: location of register containing the number to store (e.g. num 3)
	--mem(2)  <= "00000000";      --offset (e.g. 0)
	--mem(3)  <= "00000001";
	--
	--mem(4)  <= "100011" & "00"; --op: load word
	                              --rs: number 4 (memory start point)
	--mem(5)  <= "100" & "00100"; --rt: location of register containing the number to store (e.g. num 4)
	--mem(6)  <= "00000000";      --offset (e.g. 2)
	--mem(7)  <= "00000000";
	--
	-- WARNING: addimmediate is I type
	--mem(8)  <= "001000" & "00"; --op: (0x08) add immediate
	                              --rs: register 1 has the source value
	--mem(9)  <= "000" & "00111"; --rt: value to add to register 1 and store to R0 (e.g. 7);
	--mem(10) <= "00000" & "000"; --rd: register 0;
	                              --shamt
	--mem(11) <= "00" & "000000"; --funct:
	--
	--mem(12)  <= "000000" & "00"; --op: (0x00) operazioni aritmetiche
	                               --rs: 
	--mem(13)  <= "000" & "00000"; --rt:
	--mem(14) <= "00000" & "000";  --rd:
	                               --shamt
	--mem(15) <= "00" & "000011"; --funct:
	--
	--FullInstruction <=  mem(conv_integer(inIM)) & mem(conv_integer(inIM + 1))
	--                    & mem(conv_integer(inIM + 2)) & mem(conv_integer(inIM + 3));

	FullInstruction <= mem(to_integer(unsigned(inIM)))   & mem(to_integer(unsigned(inIM))+1) &
	                   mem(to_integer(unsigned(inIM))+2) & mem(to_integer(unsigned(inIM))+3);
	outIM <= FullInstruction;
--
END InstructionMemory_1;