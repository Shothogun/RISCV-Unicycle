library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv_pkg.all;

entity ULA_control_tb is
end ULA_control_tb;

architecture ULA_control_arch of ULA_control_tb is

signal instr_part: std_logic_vector(3 downto 0);
signal aluop : std_logic_vector(1 downto 0);
signal aluctr : ULA_OP;

component ULA_control is	
	port(
		instr_part : in std_logic_vector(3 downto 0);
		aluop: in std_logic_vector(1 downto 0);
		aluctr: out ULA_OP);
end component;

begin
	i1 : ULA_control
		port map (
			instr_part => instr_part,
			aluop => aluop,
			aluctr => aluctr);
			
		init : process
		begin
			
			-- LW Test
			aluop <= "00";
			instr_part <= "0001";
			wait for 4 ps;
			
			--SW Test
			aluop <= "00";
			instr_part <= "0001";
			wait for 4 ps;
			
			-- BEQ Test
			aluop <= "01";
			instr_part <= "0001";
			wait for 4 ps;
			
			aluop <= "10";
			
			-- ADD Test
			instr_part <= "0000";
			wait for 4 ps;
			
			-- SUB Test
			instr_part <= "1000";
			wait for 4 ps;
			
			-- AND Test
			instr_part <= "0111";
			wait for 4 ps;
			
			-- OR Test
			instr_part <= "0110";
			wait for 4 ps;
			
			-- XOR Test
			instr_part <= "0100";
			wait for 4 ps;
			
			-- SLL Test
			instr_part <= "0001";
			wait for 4 ps;
			
			-- SRL Test
			instr_part <= "0101";
			wait for 4 ps;
			
			-- SRA Test
			instr_part <= "1101";
			wait for 4 ps;
			
			-- SLT Test
			instr_part <= "0010";
			wait for 4 ps;
			
			-- SLTU Test
			instr_part <= "0011";
			wait for 4 ps;
			
			-- SLL Test
			instr_part <= "0001";
			wait for 4 ps;
			
		end process init;
end ULA_control_arch;