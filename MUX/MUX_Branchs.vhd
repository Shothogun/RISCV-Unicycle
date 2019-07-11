library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_Branchs is	
	port(
		A,B,C,D : in std_logic;
		S: in std_logic_vector(2 downto 0);
		Z: out std_logic);
end MUX_Branchs;

architecture MUX_Branchs_arch of MUX_Branchs is
	signal A_sign, B_sign, C_sign, D_sign, Z_sign: std_logic;
	signal S_sign: std_logic_vector(2 downto 0);
begin	
	A_sign <= A;
	B_sign <= B;
	C_sign <= C;
	D_sign <= D;
	
	S_sign <= S;
	
	Z 		 <= Z_sign;
	
process(S_sign, A_sign, B_sign, C_sign, D_sign)
begin
	case S_sign is
		when "000" => Z_sign <= A_sign;
		when "001" => Z_sign <= B_sign;
		when "100" => Z_sign <= C_sign;
		when others => Z_sign <= D_sign;
	end case;
end process;
end MUX_Branchs_arch;