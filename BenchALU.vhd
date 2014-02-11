library ieee;
use ieee.std_logic_1164.all;

ENTITY TestBenchAlu is
END TestBenchAlu;

ARCHITECTURE TestBench_ALU of TestBenchAlu is

	component ALU
		port (
			in1    : in  std_logic_vector(31 downto 0);
			in2    : in  std_logic_vector(31 downto 0);
			op     : in  std_logic_vector(3 downto 0);
			outALU : out std_logic_vector(31 downto 0));
	end component;

	signal CLK: std_ulogic;
	signal Rst: std_ulogic;
	signal indata_1:  std_logic_vector(31 downto 0);
	signal indata_2:  std_logic_vector(31 downto 0);
	signal operation: std_logic_vector(3 downto 0);
	signal output:    std_logic_vector(31 downto 0);

BEGIN
--
	--Unit Under Test:
	UUT:  ALU
	port map (indata_1, indata_2, operation, output);

	clock: process
		variable clktmp : std_ulogic:='0';
		variable reset  : std_ulogic:='1';
	begin
		clktmp:= NOT clktmp;
		CLK <= clktmp;
		if ( reset = '1' ) then
			Rst <= reset;
			reset := '0';
		else
			Rst <= '0';
		end if;
		wait for 50 ns;   
	end process;
--
	stimilus: process(CLK)
	begin
 		if ( CLK = '1' and CLK'event ) then
			indata_1  <= "00000000000000000000000000010110";
			indata_2  <= "00000000000000000000000000000010";
			operation <= "0010";
		end if;
	end process;
--
END TestBench_ALU;