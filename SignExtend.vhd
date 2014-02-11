library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;

ENTITY SignExtend IS
  port (
        SignExIn  :  in  std_logic_vector(15 downto 0);
        SignExOut :  out std_logic_vector(31 downto 0));
END SignExtend;

ARCHITECTURE SignExtend_1 of SignExtend is
--
  signal ones   : std_logic_vector(15 downto 0) := (others=>'1');
  signal zeros  : std_logic_vector(15 downto 0) := (others=>'0');
--
BEGIN
  SignExOut <=  ones  & SignExIn  when SignExIn(15)='1' else
                zeros & SignExIn  when SignExIn(15)='0' ;
END SignExtend_1;