library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX is	
	port(
		A,B : in std_logic_vector(31 downto 0);
		S: in std_logic;
		Z: out std_logic_vector(31 downto 0));
end MUX;

architecture MUX_arch of MUX is
	signal A_sign, B_sign, Z_sign: std_logic_vector(31 downto 0);
	signal S_sign: std_logic;
begin	
	A_sign <= A;
	B_sign <= B;
	S_sign <= S;
	Z 		 <= Z_sign;
	
	Z_sign <= A_sign	when S_sign = '0' else B_sign;
end MUX_arch;