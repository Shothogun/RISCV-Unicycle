library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder_tb is
end Adder_tb;

architecture Adder_arch of Adder_tb is

signal A, B, C : std_logic_vector(31 downto 0);

component Adder is	
	port(
		A,B: in std_logic_vector(31 downto 0);
		Cin: in	 std_logic_vector(0 downto 0);
		C: out std_logic_vector(31 downto 0);
		Cout: out  std_logic_vector(0 downto 0));
end component;

begin
	i1 : Adder
		port map (
			A => A,
			B => B,
			Cin => "0",
			C => C);
			
		init : process
		begin
			
			A <= X"00000001";
			B <= X"00000001";
			
			for i in 0 to 31 loop
				wait for 4 ps;
				A <= std_logic_vector(signed(A) + 1);
				B <= std_logic_vector(signed(B) + 1);
			end loop;
		end process init;
end Adder_arch;