library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end PC_tb;

architecture PC_arch of PC_tb is

signal P, Q : std_logic_vector(31 downto 0);
signal reset, clk : std_logic;

component PC is	
	port(
		P : in std_logic_vector(31 downto 0);
		reset, clk: in std_logic;
		Q: out std_logic_vector(31 downto 0));
end component;

begin
	i1 : PC
		port map (
			P => P,
			reset => reset,
			clk => clk,
			Q => Q);
			
		init : process
		begin
			
			P <= X"00000000";
			
			for i in 0 to 31 loop
				clk <= '0';
				wait for 4 ps;
				clk <= '1';
				wait for 4 ps;
				P <= std_logic_vector(signed(P) + 1);
			end loop;
		end process init;
end PC_arch;