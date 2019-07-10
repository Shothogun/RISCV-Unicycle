library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is	
	port(
		opcode: in std_logic_vector(6 downto 0);
		Branch: out std_logic;
		MemRead: out std_logic;
		MemToReg: out std_logic;
		ALUop: out std_logic_vector(1 downto 0);
		MemWrite: out std_logic;
		ALUSrc: out std_logic;
		RegWrite: out std_logic);
end control;

architecture control_arch of control is
	signal opcode_sign: 		std_logic_vector(6 downto 0);
	signal Branch_sign: 		std_logic;
	signal MemRead_sign:  	std_logic;
	signal MemToReg_sign:  	std_logic;
	signal ALUop_sign:  		std_logic_vector(1 downto 0);
	signal MemWrite_sign:  	std_logic;
	signal ALUSrc_sign: 		std_logic;
	signal RegWrite_sign:  	std_logic;
begin	
	opcode_sign    <= opcode;
	Branch         <= Branch_sign;
	MemRead	   	<= MemRead_sign;
	MemToReg		   <= MemToReg_sign;
	ALUop     		<= ALUop_sign;
	MemWrite  		<= MemWrite_sign;
	ALUSrc    		<= ALUSrc_sign;
	RegWrite  		<= RegWrite_sign;

	process(opcode_sign)
	begin
		case opcode_sign is 
			-- LUI-type
			when "0110111" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';	
			-- AUIPC-type
			when "0010111" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';	
			-- IL-type
			when "0000011" =>
				Branch_sign <= '0';
				MemRead_sign <= '1';
				MemToReg_sign <= '1';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '1';
				RegWrite_sign <= '1';
			-- B-type
			when "1100011" =>
				Branch_sign <= '1';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "01";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';
			-- JAL-type
			when "1101111" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';
			-- JALR-type
			when "1100111" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';		
			-- Store-type
			when "0100011" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '1';
				ALUSrc_sign <= '1';
				RegWrite_sign <= '0';				
			-- ILA-type
			when "0010011" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';
			-- Reg-type
			when "0110011" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "10";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '1';
			-- Ecall
			when "1110011" =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';
			when others =>
				Branch_sign <= '0';
				MemRead_sign <= '0';
				MemToReg_sign <= '0';
				ALUop_sign <= "00";
				MemWrite_sign <= '0';
				ALUSrc_sign <= '0';
				RegWrite_sign <= '0';
		end case;
	end process;

	
end control_arch;