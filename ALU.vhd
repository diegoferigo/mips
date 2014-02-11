library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

ENTITY ALU IS
	port (
		in1    : in  std_logic_vector(31 downto 0);
		in2    : in  std_logic_vector(31 downto 0);
		op     : in  std_logic_vector(3 downto 0);
		outALU : out  std_logic_vector(31 downto 0));
END ALU;

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

ARCHITECTURE ALU_1 of ALU is

	component FullAdder
		port (
			in1, in2 : in  std_logic_vector(31 downto 0);
			carryin  : in  std_logic_vector(0 downto 0);
			sum      : out std_logic_vector(31 downto 0);
			carryout : out std_ulogic);
	end component;

	component Shifter
		port (
			Sin  : in  std_logic_vector(31 downto 0);
			Sout : out std_logic_vector(31 downto 0);
			opS  : in  std_ulogic;                         -- 0: left, 1: right
			num  : in  std_logic_vector(4 downto 0));      -- numbers of bit shifted (max 31)
	end component;

	---- Signals between blocks
	--signal operation_shifter  : std_logic; -- to set right or left -- there's already the op in ALU
	--signal num_shifter  : std_logic; -- to pick up the shift amount
	signal op_shifter: std_logic;
	signal carryout:   std_logic;
	signal out_FA: std_logic_vector(31 downto 0);
	signal out_SH: std_logic_vector(31 downto 0);
	signal x:      std_logic_vector(31 downto 0) := (others=>'X'); -- all X signal vector
	--signal temp: std_logic_vector(31 downto 0) := (others => '0');

BEGIN
--
	op_shifter	<=
		'0' when op="0111" else
		'1' when op="1000" else
		'X';
--
	FA_ALU: FullAdder port map(in1 => in1, in2 => in2, carryin => "0", sum => out_FA, carryout=>carryout);
	SH_ALU: Shifter	  port map(Sin => in1, Sout => out_SH, opS => op_shifter, num => in2(4 downto 0)); -- only last 5 bits
--
	with op select
		outALU <= --TODO valore sbagliato uscita BOH
			-- sum:
			out_FA when "0001",
			-- and:
			in1 and in2 when "0010",
			-- or:
			in1 or in2 when "0011",
			-- nor:
			in1 nor in2 when "0100",
			-- and immediate:
			in1 and in2 when "0101",
			-- or immediate:
			in1 or in2 when "0110",
			-- shift left:
			out_SH  when "0111",
			-- shift right
			out_SH  when "1000",
			x       when others;
END ALU_1;