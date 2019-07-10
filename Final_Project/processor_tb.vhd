library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end processor_tb;

architecture processor_arch of processor_tb is

signal masterClock, flipflopClock : std_logic;

component processor is
	port(
	masterClock : in std_logic;
	flipflopClock : in std_logic
	);
end component;

begin
	i1 : processor
		port map (
			masterClock => masterClock,
			flipflopClock => flipflopClock
			);
		
	InternalClock : process
	begin
		while 1 loop
			flipflopClock <= '0';
			wait for 1/10 s;
			flipflopClock <= '1';
		end loop;
	end process;
	
	Processor : process
	begin
		masterClock <= '0';
		wait for 1 s;
		masterClock <= '1';
		wait for 1 s;
	end process;
end PC_arch;