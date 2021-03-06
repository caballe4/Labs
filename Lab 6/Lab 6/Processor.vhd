--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

-------------DataOutSig RAM Signal 
	signal DataOut: std_logic_vector(31 downto 0);
	signal PCBranch: std_logic_vector(31 downto 0);
	signal ReadData: std_logic_vector(31 downto 0);

-------------Program Counter Signals
	signal PCOutput: std_logic_vector(31 downto 0);
	signal PC_4: std_logic_vector(31 downto 0);
	signal PC_Next: std_logic_vector(31 downto 0);

------------Control Signals
	signal funct7: std_logic_vector (6 downto 0);	
	signal funct3: std_logic_vector(2 downto 0);
	signal opcode: std_logic_vector(6 downto 0);
	signal Branch: std_logic_vector(1 downto 0);
	signal MemReg: std_logic;
	signal MemRead: std_logic;
	signal ALUCtrl: std_logic_vector (4 downto 0);
	signal MemWrite: std_logic;
	signal ALUSrc: std_logic;
	signal RegWrite: std_logic;
	signal ImmGen: std_logic_vector (1 downto 0);

-------------ALU Signals
	signal DataIn1: std_logic_vector(31 downto 0);
	signal DataIn2: std_logic_vector(31 downto 0);
	signal ALUCtrlSig: std_logic_vector(4 downto 0);
	signal Zero: std_logic;
	signal ALUResult: std_logic_vector(31 downto 0);
	signal BranchResult: std_logic_vector(2 downto 0);

-------------Registers Signals
	signal ReadReg1: std_logic_vector(4 downto 0);
	signal ReadReg2: std_logic_vector(4 downto 0);
	signal WriteReg: std_logic_vector(4 downto 0);
	signal WriteData: std_logic_vector(31 downto 0);
	signal WriteCmd: std_logic;
	signal ReadData1: std_logic_vector(31 downto 0);
	signal ReadData2: std_logic_vector(31 downto 0);

-------------RAM Signals
	signal OE: std_logic;
	signal WE: std_logic;
	signal Address: std_logic_vector(29 downto 0);
	signal DataIn: std_logic_vector(31 downto 0);
	signal DataOutSig: std_logic_vector(31 downto 0);

------------BusMux2to1 Signals
	signal selector: std_logic;
	signal In0: std_logic_vector(31 downto 0);
	signal In1: std_logic_vector(31 downto 0);
	signal Result: std_logic_vector(31 downto 0);

-------------Adder_Subtractor Signals
	signal datain_a: std_logic_vector(31 downto 0);
	signal datain_b: std_logic_vector(31 downto 0);
	signal add_sub: std_logic;
	-- signal carry1, carry2: std_logic; 

------------Immediat Generator
	signal ImmGenResult: std_logic_vector(31 downto 0);
	signal done: std_logic_vector(29 downto 0);
	
begin
	

---------- Data Path from Left to Right
	PCCounter: ProgramCounter port map(reset, clock, PC_Next, PCOutput); 
	PC4: adder_subtracter port map(PCOutput, X"00000004", '0', PC_4);
	PC_Branch: adder_subtracter port map(PCOutput, ImmGenResult, '0', PCBranch);

	DataOutSigRAM: InstructionRAM port map(reset, clock, PCOutput(31 downto 2), DataOutSig);

----------Immediat Generator
	with ImmGen & DataOutSig(31) select
	ImmGenResult <= "111111111111111111111" & DataOutSig(30 downto 20) when "001",  --I_type
                        "000000000000000000000" & DataOutSig(30 downto 20) when "000",  --I_type
		        "111111111111111111111" & DataOutSig(30 downto 25) & DataOutSig(11 downto 7) when "011",  --S_type
                        "000000000000000000000" & DataOutSig(30 downto 25) & DataOutSig(11 downto 7) when "010",  --S_type
		        "11111111111111111111" & DataOutSig(7) & DataOutSig(30 downto 25) & DataOutSig(11 downto 8) & '0' when "101", --B_type
                        "00000000000000000000" & DataOutSig(7) & DataOutSig(30 downto 25) & DataOutSig(11 downto 8) & '0' when "100", --B_type
			                   "1" & DataOutSig(30 downto 12) & "000000000000" when "111", --U_type
                                           "0" & DataOutSig(30 downto 12) & "000000000000" when "110", --U_type
            		"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
	
---------- Branch select
	BranchResult <= Zero & Branch;
		with BranchResult select selector <=
			'0' when "000",
			'0' when "100",
			'1' when "101",
			'1' when "010",
			'0' when "001",
			'0' when "110",
			'0' when others; 
	BranchMux: BusMux2to1 port map (selector, PC_4, PCBranch, PC_Next);

---------- Register
	RegisterBank: Registers port map(DataOutSig(19 downto 15), DataOutSig(24 downto 20), DataOutSig(11 downto 7), WriteData, RegWrite, ReadData1, ReadData2);

---------- function identifiers
	opcode <= DataOutSig(6 downto 0);
	funct3 <= DataOutSig(14 downto 12);
	funct7 <= DataOutSig(31 downto 25);

	ProcessCtrl: Control port map (clock, opcode, funct3, funct7, Branch, MemRead, MemReg, ALUCtrlSig, MemWrite, ALUSrc, RegWrite, ImmGen);

----------Bus To Mux
	DataToMux: BusMux2to1 port map (ALUSrc, ReadData2, ImmGenResult, Result);

	ALUComputation: ALU port map(ReadData1, Result, ALUCtrlSig, Zero, ALUResult); 

----------Data Memory

	done <= "0000"&ALUResult(27 downto 2);
	Memory: RAM port map(reset, clock, MemRead, MemWrite, done, ReadData2, ReadData);

	MemoryRegistorMux: BusMux2to1 port map(MemReg, ALUResult, ReadData, WriteData);  
	 
end holistic;

