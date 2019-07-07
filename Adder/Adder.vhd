library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Adder is	
	port(
		A,B: in std_logic_vector(31 downto 0);
		Cin: in	 std_logic_vector(0 downto 0);
		C: out std_logic_vector(31 downto 0);
		Cout: out  std_logic_vector(0 downto 0));
end Adder;

architecture Adder_arch of Adder is
	signal A_sign, B_sign, C_sign: std_logic_vector(31 downto 0);
	signal Cin_sign, Cout_sign: std_logic_vector(0 downto 0);
	signal SUM: std_logic_vector(32 downto 0);
begin	
	A_sign <= A;
	B_sign <= B;
	Cin_sign <= Cin; 
	Cout <= Cout_sign;
	C <= C_sign;
	
	Cout_sign <= SUM(32 downto 32);
	C_sign <= SUM(31 downto 0);
	
	SUM <= unsigned('0'&A_sign) + unsigned('0'&B_sign) + unsigned(X"00000000"&Cin_sign);
end Adder_arch;