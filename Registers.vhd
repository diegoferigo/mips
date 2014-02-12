library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Registers is
	port (
		RegIn1      : in   std_logic_vector(4 downto 0);
		RegIn2      : in   std_logic_vector(4 downto 0);
		RegWriteIn  : in   std_logic_vector(4 downto 0);
		DataWriteIn : in   std_logic_vector(31 downto 0);
		RegWrite    : in   std_logic;
		RegOut1     : out  std_logic_vector(31 downto 0);
		RegOut2     : out  std_logic_vector(31 downto 0));
END Registers;

ARCHITECTURE Registers_1 of Registers is
--
	type registers is array (0 to 31) of std_logic_vector(31 downto 0);
	signal regs: registers := (
			3=>"00000000000000000000000000000010",
			4=>"00000000000000000000111111000000",
			others=> (others => '0'));
--
BEGIN
--
	RegOut1 <= regs(to_integer(unsigned(RegIn1)));
	RegOut2 <= regs(to_integer(unsigned(RegIn2)));
	--
	regs(to_integer(unsigned(RegWriteIn))) <= DataWriteIn when RegWrite='1';
--
END Registers_1;