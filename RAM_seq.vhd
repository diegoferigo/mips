library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Memory_seq IS
	port (  
		inRAM     : in  std_logic_vector(31 downto 0); -- the address from alu
		WriteData : in  std_logic_vector(31 downto 0); -- the data from 2nd register
		MemWrite  : in  std_logic;                     -- the write signal from the OutputControl
		MemRead   : in  std_logic;                     -- the read signal from the OutputControl
		outRAM    : out std_logic_vector(31 downto 0);-- the output if is a read operation
		CLK       : in  std_logic);  
END Memory_seq;

ARCHITECTURE Memory_seq_1 of Memory_seq is

	type ram_type is array (natural range <>) of std_logic_vector(7 downto 0);
	signal ram: ram_type(0 to 1023);
	signal FullWord,tmp: std_logic_vector(31 downto 0); -- to merge the 4 memory bytes
	-- dont' use Address assignal instead variable otherwise the Address*4 is always 0!
	--signal addr: integer := 10;
	signal Address: integer := 0;-- := -5;
	--signal addruns: unsigned(31 downto 0) := (others => '0');

BEGIN

	ramproc: process(CLK)--,MemWrite,MemRead,WriteData)
		--
		variable Startup: boolean := true;
    	--variable Address: integer := -5;
    	--
	begin
		--tmp <= inRAM after 1 ns;
    	--wait until CLK='1';
		if (Startup = true) then
			ram <= (others =>(others=>'0'));
			Startup := false;
			Address <= -1;
			--
        	--Address := to_integer(unsigned(inRAM));
        	--addr <= Address;
		end if;
		--if (CLK'event and CLK='1') then
		if rising_edge(CLK) then
			tmp <= inRAM;
			Address <= to_integer(unsigned(inRAM));-- after 5 ns;
			--Address <= 0;
			--addruns <= unsigned(inRAM) after 10 ns;
			--Address <= to_integer(addruns) after 10 ns;
			--addr <= Address after 10 ns;
			-- Write
			--if ( MemWrite = '1') then
				--  ram(Address*4)    <= WriteData(31 downto 24);-- after 1 ns;
				--  ram(Address*4+1)  <= WriteData(23 downto 16);-- after 1 ns;
				--  ram(Address*4+2)  <= WriteData(15 downto 8);-- after 1 ns;
				--  ram(Address*4+3)  <= WriteData(7 downto 0);
			--end if;
				-- Read
			--else
			--
			--Address := to_integer(unsigned(inRAM));
			if ( MemWrite = '1') then
				--Address := to_integer(unsigned(inRAM));
				--addr <= Address; --only to check
				ram(Address*4)    <= WriteData(31 downto 24);-- after 10 ns;
				ram(Address*4+1)  <= WriteData(23 downto 16);-- after 10 ns;
				ram(Address*4+2)  <= WriteData(15 downto 8);-- after 10 ns;
				ram(Address*4+3)  <= WriteData(7 downto 0);-- after 10 ns;
			end if;
			--
			if ( MemRead = '1' ) then --TODO sistemare la read che non entra
				--addr <= Address;--Address; --only to check
				FullWord <= ram(Address*4) & ram(Address*4+1) & ram(Address*4+2) & ram(Address*4+3);
				outRAM <= ram(Address*4) & ram(Address*4+1) & ram(Address*4+2) & ram(Address*4+3);
				outRAM <= FullWord;
			else
				outRAM <= (others => '-');
			end if;
			--
		end if;
		--end if;
		--wait for 10 ns;
		--wait for 100 ns;
	end process;

	--Address <= to_integer(unsigned(inRAM));
	--ram(Address*4)    <= WriteData(31 downto 24)  when MemWrite='1';
	--ram(Address*4+1)  <= WriteData(23 downto 16)  when MemWrite='1';
	--ram(Address*4+2)  <= WriteData(15 downto 8)   when MemWrite='1';
	--ram(Address*4+3)  <= WriteData(7 downto 0)    when MemWrite='1';

	--FullWord <= ram(Address*4) & ram(Address*4+1) & ram(Address*4+2) & ram(Address*4+3) when MemRead='1';

	--ram(conv_integer(tmp)*4)    <= WriteData(31 downto 24)  when MemWrite='1';
	--ram(conv_integer(tmp)*4+1)  <= WriteData(23 downto 16)  when MemWrite='1';
	--ram(conv_integer(tmp)*4+2)  <= WriteData(15 downto 8)   when MemWrite='1';
	--ram(conv_integer(tmp)*4+3)  <= WriteData(7 downto 0)    when MemWrite='1';

	--FullWord <=   ram(conv_integer(inRAM)*4) & ram(conv_integer(inRAM)*4+1)
	--              & ram(conv_integer(inRAM)*4 + 2) & ram(conv_integer(inRAM)*4 + 3) when MemRead='1';

	--ramWrite: process (inRam, WriteData, MemWrite)
	--variable tmp: integer;
	--begin
	--  tmp := conv_integer(inRam) * 4;
	--  if (MemWrite = '1') then
	--    ram(tmp)    <= WriteData(31 downto 24);
	--    ram(tmp+1)  <= WriteData(23 downto 16);
	--    ram(tmp+2)  <= WriteData(15 downto 8);
	--    ram(tmp+3)  <= WriteData(7 downto 0);
	--  end if;
	--end process;

	--outRAM <= FullWord when MemRead='1' else (others => '-');
	--
END Memory_seq_1;