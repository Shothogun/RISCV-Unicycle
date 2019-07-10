library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_tb is
end Control_tb;

architecture Control_arch of Control_tb is

signal opcode: std_logic_vector(6 downto 0);
signal Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite: std_logic;
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

begin
	i1 : control
		port map (
			opcode => opcode,
			Branch => Branch,
			MemRead => MemRead,
			MemToReg => MemToReg,
			ALUop => ALUop,
			MemWrite => MemWrite,
			ALUSrc => ALUSrc,
			RegWrite => RegWrite);
			
		init : process
		begin
			
			opcode <= "0110011";
			wait for 4 ps;
			opcode <= "0000011";
			wait for 4 ps;
			opcode <= "0100011";
			wait for 4 ps;
			opcode <= "1100011";
			wait for 4 ps;
			
		end process init;
end Control_arch;