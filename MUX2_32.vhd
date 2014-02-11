library IEEE;
use IEEE.std_logic_1164.all;

ENTITY MUX2_32 IS
	port (
		MUXin1  :  in  std_logic_vector(31 downto 0);
		MUXin2  :  in  std_logic_vector(31 downto 0);
		MUXout  :  out std_logic_vector(31 downto 0);
		sel     :  in  std_logic);
END MUX2_32;

ARCHITECTURE MUX2_32_1 of MUX2_32 is

BEGIN
 	MUXout <= MUXin1 when sel='0' else
	          MUXin2 when sel='1';
END MUX2_32_1;