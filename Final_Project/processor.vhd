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
signal in_pc, out_pc : std_logic_vector(7 downto 0);
signal reset_pc : std_logic;

component PC is	
	port(
		P : in std_logic_vector(7 downto 0);
		reset, clk: in std_logic;
		Q: out std_logic_vector(7 downto 0));
end component;

-- Signals XREGS
signal data_xregs, ro1_xregs, ro2_xregs : std_logic_vector(31 downto 0);
signal rs1_xregs, rs2_xregs, rd_xregs : std_logic_vector(4 downto 0);
signal wren_xregs, rst_xregs : std_logic;

component xregs is
	port (
		clk, wren, rst : in std_logic;
		rs1, rs2, rd : in std_logic_vector(4 downto 0);
		data : in std_logic_vector(31 downto 0);
		ro1, ro2 : out std_logic_vector(31 downto 0));
end component;

-- Signals MUX PC
signal SaltoPC_mux, IncrementaPC_mux, SaidaPC_mux : std_logic_vector(31 downto 0);

-- Signals MUX ULA
signal ReadData2_mux, Imediato_mux, SaidaToULA_mux : std_logic_vector(31 downto 0);

-- Signals MUX MEM
signal ReadDataMem_mux, ULAResult_mux, WriteDataULA_mux : std_logic_vector(31 downto 0);
signal EscolheToRegister_mux : std_logic;

component MUX is	
	port(
		A,B : in std_logic_vector(31 downto 0);
		S: in std_logic;
		Z: out std_logic_vector(31 downto 0));
end component;

-- Signals Control
signal opcode_control : std_logic_vector(6 downto 0);
signal Branch_control, MemRead_control, MemToReg_control, ALUSrc_control, MemWrite_control, RegWrite_control : std_logic; 
signal ALUop : std_logic_vector(1 downto 0);

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
signal Imediato_adder, resultPCJump_adder : std_logic_vector(31 downto 0);

component Adder is	
	port(
		A,B: in std_logic_vector(31 downto 0);
		Cin: in	 std_logic_vector(0 downto 0);
		C: out std_logic_vector(31 downto 0);
		Cout: out  std_logic_vector(0 downto 0));
end component;

-- Signals for ULA
signal opcode_ula : ULA_OP;
signal A_ula, B_ula, Z_ula : std_logic_vector(31 downto 0);
signal zero_ula : std_logic;


component ula is
	generic (WSIZE : natural := 32);
	port (
		opcode : in ULA_OP;
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end component;

-- Signals GENIMM32
signal instr_gen, imm32_gen : std_logic_vector(31 downto 0);


component genImm32 is
	port (
		instr : in std_logic_vector(31 downto 0);
		imm32 : out signed(31 downto 0));
end component;

-- Signals for MEMIntr
signal address_intr : std_logic_vector(7 downto 0);
signal data_intr, q_intr : std_logic_vector(31 downto 0);

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
signal address_data : std_logic_vector(7 downto 0);
signal data_data, q_data : std_logic_vector(31 downto 0);

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

component ULA_control is	
	port(
		funct7: in std_logic_vector(6 downto 0);
		funct3: in std_logic_vector(2 downto 0);
		aluop: in std_logic_vector(1 downto 0);
		aluctr: out std_logic_vector(3 downto 0));
end component;

begin
	RegisterPC : PC port map(P => in_pc, Q => out_pc, reset => reset_pc, clk => masterClock);
	AdderPC : Adder port map(A => X"00000004", B => PC_adder, Cin => "0", C => resultPC_adder);
	AdderJumps :  Adder port map(A => PC_adder, B => Imediato_adder, Cin => "0", C => resultPCJump_adder);
	--MuxWherePC : MUX port map(A => resultPC_adder, B => resultPCJump_adder, )
end processor_arch;
