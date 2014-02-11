library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

ENTITY Memory IS
  port (  
    inRAM     : in std_logic_vector(31 downto 0); -- the address from alu
    WriteData : in std_logic_vector(31 downto 0); -- the data from 2nd register
    MemWrite  : in std_logic;                     -- the write signal from the OutputControl
    MemRead   : in std_logic;                     -- the read signal from the OutputControl
    outRAM    : out std_logic_vector(31 downto 0);-- the output if is a read operation
    reset     : in std_logic);  
END Memory;

ARCHITECTURE Memory_1 of Memory is

type ram_type is array (natural range <>) of std_logic_vector(31 downto 0);
--
signal ram: ram_type(0 to 1023) := ( others=> (others => '0'));
signal Address: integer;           
signal FullWord,tmp: std_logic_vector(31 downto 0); -- to merge the 4 memory bytes
signal inRam_short: std_logic_vector(6 downto 0);

BEGIN
--
  inRam_short <= inRAM(6 downto 0); --magari va in overflow per troppi bit
  
  with reset select
    Address <=
      to_integer(unsigned(inRAM_short)) when '0',
      0 when '1',
      0 when others;
  
  --ram <= (others =>(others=>'0')) when reset='1';
   
  --ram(Address)    <= WriteData(31 downto 24) after 5 ns when (MemWrite='1' and reset='0');
  --ram(Address+1)  <= WriteData(23 downto 16) after 5 ns when (MemWrite='1' and reset='0');
  --ram(Address+2)  <= WriteData(15 downto 8) after 5 ns when (MemWrite='1' and reset='0');
  --ram(Address+3)  <= WriteData(7 downto 0) after 5 ns  when (MemWrite='1' and reset='0');
  
  ram(Address)    <= WriteData when (MemWrite='1' and reset='0');
--  ram(Address+1)  <= WriteData(23 downto 16) when (MemWrite='1' and reset='0');
--  ram(Address+2)  <= WriteData(15 downto 8) when (MemWrite='1' and reset='0');
--  ram(Address+3)  <= WriteData(7 downto 0) when (MemWrite='1' and reset='0');
  
--  FullWord <= ram(Address) & ram(Address+1) & ram(Address+2) & ram(Address+3) when reset='0';
  FullWord <= ram(Address) when reset='0';
  -- TODO FullWord è corretto ma non so perchè outRAM è sempre a U
  outRAM <= FullWord when MemRead='1';
  --with MemRead select
    --outRAM <=
      --ram(Address) when '1',
      --(others => '1') when others;
END Memory_1;