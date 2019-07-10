library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv_pkg.all;
use work.reg_pkg.all;

entity processor is
	port(
	masterClock : in std_logic;
	flipflopClock : in std_logic
	);
end processor;

architecture processor_arch of processor is

-- Signals PC
signal out_pc : std_logic_vector(31 downto 0);
signal in_pc : std_logic_vector(31 downto 0) := X"00000000";
signal reset_pc : std_logic;

component PC is	
	port(
		P : in std_logic_vector(31 downto 0);
		reset, clk: in std_logic;
		Q: out std_logic_vector(31 downto 0));
end component;

-- Signals XREGS
signal ro1_xregs, ro2_xregs : std_logic_vector(31 downto 0);

component xregs is
	port (
		clk, wren, rst : in std_logic;
		rs1, rs2, rd : in std_logic_vector(4 downto 0);
		data : in std_logic_vector(31 downto 0);
		ro1, ro2 : out std_logic_vector(31 downto 0));
end component;

-- Signals MUX MEM
signal WriteDataRegisters_mux : std_logic_vector(31 downto 0);

component MUX is	
	port(
		A,B : in std_logic_vector(31 downto 0);
		S: in std_logic;
		Z: out std_logic_vector(31 downto 0));
end component;

-- Signals Control
signal Branch_control, MemRead_control, MemToReg_control, ALUSrc_control, MemWrite_control, RegWrite_control : std_logic; 
signal ALUop_control : std_logic_vector(1 downto 0);

component control is	
	port(
		opcode: in std_logic_vector(6 downto 0);
		Branch: out std_logic;
		MemRead: out std_logic;
		MemToReg: out std_logic;
		ALUop: out std_logic_vector(1 downto 0);
		MemWrite: out std_logic;
		ALUSrc: out std_logic;
		RegWrite: out std_logic);
end component;

-- Signals Adder PC
signal PC_adder, resultPC_adder : std_logic_vector(31 downto 0);

-- Signals Adder Jumps
signal resultPCJump_adder : std_logic_vector(31 downto 0);

component Adder is	
	port(
		A,B: in std_logic_vector(31 downto 0);
		Cin: in	 std_logic_vector(0 downto 0);
		C: out std_logic_vector(31 downto 0);
		Cout: out  std_logic_vector(0 downto 0));
end component;

-- Signals for ULA
signal A_ula, B_ula, resultUla: std_logic_vector(31 downto 0);
signal zero_ula : std_logic;

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
signal q_instr : std_logic_vector(31 downto 0);

component memIntr IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

-- Signals for MEMData
signal q_data : std_logic_vector(31 downto 0);

component memData IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

-- Signals for ULA_control
signal aluctr_control : ULA_OP;

component ULA_control is	
	port(
		instr_part : in std_logic_vector(3 downto 0);
		aluop: in std_logic_vector(1 downto 0);
		aluctr: out ULA_OP);
end component;

begin

	-- PC Part
	RegisterPC : PC port map(P => in_pc, Q => out_pc, reset => reset_pc, clk => masterClock);
	
	-- Adders Part
	AdderPC : Adder port map(A => X"00000004", B => PC_adder, Cin => "0", C => resultPC_adder);
	AdderJumps :  Adder port map(A => PC_adder, B => std_logic_vector(imm_generated), Cin => "0", C => resultPCJump_adder);
	
	-- Muxs Part
	MuxWherePC : MUX port map(A => resultPC_adder, B => resultPCJump_adder, S => (Branch_control and zero_ula), Z => in_pc);
	MuxULA : MUX port map(A => ro2_xregs, B => std_logic_vector(imm_generated), S => ALUSrc_control, Z => B_ula);
	MuxMEM : MUX port map(A => resultUla, B => q_data, S => MemToReg_control, Z => WriteDataRegisters_mux);
	
	-- Memory of Instructions Part
	Mem_Instrunctions : memIntr port map(address => out_pc(9 downto 2), clock => flipflopClock, wren => '0', data => X"00000000", q => q_instr);
	
	-- Control Part
	Controller : control port map(opcode => (q_instr(6 downto 0)), Branch => Branch_control, MemRead => MemRead_control, MemToReg => MemToReg_control, ALUop => ALUop_control, MemWrite => MemWrite_control, ALUSrc => ALUSrc_control, RegWrite => RegWrite_control);
	
	-- Registers Part
	RegBank : xregs port map(clk => flipflopClock, wren => RegWrite_control, rst => '0', rs1 => (q_instr(19 downto 15)), rs2 => (q_instr(24 downto 20)), rd => (q_instr(11 downto 7)), data => WriteDataRegisters_mux, ro1 => ro1_xregs, ro2 => ro2_xregs);
	
	-- Immediate Generator Part
	Imm_Gen : genImm32 port map(instr => q_instr, imm32 => imm_generated);
	
	-- ULA Control Part
	ULA_Controller : ULA_control port map(instr_part => (q_instr(30)&q_instr(14 downto 12)), aluop => ALUop_control, aluctr => aluctr_control);
	
	-- ULA Part
	ALU : ula port map(opcode => aluctr_control, A => ro1_xregs, B => B_ula, Z => resultUla, zero => zero_ula);
	
	-- Memory of Data Part
	Mem_Data: memData port map(address => resultUla(9 downto 2), clock => flipflopClock, wren => MemWrite_control, data => ro2_xregs, q => q_data);
	
end processor_arch;
