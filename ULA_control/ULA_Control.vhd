library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv_pkg.all;

entity ULA_control is	
	port(
		instr_part : in std_logic_vector(3 downto 0);
		aluop: in std_logic_vector(1 downto 0);
		aluctr: out ULA_OP);
end ULA_control;

architecture ULA_control_arch of ULA_control is
	signal funct7_sign: std_logic;
	signal funct3_sign: std_logic_vector(2 downto 0);
	signal aluop_sign: std_logic_vector(1 downto 0);
	signal aluctr_sign: ULA_OP;
begin	

	funct3_sign <= (instr_part(2)&instr_part(1)&instr_part(0));
	funct7_sign <= instr_part(3);
	aluop_sign  <= aluop;
	aluctr		<= aluctr_sign;
	
	process(aluop_sign,funct3_sign, funct7_sign)
	begin
		case aluop_sign is 
			-- ADD
			when "00" => aluctr_sign <= ADD_OP;
			-- SUB
			when "01" => aluctr_sign <= SUB_OP;
			-- R-type
			when "10" => case funct3_sign is
								when "000" => -- ADD
												  if (funct7_sign = '0') 
														then aluctr_sign <= ADD_OP;
												  -- SUB
												  else aluctr_sign <= SUB_OP;
												  end if;
								-- SLL
								when "001" => aluctr_sign <= SLL_OP;
								-- SLT
								when "010" => aluctr_sign <= SLT_OP;
								-- SLTU
								when "011" => aluctr_sign <= SLTU_OP;
								-- XOR
								when "100" => aluctr_sign <= XOR_OP;
								when "101" => -- SRL
												  if (funct7_sign = '0') 
														then aluctr_sign <= SRL_OP;
												  -- SRA
												  else aluctr_sign <= SRA_OP;
												  end if;
								-- OR
								when "110" => aluctr_sign <= OR_OP;
								-- AND
								when "111" => aluctr_sign <= AND_OP;
								when others => aluctr_sign <= ADD_OP;
							 end case;
			-- ILA-type
			when "11" => case funct3_sign is
								when "000" => aluctr_sign <= ADD_OP;
								when "010" => aluctr_sign <= SLT_OP;
								when "011" => aluctr_sign <= SLTU_OP;
								when "100" => aluctr_sign <= XOR_OP;
								when "110" => aluctr_sign <= OR_OP;
								when "111" => aluctr_sign <= AND_OP;
								when "001" => aluctr_sign <= SLL_OP;
								when others => 
													if (funct7_sign = '0') 
														then aluctr_sign <= SRL_OP;
												  else aluctr_sign <= SRA_OP;
												  end if;
							 end case;
			when others => aluctr_sign <= ADD_OP;
		end case;
	end process;
end ULA_control_arch;