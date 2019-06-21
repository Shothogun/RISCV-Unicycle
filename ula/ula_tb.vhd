library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv_pkg.all;

entity ula_tb is
end ula_tb;

architecture ula_arch of ula_tb is

signal opcode : ULA_OP;
signal A, B : std_logic_vector(31 downto 0);
signal Z : std_logic_vector(31 downto 0);
signal zero : std_logic;

component ula
	generic (WSIZE : natural := 32);
	port (
		opcode : in ULA_OP;
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end component;

begin
	i1 : ula
	port map (
		A => A,
		B => B,
		zero => zero,
		opcode => opcode,
		Z => Z);
		
	init : process
	begin
	
		A <= X"00000004"; B <= X"00000004"; opcode <= ADD_OP; -- CASO POSITIVO
		wait for 4 ps;
		A <= X"80000000"; B <= X"80000000"; opcode <= ADD_OP; -- CASO OVERFLOW
		wait for 4 ps;
		A <= X"80000000"; B <= X"00000004"; opcode <= ADD_OP; -- CASO NEGATIVO
		wait for 4 ps;
		A <= X"FFFFFFFF"; B <= X"00000001"; opcode <= ADD_OP; -- CASO ZERO
		wait for 4 ps;
		
		A <= X"00000008"; B <= X"00000004"; opcode <= SUB_OP; -- CASO POSITIVO
		wait for 4 ps;
		A <= X"F0000000"; B <= X"7FFFFFFF"; opcode <= SUB_OP; -- CASO OVERFLOW
		wait for 4 ps;
		A <= X"00000004"; B <= X"00000008"; opcode <= SUB_OP; -- CASO NEGATIVO
		wait for 4 ps;
		A <= X"00000004"; B <= X"00000004"; opcode <= SUB_OP; -- CASO ZERO
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"00000004"; opcode <= AND_OP;
		wait for 4 ps;
		A <= X"00000004"; B <= X"00000000"; opcode <= AND_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"00000004"; opcode <= OR_OP;
		wait for 4 ps;
		A <= X"00000004"; B <= X"00000000"; opcode <= OR_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"00000004"; opcode <= XOR_OP;
		wait for 4 ps;
		A <= X"00000004"; B <= X"00000000"; opcode <= XOR_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"00000004"; opcode <= SLL_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SLL_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"00000004"; opcode <= SRL_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SRL_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"00000004"; opcode <= SRA_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SRA_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"FFFFFFF4"; opcode <= SLT_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SLT_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"FFFFFFF4"; opcode <= SLTU_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SLTU_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"FFFFFFF4"; opcode <= SGE_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SGE_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"FFFFFFF4"; opcode <= SGEU_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"00000004"; opcode <= SGEU_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"FFFFFFF4"; opcode <= SEQ_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"FFFFFFF4"; opcode <= SEQ_OP;
		wait for 4 ps;
		
		A <= X"00000004"; B <= X"FFFFFFF4"; opcode <= SNE_OP;
		wait for 4 ps;
		A <= X"FFFFFFF4"; B <= X"FFFFFFF4"; opcode <= SNE_OP;
		wait for 4 ps;
		
	end process init;
end ula_arch;