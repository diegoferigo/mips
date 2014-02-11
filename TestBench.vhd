library ieee;
use ieee.std_logic_1164.all;

ENTITY TestBench is
END TestBench;

ARCHITECTURE TestBench_MIPS of TestBench is

	component MIPS
		port (
			CLK     : in  std_logic;
			Rst     : in  std_logic;
			outMIPS : out std_logic_vector(31 downto 0));
	end component;

	signal CLK: std_logic;
	signal Rst: std_logic;
	signal outMIPS: std_logic_vector(31 downto 0);

BEGIN
--
	--Unit Under Test:
	UUT:  MIPS
		port map (CLK, Rst, outMIPS);

	clock: process
		variable clktmp : std_logic:='1';
		variable reset  : std_logic:='1';
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
END TestBench_MIPS;