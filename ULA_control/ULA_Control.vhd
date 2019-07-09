library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_control is	
	port(
		funct7: in std_logic_vector(6 downto 0);
		funct3: in std_logic_vector(2 downto 0);
		aluop: in std_logic_vector(1 downto 0);
		aluctr: out std_logic_vector(3 downto 0));
end ULA_control;

architecture ULA_control_arch of ULA_control is
	signal funct7_sign: std_logic_vector(6 downto 0);
	signal funct3_sign: std_logic_vector(2 downto 0);
	signal aluop_sign: std_logic_vector(1 downto 0);
	signal aluctr_sign: std_logic_vector(3 downto 0);
begin	

	funct3_sign <= funct3;
	funct7_sign <= funct7;
	aluop_sign  <= aluop;
	aluctr		<= aluctr_sign;
	
	process(aluop_sign,funct3_sign, funct7_sign)
	begin
		case aluop_sign is 
			-- ADD
			when "00" => aluctr_sign <= "0000";
			-- SUB
			when "01" => aluctr_sign <= "0001";
			-- R-type
			when "10" => case funct3_sign is
								when "000" => -- ADD
												  if (funct7(5)= '0') 
														then aluctr_sign <= "0000";
												  -- SUB
												  else aluctr_sign <= "0001";
												  end if;
								-- SLL
								when "001" => aluctr_sign <= "0101";
								-- SLT
								when "010" => aluctr_sign <= "1000";
								-- SLTU
								when "011" => aluctr_sign <= "1001";
								-- XOR
								when "100" => aluctr_sign <= "0100";
								when "101" => -- SRL
												  if (funct7_sign(5)= '0') 
														then aluctr_sign <= "0110";
												  -- SRA
												  else aluctr_sign <= "0111";
												  end if;
								-- OR
								when "110" => aluctr_sign <= "0011";
								-- AND
								when "111" => aluctr_sign <= "0010";
								when others => aluctr_sign <= "0000";
							 end case;
			when others => aluctr_sign <= "0000";
		end case;
	end process;
end ULA_control_arch;