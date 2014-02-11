library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY Shifter is
  port (
    Sin : in  std_logic_vector(31 downto 0);
    Sout: out std_logic_vector(31 downto 0);
    opS  : in  std_ulogic;                          -- 0: left, 1: right
    num : in  std_logic_vector(4 downto 0));        -- numbers of bit shifted (max 31)
END Shifter;

ARCHITECTURE Shifter_1 of Shifter is
--
  --signal zeros : std_logic_vector(31 downto 0) := (others=>'0');
  signal tmp: unsigned(31 downto 0);
--
BEGIN
--
--Sout <= Sin(31-conv_integer(num) downto 0) & zeros(conv_integer(num)-1 downto 0) WHEN opS='0' ELSE
--        zeros(conv_integer(num)-1 downto 0) & Sin(31 downto conv_integer(num)) WHEN opS='1';
  tmp <=  to_unsigned(to_integer(signed(Sin)),tmp'length) sll to_integer(signed(num)) when opS='0' else
          to_unsigned(to_integer(signed(Sin)),tmp'length) srl to_integer(signed(num)) when opS='1';
          --Sin srl num when opS='1';
  Sout <= std_logic_vector(to_signed(to_integer(tmp),Sout'length));
--
END Shifter_1;