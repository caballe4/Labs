--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;
   signal intAddress: integer range 0 to 127;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    
     -- reset	
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

	-- write to ram
    if falling_edge(Clock) then
	-- Add code to write data to RAM

	-- Use to_integer(unsigned(Address)) to index the i_ram array
	-- place in ram	
	if WE = '1' and to_integer(unsigned(Address)) < 128 then 
		i_ram(to_integer(unsigned(Address))) <= DataIn;
	end if;
    end if;

	-- Rest of the RAM implementation
	if OE = '0' and to_integer(unsigned(Address)) < 128 then 
		intAddress <= to_integer(unsigned(Address));
		DataOut <= i_ram(intAddress);
	else
		DataOut <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	end if;

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
	signal regVal: std_logic_vector(7 downto 0);
	signal A0, A1, A2, A3, A4, A5, A6, A7, X0: std_logic_vector(31 downto 0);
begin

    -- Add your code here for the Register Bank implementation

	
	X0 <= (others => '0');

	-- create port maps
	ZERO: register32 port map (WriteData, '0', '1', '1', regVal(0), '0', '0', A0);
	ONE: register32 port map (WriteData, '0', '1', '1', regVal(1), '0', '0', A1);
	TWO: register32 port map (WriteData, '0', '1', '1', regVal(2), '0', '0', A2);
	THREE: register32 port map (WriteData, '0', '1', '1', regVal(3), '0', '0', A3);
	FOUR: register32 port map (WriteData, '0', '1', '1', regVal(4), '0', '0', A4);
	FIVE: register32 port map (WriteData, '0', '1', '1', regVal(5), '0', '0', A5);
	SIX: register32 port map (WriteData, '0', '1', '1', regVal(6), '0', '0', A6);
	SEVEN: register32 port map (WriteData, '0', '1', '1', regVal(7), '0', '0', A7);
	

	-- Read Data
	with ReadReg1 select ReadData1 <=
		A0 when "01010",
		A1 when "01011",
		A2 when "01100",
		A3 when "01101",
		A4 when "01110",
		A5 when "01111",
		A6 when "10000",
		A7 when "10001",
		X0 when others;
	

 	
	with ReadReg2 select ReadData2 <=
		A0 when "01010",
		A1 when "01011",
		A2 when "01100",
		A3 when "01101",
		A4 when "01110",
		A5 when "01111",
		A6 when "10000",
		A7 when "10001",
		X0 when others;

	with WriteCmd & WriteReg select regVal <= "00000001" when "101010",
						"00000010" when "101011",
						"00000100" when "101100",
						"00001000" when "101101",
						"00010000" when "101110",
						"00100000" when "101111",
						"01000000" when "110000",
						"10000000" when "110001",
						"00000000" when others;
	

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
