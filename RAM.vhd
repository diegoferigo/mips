library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Memory IS
	port (  
		inRAM     : in  std_logic_vector(31 downto 0); -- the address from alu
		WriteData : in  std_logic_vector(31 downto 0); -- the data from 2nd register
		MemWrite  : in  std_logic;                     -- the write signal from the OutputControl
		MemRead   : in  std_logic;                     -- the read signal from the OutputControl
		outRAM    : out std_logic_vector(31 downto 0);-- the output if is a read operation
		reset     : in  std_logic);
END Memory;

ARCHITECTURE Memory_1 of Memory is

	type ram_type is array (natural range <>) of std_logic_vector(31 downto 0);
	signal ram:     ram_type(0 to 1023) := (6 => "00000000000000000000000011001100", others=> (others => '0'));
	signal Address: integer := 0;

BEGIN
--
	-- Convert the address to an integer >= 0
	Address <= to_integer(unsigned(inRAM));

	-- Write to the right location only if MemWrite is 1 and reset is 0
	ram(Address)    <= WriteData when (MemWrite='1' and reset='0');

	-- Put on the output port the ram value always except when reset is 1
	-- p.s. outRAM has always the value of the ram(Address) location, also when writing
	-- Then will be the MUX connected to outRAM to let the data flow (MemWrite=1) or not
	with reset select
		outRAM <=
			ram(Address)    when '0',
			(others => '0') when others;
--
END Memory_1;