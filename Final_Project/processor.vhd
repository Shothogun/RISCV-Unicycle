library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv_pkg.all;
use work.reg_pkg.all;

entity processor is
	port(
	masterClock : in std_logic
	);
end processor;

architecture processor_arch of processor is

-- Signals PC
signal out_pc : std_logic_vector(31 downto 0) := X"00000000";
signal in_pc : std_logic_vector(31 downto 0) := X"00000000";
signal old_future_pc : std_logic_vector(31 downto 0) := X"00000000";
signal reset_pc : std_logic := '1';

component PC is	
	port(
		P : in std_logic_vector(31 downto 0) := X"00000000";
		reset, clk: in std_logic;
		Q: out std_logic_vector(31 downto 0) := X"00000000");
end component;

-- Signals XREGS
signal ro2_xregs : std_logic_vector(31 downto 0) := X"00000000";
signal ro1_xregs : std_logic_vector(31 downto 0) := X"00000000";

component xregs is
	port (
		clk, wren, rst : in std_logic;
		rs1, rs2, rd : in std_logic_vector(4 downto 0);
		data : in std_logic_vector(31 downto 0);
		ro1, ro2 : out std_logic_vector(31 downto 0));
end component;

-- Signals MUX WHERE PC
signal resultMuxWherePC : std_logic_vector(31 downto 0) := X"00000000";

-- Signals MUX MEM
signal WriteDataRegisters_mux_mem : std_logic_vector(31 downto 0) := X"00000000";

-- Signals MUX FINAL
signal WriteDataRegisters_final_mux : std_logic_vector(31 downto 0) := X"00000000";

component MUX is	
	port(
		A,B : in std_logic_vector(31 downto 0);
		S: in std_logic;
		Z: out std_logic_vector(31 downto 0));
end component;

-- Signals MUX BRANCHS
signal MuxBranchResult : std_logic;

component MUX_Branchs is	
	port(
		A,B,C,D : in std_logic;
		S: in std_logic_vector(2 downto 0);
		Z: out std_logic);
end component;

-- Signals Control
signal MemRead_control, MemToReg_control, ALUSrc_control, MemWrite_control : std_logic; 
signal Branch_control : std_logic := '0';
signal isJAL_control : std_logic := '0';
signal isJALR_control : std_logic := '0';
signal RegWrite_control : std_logic := '0';
signal ALUop_control : std_logic_vector(1 downto 0);

component control is	
	port(
		opcode: in std_logic_vector(6 downto 0);
		Branch: out std_logic;
		isJAL : out std_logic;
		isJALR : out std_logic;
		MemRead: out std_logic;
		MemToReg: out std_logic;
		ALUop: out std_logic_vector(1 downto 0);
		MemWrite: out std_logic;
		ALUSrc: out std_logic;
		RegWrite: out std_logic);
end component;

-- Signals Adder PC
signal resultPC_adder : std_logic_vector(31 downto 0) := X"00000000";

-- Signals Adder Jumps
signal resultPCJump_adder : std_logic_vector(31 downto 0) := X"00000000";

component Adder is	
	port(
		A,B: in std_logic_vector(31 downto 0);
		Cin: in	 std_logic_vector(0 downto 0);
		C: out std_logic_vector(31 downto 0);
		Cout: out  std_logic_vector(0 downto 0));
end component;

-- Signals for ULA
signal B_ula : std_logic_vector(31 downto 0) := X"00000000";
signal resultUla: std_logic_vector(31 downto 0) := X"00000000";
signal zero_ula : std_logic := '0';
signal inverted_zero_ula : std_logic := (not zero_ula);

