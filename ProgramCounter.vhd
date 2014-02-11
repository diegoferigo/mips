library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY ProgramCounter IS
  port (
    inPC  : in std_logic_vector(31 downto 0);
    outPC : out std_logic_vector(31 downto 0);
    CLK   : in std_logic;
    Rst : in std_logic);
END ProgramCounter;

ARCHITECTURE ProgramCounter_1 of ProgramCounter is

BEGIN
  reg:process(CLK)
   begin
     if (CLK'event and CLK='1') then
       if (Rst = '1') then
         outPC <= std_logic_vector(to_signed(0,32));--conv_std_logic_vector(0, 32);
        else
          outPC <= inPC;
      end if;
     end if;
  end process;
END ProgramCounter_1;
