--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	
-- use bitcomponent ports to store the data

	D0 : bitstorage port map (datain(0), enout, writein, dataout(0));
	D1 : bitstorage port map (datain(1), enout, writein, dataout(1));
	D2 : bitstorage port map (datain(2), enout, writein, dataout(2));
	D3 : bitstorage port map (datain(3), enout, writein, dataout(3));
	D4 : bitstorage port map (datain(4), enout, writein, dataout(4));
	D5 : bitstorage port map (datain(5), enout, writein, dataout(5));
	D6 : bitstorage port map (datain(6), enout, writein, dataout(6));
	D7 : bitstorage port map (datain(7), enout, writein, dataout(7));

end architecture memmy;
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector (7 downto 0);
			writein: in std_logic;
			enout: in std_logic;
			dataout: out std_logic_vector (7 downto 0));
	end component;
	signal enout1: std_logic;
	signal enout2: std_logic;
	signal writein1: std_logic;
	signal writein2: std_logic;
begin
	-- insert code here.

	enout1 <= enout32 and enout16 and enout8;
	writein1 <= writein32 or writein16 or writein8;
	
	enout2 <= enout32 and enout16;
	writein2 <= writein32 or writein16;
		
	D1 : register8 port map (datain(7 downto 0), enout1, writein1, dataout(7 downto 0));
	D2 : register8 port map (datain(15 downto 8), enout2, writein2, dataout(15 downto 8));
	D3 : register8 port map (datain(23 downto 16), enout32, writein32, dataout(23 downto 16));
	D4 : register8 port map (datain(31 downto 24), enout32, writein32, dataout(31 downto 24));
end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder is
   	 port (a : in std_logic;
         	 b : in std_logic;
         	 cin : in std_logic;
         	 sum : out std_logic;
         	 carry : out std_logic
         	);
	end component;

	signal data: std_logic_vector(31 downto 0);	
	signal cout: std_logic_vector(32 downto 0);

begin
	-- insert code here.

	with add_sub select
		data <= datain_b when '0',	--addition
		not(datain_b) when others;	--subtraction

	cout(0) <= add_sub;
	co <= cout(32);

	calculate: for i in 0 to 31 generate
	total: fulladder port map(datain_a(i), data(i), cout(i), dataout(i), cout(i+1));
	end generate; 	
end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	-- insert code here.

	with dir & shamt select
		dataout <= datain(30 downto 0) & '0' when "000001",
				datain(29 downto 0) & "00" when "000010",
				datain(28 downto 0) & "000" when "000011",
				'0' & datain(31 downto 1) when "100001",
				"00" & datain(31 downto 2) when "100010",
				"000" & datain(31 downto 3) when "100011",
				datain(31 downto 0) when others;
end architecture shifter;



