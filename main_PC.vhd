
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_Processor is
    Port ( CLK : in  STD_LOGIC;
				reset: in STD_LOGIC;
				ALU_RESULT: out STD_LOGIC_VECTOR(31 downto 0));
end main_Processor;

architecture Behavioral of main_Processor is

COMPONENT PC is
    Port ( PC_IN : in  STD_LOGIC_VECTOR (31 downto 0);
           reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           PC_OUT : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT nPC is
    Port ( PC_IN : in  STD_LOGIC_VECTOR (31 downto 0);
           reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           nPC_OUT : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT adder1 is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           suma : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT adderPC30 is
	Port ( disp30 : in  STD_LOGIC_VECTOR (31 downto 0);
          PC_actual : in  STD_LOGIC_VECTOR (31 downto 0);
          suma : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT adderPC22 is
	Port ( PC_actual : in  STD_LOGIC_VECTOR (31 downto 0);
          disp22 : in  STD_LOGIC_VECTOR (31 downto 0);
          suma : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT IM is
    Port ( address : in  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           instruction : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT UC is
    Port ( op : in  STD_LOGIC_VECTOR (1 downto 0);
           op3 : in  STD_LOGIC_VECTOR (5 downto 0);
			  op2 : in STD_LOGIC_VECTOR (2 downto 0);
			  icc : in STD_LOGIC_VECTOR (3 downto 0);
			  cond: in STD_LOGIC_VECTOR (3 downto 0);
           aluOP : out  STD_LOGIC_VECTOR (5 downto 0);
			  enableDM: out STD_LOGIC;
			  wrenDM: out STD_LOGIC;
			  selectorDM: out STD_LOGIC_VECTOR(1 downto 0);
			  PCSource: out STD_LOGIC_VECTOR(1 downto 0);
			  RFdest: out STD_LOGIC;
			  write_enable : out STD_LOGIC);
end COMPONENT;

COMPONENT SEU is
    Port ( simm13 : in  STD_LOGIC_VECTOR (12 downto 0);
           simm32 : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT immMUX is
    Port ( cRs2 : in  STD_LOGIC_VECTOR (31 downto 0);
           imm32 : in  STD_LOGIC_VECTOR (31 downto 0);
           selector_bit : in  STD_LOGIC;
           Operando_ALU : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT ALU is
    Port ( CRs1 : in  STD_LOGIC_VECTOR (31 downto 0);
           CRs2 : in  STD_LOGIC_VECTOR (31 downto 0);
			  ALU_OP : in STD_LOGIC_VECTOR (5 downto 0);
           ALU_Result : out  STD_LOGIC_VECTOR (31 downto 0);
			  Carry: in STD_LOGIC);
end COMPONENT;

COMPONENT RF is
    Port ( rs1 : in  STD_LOGIC_VECTOR (5 downto 0);--Register Source 1
           rs2 : in  STD_LOGIC_VECTOR (5 downto 0);--Register Source 2
           rd : in  STD_LOGIC_VECTOR (5 downto 0);--Register Destination
			  write_enabler: in STD_LOGIC;--Enabler to write
           dwr : in  STD_LOGIC_VECTOR (31 downto 0);--Data to write
           CRs1 : out  STD_LOGIC_VECTOR (31 downto 0);-- Content Register Source 1
           CRs2 : out  STD_LOGIC_VECTOR (31 downto 0);-- Content Register Source 2
			  CRd : out STD_LOGIC_VECTOR (31 downto 0);-- Content Register Destination
			  clk: in STD_LOGIC
			  );
end COMPONENT;

COMPONENT PSR is
    Port ( clk : in  STD_LOGIC;
			  reset: in STD_LOGIC;
			  nCWP : in  STD_LOGIC;
           NZVC : in  STD_LOGIC_VECTOR (3 downto 0);
           CWP : out  STD_LOGIC;
			  icc: out STD_LOGIC_VECTOR (3 downto 0);
           carry : out  STD_LOGIC);
end COMPONENT;

COMPONENT PSR_modifier is
    Port ( bRs1 : in  STD_LOGIC;--Bit mas significativo del registro 1
           bRs2 : in  STD_LOGIC;--Bit menos significativo del registro 2
           OP3: in  STD_LOGIC_VECTOR (5 downto 0);
			  OP: in STD_LOGIC_VECTOR (1 downto 0);
           ALU_result : in  STD_LOGIC_VECTOR (31 downto 0);
           NZVC : out  STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

COMPONENT WM is
    Port ( Rs1 : in  STD_LOGIC_VECTOR (4 downto 0);--Register Source 1
           Rs2 : in  STD_LOGIC_VECTOR (4 downto 0);--Register Source 2
           Rd : in  STD_LOGIC_VECTOR (4 downto 0);--Register Destination
           OP : in  STD_LOGIC_VECTOR (1 downto 0);
           OP3 : in  STD_LOGIC_VECTOR (5 downto 0);
           CWP : in  STD_LOGIC;--Current Window Pointer
			  RO7 : out STD_LOGIC_VECTOR (5 downto 0);
           nCWP : out  STD_LOGIC:='0';--New Current Windows Pointer
           nRs1 : out  STD_LOGIC_VECTOR (5 downto 0);--New Register Source 1
           nRs2 : out  STD_LOGIC_VECTOR (5 downto 0);--New Register Source 2
           nRd : out  STD_LOGIC_VECTOR (5 downto 0));--New Register Destination
end COMPONENT;

COMPONENT DM is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  enableMem: in STD_LOGIC;
           wrenmem : in  STD_LOGIC;
           addressDM: in  STD_LOGIC_VECTOR (31 downto 0);
           CRd : in  STD_LOGIC_VECTOR (31 downto 0);
           data : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT dwrMUX is
    Port ( selector: in STD_LOGIC_VECTOR(1 downto 0);
			  data : in  STD_LOGIC_VECTOR (31 downto 0);
           alu_result : in  STD_LOGIC_VECTOR (31 downto 0);
			  PC: in STD_LOGIC_VECTOR(31 downto 0);
           data_to_write : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT SEU22 is
    Port ( SEU22 : in  STD_LOGIC_VECTOR (21 downto 0);
           SEU32 : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT SEU30 is
    Port ( SEU30 : in  STD_LOGIC_VECTOR (29 downto 0);
           SEU32 : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT muxPCSource is
	Port (  PCDisp30 : in  STD_LOGIC_VECTOR (31 downto 0);
           PCDisp22 : in  STD_LOGIC_VECTOR (31 downto 0);
           PC1 : in  STD_LOGIC_VECTOR (31 downto 0);
           PCAddress : in  STD_LOGIC_VECTOR (31 downto 0);
           PCSource : in  STD_LOGIC_VECTOR (1 downto 0);
           PCAddressOut : out  STD_LOGIC_VECTOR (31 downto 0));
end COMPONENT;

COMPONENT muxRFRD is
    Port ( wmnRD : in  STD_LOGIC_VECTOR (5 downto 0);--Windows Manager new RD
           rO7 : in  STD_LOGIC_VECTOR (5 downto 0);--O7 register
           RFdest_sel : in  STD_LOGIC;--Selector rf destination
           nRd : out  STD_LOGIC_VECTOR (5 downto 0));-- new RD
end COMPONENT;
--Program Counter,Instruction Memory
signal add1: STD_LOGIC_VECTOR(31 downto 0):= "00000000000000000000000000000001"; --Los que se le suma al address
signal address_nPC: STD_LOGIC_VECTOR(31 downto 0);
signal address_PC: STD_LOGIC_VECTOR(31 downto 0);
signal address_IM: STD_LOGIC_VECTOR(31 downto 0);
signal instruction_in: STD_LOGIC_VECTOR(31 downto 0);
signal pc1_signal: STD_LOGIC_VECTOR(31 downto 0);
--Windows Manager,PSR,PSR Modifier
signal cwp_signal: STD_LOGIC;
signal ncwp_signal: STD_LOGIC;
signal nzvc_signal: STD_LOGIC_VECTOR(3 downto 0);
signal carry_signal: STD_LOGIC;
signal data_to_write: STD_LOGIC_VECTOR(31 downto 0);
signal icc_signal: STD_LOGIC_VECTOR(3 downto 0);
signal wmnrd_signal: STD_LOGIC_VECTOR(5 downto 0);
signal RO7_signal: STD_LOGIC_VECTOR(5 downto 0);
--Register File,SEU13,ALU
signal nrs1_signal: STD_LOGIC_VECTOR(5 downto 0);
signal nrs2_signal: STD_LOGIC_VECTOR(5 downto 0);
signal nrd_signal: STD_LOGIC_VECTOR(5 downto 0);
signal CR_in_mux: STD_LOGIC_VECTOR(31 downto 0);
signal imm_in_mux: STD_LOGIC_VECTOR(31 downto 0);
signal crd_signal: STD_LOGIC_VECTOR(31 downto 0);
signal writeenable: STD_LOGIC;
signal alu_operando1: STD_LOGIC_VECTOR(31 downto 0);
signal alu_operando2: STD_LOGIC_VECTOR(31 downto 0);
signal alu_signal: STD_LOGIC_VECTOR(31 downto 0);
--Unidad Control,Data Memory
signal aluop: STD_LOGIC_VECTOR(5 downto 0);
signal enM_signal: STD_LOGIC;--Habilitar DM
signal wrM_signal: STD_LOGIC;--Escribir en DM
signal data_signal: STD_LOGIC_VECTOR(31 downto 0);
signal selectorDM_signal: STD_LOGIC_VECTOR(1 downto 0);
signal pcsource_signal: STD_LOGIC_VECTOR(1 downto 0);
signal rfdest_signal: STD_LOGIC;
--SEU22, sum22,sum30
signal opsumdisp30_signal: STD_LOGIC_VECTOR(31 downto 0);
signal opsumdisp22_signal: STD_LOGIC_VECTOR(31 downto 0);
signal pcdisp22_signal: STD_LOGIC_VECTOR(31 downto 0);
signal pcdisp30_signal: STD_LOGIC_VECTOR(31 downto 0);

begin
	nextProgramCounter: nPC PORT MAP(address_nPC,reset,CLK,address_PC);
	adder: adder1 PORT MAP(add1, address_PC, pc1_signal);
	ProgramCounter: PC PORT MAP(address_PC,reset,CLK,address_IM);
	InstructionMemory: IM PORT MAP(address_IM,CLK,reset,instruction_in);
	
	UnidadControl: UC PORT MAP(	instruction_in(31 downto 30),
											instruction_in(24 downto 19),
											instruction_in(24 downto 22),
											icc_signal,
											instruction_in(28 downto 25),
											aluop,
											enM_signal,
											wrM_signal,
											selectorDM_signal,
											pcsource_signal,
											rfdest_signal,
											writeenable);
											
	RegisterFile: RF PORT MAP(	nrs1_signal,
										nrs2_signal,
										nrd_signal,
										writeenable,
										data_to_write,
										alu_operando1,
										CR_in_mux,
										crd_signal,
										CLK
										);
										
	SignExtensionUnit: SEU PORT MAP(instruction_in(12 downto 0),imm_in_mux);
	immediateMUX: immMUX PORT MAP(CR_in_mux,imm_in_mux,instruction_in(13),alu_operando2);
	ArithmeticLogicUnit: ALU PORT MAP(	alu_operando1,
													alu_operando2,
													aluop,
													alu_signal,
													carry_signal);
	
	PSRModifier: PSR_modifier PORT MAP(	alu_operando1(31),--brs1
														alu_operando2(31),--brs2
														instruction_in(24 downto 19),--op3
														instruction_in(31 downto 30),--op
														alu_signal,--alu_result
														nzvc_signal);--nzvc
	
	ProcessorStateRegister: PSR PORT MAP(	CLK,--CLK
														reset,--Reset
														ncwp_signal,--nCWP
														nzvc_signal,--NZVC
														cwp_signal,--CWP
														icc_signal,
														carry_signal);--CARRY
	
	WindowsManager: WM PORT MAP(	instruction_in(18 downto 14),--rs1
											instruction_in(4 downto 0),--rs2
											instruction_in(29 downto 25),--rd
											instruction_in(31 downto 30),--op
											instruction_in(24 downto 19),--op3
											cwp_signal,--cwp
											RO7_signal,--registro O7
											ncwp_signal,--ncwp
											nrs1_signal,--nrs1
											nrs2_signal,--nrs2
											wmnrd_signal);--nrd
	
	DataMemory: DM PORT MAP(	clk,
										reset,
										enM_signal,
										wrM_signal,
										alu_signal,
										crd_signal,
										data_signal);
	
	DataToWriteMUX: dwrMUX PORT MAP(	selectorDM_signal,
												data_signal,
												alu_signal,
												address_IM,
												data_to_write);
	
	muxProgramCounterSource: muxPCSource PORT MAP(	pcdisp30_signal,
																	pcdisp22_signal,
																	pc1_signal,
																	alu_signal,
																	pcsource_signal,
																	address_nPC);
	
	muxRegisterFileNewRD: muxRFRD PORT MAP(	wmnrd_signal,
															RO7_signal,
															rfdest_signal,
															nrd_signal);
															
	SignExtensionUnit22: SEU22 PORT MAP(	instruction_in(21 downto 0),
														opsumdisp22_signal);
	
	SignExtensionUnit30: SEU30 PORT MAP(	instruction_in(29 downto 0),
														opsumdisp30_signal);
	
	adderdisp30: adderPC30 PORT MAP(	opsumdisp30_signal,
												address_IM,
												pcdisp30_signal);
	
	adderdisp22: adderPC22 PORT MAP(	address_IM,
												opsumdisp22_signal,
												pcdisp22_signal);
	
	
	ALU_RESULT<=data_to_write;
end Behavioral;