component ula is
	generic (WSIZE : natural := 32);
	port (
		opcode : in ULA_OP;
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end component;

-- Signals for IMMGEN
signal imm_generated : signed(31 downto 0);

component genImm32 is
	port (
		instr : in std_logic_vector(31 downto 0);
		imm32 : out signed(31 downto 0));
end component;

-- Signals for MEMIntr
signal q_instr : std_logic_vector(31 downto 0) := X"00000000";

component memIntr is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

-- Signals for MEMData
signal q_data : std_logic_vector(31 downto 0);

component memData is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

-- Signals for ULA_control
signal aluctr_control : ULA_OP;

component ULA_control is	
	port(
		instr_part : in std_logic_vector(3 downto 0);
		aluop: in std_logic_vector(1 downto 0);
		aluctr: out ULA_OP);
end component;

-- Math Ports
signal even_value : std_logic_vector(31 downto 0) := (resultUla and (not (X"00000001")));

-- And Ports
signal and_Branch : std_logic := (Branch_control and MuxBranchResult);

-- Or Ports
signal or_Branch : std_logic := (and_Branch or isJAL_control);
signal or_JAL_JALR : STD_LOGIC := (isJAL_control or isJALR_control);

-- Signals for BLT/BGE
signal signal_answer : std_logic := resultUla(31);
signal inverted_signal_answer : std_logic := (not resultUla(31));

-- Instruction Ports
signal concat_instr : std_logic_vector(3 downto 0) := (q_instr(30)&q_instr(14 downto 12));

-- Signals for Processor
signal inverterMasterClock : std_logic := not masterClock;
signal rd_index : std_logic_vector(4 downto 0);

begin
	
	-- PC Part
	RegisterPC : PC port map(P => in_pc, Q => out_pc, reset => reset_pc, clk => masterClock);
	
	-- PC Hold
	RegisterHoldPC : PC port map(P => resultPC_adder, Q => old_future_pc, reset => reset_pc, clk => inverterMasterClock);
	
	-- Adders Part
	AdderPC : Adder port map(A => X"00000004", B => out_pc, Cin => "0", C => resultPC_adder);
	AdderJumps :  Adder port map(A => out_pc, B => std_logic_vector(imm_generated), Cin => "0", C => resultPCJump_adder);
	
	-- Muxs Part
	MuxWherePC : MUX port map(A => resultPC_adder, B => resultPCJump_adder, S => or_Branch, Z => resultMuxWherePC);
	MuxForJALR : MUX port map(A => resultMuxWherePC, B => even_value, S => isJALR_control, Z => in_pc);
	MuxULA : MUX port map(A => ro2_xregs, B => std_logic_vector(imm_generated), S => ALUSrc_control, Z => B_ula);
	MuxMEM : MUX port map(A => resultUla, B => q_data, S => MemToReg_control, Z => WriteDataRegisters_mux_mem);
	MuxBranchs : MUX_Branchs port map(A => zero_ula, B => inverted_zero_ula, C => signal_answer, D => inverted_signal_answer, S => q_instr(14 downto 12), Z => MuxBranchResult);
	MuxForJALs : MUX port map(A => WriteDataRegisters_mux_mem, B => old_future_pc, S => or_JAL_JALR, Z => WriteDataRegisters_final_mux);
	
	-- Memory of Instructions Part
	Mem_Instrunctions : memIntr port map(address => out_pc(9 downto 2), clock => inverterMasterClock, wren => '0', data => X"00000000", q => q_instr);
	
	-- Control Part
	Controller : control port map(opcode => (q_instr(6 downto 0)), Branch => Branch_control, isJAL => isJAL_control, isJALR => isJALR_control, MemRead => MemRead_control, MemToReg => MemToReg_control, ALUop => ALUop_control, MemWrite => MemWrite_control, ALUSrc => ALUSrc_control, RegWrite => RegWrite_control);
	
	-- Registers Part
	RegBank : xregs port map(clk => inverterMasterClock, wren => RegWrite_control, rst => '0', rs1 => (q_instr(19 downto 15)), rs2 => (q_instr(24 downto 20)), rd => (q_instr(11 downto 7)), data => WriteDataRegisters_final_mux, ro1 => ro1_xregs, ro2 => ro2_xregs);
	
	-- Immediate Generator Part
	Imm_Gen : genImm32 port map(instr => q_instr, imm32 => imm_generated);
	
	-- ULA Control Part
	ULA_Controller : ULA_control port map(instr_part => concat_instr, aluop => ALUop_control, aluctr => aluctr_control);
	
	-- ULA Part
	ALU : ula port map(opcode => aluctr_control, A => ro1_xregs, B => B_ula, Z => resultUla, zero => zero_ula);
	
	-- Memory of Data Part
	Mem_Data: memData port map(address => resultUla(9 downto 2), clock => masterClock, wren => MemWrite_control, data => ro2_xregs, q => q_data);
	
end processor_arch;
