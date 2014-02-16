library ieee;
use ieee.std_logic_1164.all;

ENTITY OutputControl is
	port (
		CLK      : in std_logic;
		OC_in    : in  std_logic_vector(5 downto 0);
		RegWrite : out std_logic := '0';
		ALUSrc   : out std_logic;
		ALUOp    : out std_logic_vector(2 downto 0);
		MemWrite : out std_logic;
		MemRead  : out std_logic;
		RegDst   : out std_logic;
		MemToReg : out std_logic;
		Jump     : out std_logic;
		Branch   : out std_logic);
END OutputControl;

ARCHITECTURE OutputControl_1 of OutputControl is
--
BEGIN
--
	with OC_in select
		RegWrite <=
			('1' and CLK) when "100011",--0x23 load by memory
			('1' and CLK) when "000000",--0x00 all arithmetic functions
			('1' and CLK) when "001000",--0x08 addi
			'0' when others;

	with OC_in select
		ALUSrc <=
			'1' after 2 ns when "100011", --0x23 load word
			'1' after 2 ns when "101011", --0x2B store word
			'1' after 2 ns when "001000", --0x08 addi
			'0' when others;

	with OC_in select
		ALUOp <=
			"000" after 2 ns when "000000", --Arith operation
			"001" after 2 ns when "100011", --RAM operations (load)
			"001" after 2 ns when "101011", --RAM operations (store)
			"010" after 2 ns when "000100", --0x04 beq
			"011" after 2 ns when "000101", --0x05 bne
			"100" after 2 ns when "001000", --0x08 addi
			"111" when others;

	with OC_in select
		MemWrite <=
			'1' after 10 ns when "101011", --only store
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
			'0' when "100011", --0x23 load word
			'0' when "001000", --0x08 addi
			'1' when others;

	with OC_in select
		Jump <=
			'1' when "000010", --0x02 jump to address
			'0' when others;

	with OC_in select
		Branch <=
			'1' when "000100", --0x04 beq
			'1' when "000101", --0x05 bne
			'0' when others;
--
END OutputControl_1;