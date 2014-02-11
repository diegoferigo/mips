library ieee;
use ieee.std_logic_1164.all;

ENTITY OutputControl is
	port (
		OC_in    : in  std_logic_vector(5 downto 0);
		RegWrite : out std_logic := '0'; -- to Registers
		ALUSrc   : out std_logic; -- Second ALU input MUX
		ALUOp    : out std_logic_vector(1 downto 0);
		MemWrite : out std_logic;
		--MemWrite_temp: out std_logic;
		MemRead  : out std_logic;
		RegDst   : out std_logic;
		MemToReg : out std_logic);
END OutputControl;

ARCHITECTURE OutputControl_1 of OutputControl is
--
BEGIN
--
	with OC_in select
		RegWrite <=
			--'1' when "101011", --0x2B only when store in memory
			'1' after 2 ns when "100011",--0x23 load by memory
			'1' after 2 ns when "000000",--0x00 all arithmetic functions
			'0' when others;

	with OC_in select
		ALUSrc <=
			'1' after 2 ns when "100011", --0x23 load word
			'1' after 2 ns when "101011", --0x2B store word
			'1' after 2 ns when "001000", --0x08 add immediate
			--TODO when branch 
			'0' when others;

	with OC_in select
		ALUOp <= --(00) always except when i have ram i/o (01) or branch (10)
			"00" after 2 ns when "000000", --Arith operation
			"01" after 2 ns when "100011", --RAM operations (load)
			"01" after 2 ns when "101011", --RAM operations (store)
			--"10" when "", --
			"11" when others;

	with OC_in select
		MemWrite <=
			'1' after 2 ns when "101011", --only store
			'0' when others;

	with OC_in select
    	MemRead <=
        	'1' after 2 ns when "100011", --only read
        	'0' when others;

	with OC_in select
		MemToReg <= --TODO
			'1' after 2 ns when "100011", --only read
			'0' when others;

	with OC_in select
		RegDst <=
			'0' after 2 ns when "100011", --0x23 load word
			'1' when others;
--
END OutputControl_1;