--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');


	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);	

	tb : PROCESS
	BEGIN
		
		
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		
		datain_a <= X"10000001";	-- DataIn1 in hex
		datain_b <= X"00110001";	-- DataIn2 in hex

		-- Start testing the ALU
		
		-- test the adder
		control <= "00000";
		zeroOut <= '0';
		
		-- test the andi
		wait for 100 ns;
		control  <= "00011";	-- result: 0x00000001  and zeroOut = 0	
		
		wait for 100 ns; 	
		-- test the ori 
		control <= "00101";	-- result: 0x10110001

		-- test the shift left on dataIn1;					
		wait for 100 ns;
		control <= "00111";	-- result: 0x20000002

		-- test the shift right on DataIn1
		wait for 100 ns;
		control <= "01001";	-- result: 0x08000000

		-- test the data2 hardline
		wait for 100 ns;
		control <= "10000";	-- result: 0x00110001
					
		wait; -- will wait forever
	END PROCESS;
END;