library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_tb is
end MUX_tb;

architecture MUX_arch of MUX_tb is

signal A, B , Z: std_logic_vector(31 downto 0);
signal S : std_logic;

component MUX is	
	port(
		A,B : in std_logic_vector(31 downto 0);
		S: in std_logic;
		Z: out std_logic_vector(31 downto 0));
end component;

begin
	i1 : MUX
		port map (
			A => A,
			B => B,
			S => S,
			Z => Z);
			
		init : process
		begin
			A <= X"0000CAFE";
			B <= X"00C0FFEE";
			
			S <= '0';
			wait for 4 ps;
			S <= '1';
			wait for 4 ps;
			
		end process init;
end MUX_arch;