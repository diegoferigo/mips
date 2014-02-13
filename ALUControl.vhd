library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

ENTITY ALUControl is
	port (
		ALUOp       : in  std_logic_vector(2 downto 0);
		Funct       : in  std_logic_vector(5 downto 0);
		ALUCont_out : out std_logic_vector(3 downto 0));
END ALUControl;

ARCHITECTURE ALUControl_1 of ALUControl is
--
	signal tmpALUControl_func: std_logic_vector(3 downto 0) := (others=>'0');
	signal tmpALUControl_op:   std_logic_vector(3 downto 0) := (others=>'0');
--
-- OP mapping:
--
-- 0000: do nothing
-- 0001: sum/subtract
-- 0010: and
-- 0011: or
-- 0100: nor
-- 0101: and immediate (with constant)
-- 0110: or immediate (with constant)
-- 0111: shift left
-- 1000: shift right
-- 1001: add immediate
-- 1010: check if equal
-- 1011: check if not equal
-- 1100: slt operation
--
-- ALUOp mapping:
-- 00: R type -> i look the funct operation
-- 11: I type -> i have to set the sum in ALU
-- 10: I type branch instructions
--
BEGIN
--
	--i have funct defined only for R type
	with Funct select
		tmpALUControl_func <=
			"0001" when "100000", --0x20
			"0010" when "100100", --0x24
			"0011" when "100101", --0x25
			"0100" when "100111", --0x27
			"0101" when "001100", --0x0C
			"0110" when "001101", --0x0D
			"0111" when "000000", --0x00
			"1000" when "000010", --0x02
			"1100" when "101010", --0x2A slt
			"1111" when others;
			--all others type
	with ALUOp select --TODO sistemare qua
		tmpALUControl_op <=
			"0001" when "001", --0x2B Store and 0x23 Load: i have to sum the base and relative address
			"1010" when "010", --0x04 beq
			"1011" when "011", --0x05 bne
			"1111" when others;
			--The real output signal:
	with ALUOp select
		ALUCont_out <=
			tmpALUControl_func when "000",
			tmpALUControl_op   when others;
--
END ALUControl_1;