library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is	
	port(
		P : in std_logic_vector(31 downto 0) := X"00000000";
		reset, clk: in std_logic;
		Q: out std_logic_vector(31 downto 0) := X"00000000");
end PC;

architecture PC_arch of PC is
	signal P_sign, Q_sign: std_logic_vector(31 downto 0);
begin	

	P_sign 	<= P;
	Q 			<= Q_sign;
	
	process(clk, reset)
	begin
		if reset = '1'				then				Q_sign <= X"00000000";
		else
			if rising_edge(clk) 	then				Q_sign <= P_sign;
			end if;
		end if;
	end process;
end PC_arch;