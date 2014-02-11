library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY Registers is
  port (
    RegIn1  :   in  std_logic_vector(4 downto 0);
    RegIn2  :   in  std_logic_vector(4 downto 0);
    RegWriteIn  :   in  std_logic_vector(4 downto 0);
    DataWriteIn :   in  std_logic_vector(31 downto 0);
    RegWrite:   in  std_logic;
    --OpImmediate: in std_logic;
    RegOut1 :   out  std_logic_vector(31 downto 0);
    RegOut2 :   out  std_logic_vector(31 downto 0));
END Registers;

ARCHITECTURE Registers_1 of Registers is
--
  --signal zeros : std_logic_vector(31 downto 0) := (others=>'0');
  type registers is array (0 to 31) of std_logic_vector(31 downto 0);
  --signal zeros : std_logic_vector(31 downto 0) := (others=>'0');
  --signal ones : std_logic_vector(31 downto 0) := (others=>'1');
  signal regs: registers := (
                3=>"00000000000000000000000000000010",
                4=>"00000000000000000000000011000000",
                others=> (others => '0'));
  signal extend: std_logic_vector(26 downto 0);
--
BEGIN --TODO scrivere in un registro?
--
  --regs(4)<="00000000000000000000000000000111";
  --
  --
  RegOut1 <= regs(to_integer(unsigned(RegIn1))); --std_logic_vector(to_unsigned(,32))--regs(conv_integer(RegIn1)));
  
  --extend <= zeros(26 downto 0) when RegIn2(4)='0' else
  --          ones(26 downto 0) when RegIn2(4)='1';
  --with OpImmediate select
  --  RegOut2 <=
          --
  --        regs(conv_integer(RegIn2)) when '0',
          --
          --extend & RegIn2 when others;
  RegOut2 <= regs(to_integer(unsigned(RegIn2)));
  
  regs(to_integer(unsigned(RegWriteIn))) <= DataWriteIn when RegWrite='1';
  --regs(conv_integer(RegWriteIn)) <= DataWriteIn when RegWrite='1';
--
END Registers_1;