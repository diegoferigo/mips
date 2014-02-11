library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

ENTITY OutputControl is
	port (
		OC_in    : in  std_logic_vector(5 downto 0);
		RegWrite : out std_logic := '0'; -- to Registers
		ALUSrc   : out std_logic; -- Second ALU input MUX
		ALUOp    : out std_logic_vector(1 downto 0); -- Second ALU input MUX
		MemWrite : out std_logic;
		--MemWrite_temp: out std_logic;
		MemRead  : out std_logic;
		MemToReg : out std_logic);
END OutputControl;

ARCHITECTURE OutputControl_1 of OutputControl is
--
BEGIN
--
	with OC_in select
		RegWrite <=
			--'1' when "101011", --0x2B only when store in memory
			'1' when "100011",--0x23 load by memory
			'0' when others;

	with OC_in select
		ALUSrc <=
			'1' when "100011", --0x23 load word
			'1' when "101011", --0x2B store word
			'1' when "001000", --0x08 add immediate
			--TODO when branch 
			'0' when others;

	with OC_in select
		ALUOp <=
			"00" when "111111", --00 always except when i have ram i/o or branch
			"01" when "100011", --RAM operations (load)
			"01" when "101011", --RAM operations (store)
			--"10" when "", --
			"11" when others;

	with OC_in select
		MemWrite <=
			'1' when "101011", --only store
			'0' when others;

	with OC_in select
    	MemRead <=
        	'1' when "100011", --only read
        	'0' when others;

	with OC_in select
		MemToReg <= --TODO
			'1' when "100011", --only read
			'0' when others;
--
END OutputControl_1;