library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_tb is
end mem_tb;

architecture mem_arch of mem_tb is

signal wren, clock : std_logic;
signal data, q : std_logic_vector(31 downto 0);
signal address : std_LOGIC_VECTOR(7 downto 0);

component mem IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

begin
	i1: mem
	port map(
	clock => clock,
	address => address,
	data => data,
	wren => wren,
	q => q);
	
	init: process
	begin
		clock <= '0';
		wait for 4 ps;
		address <= X"00";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= X"01";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"02";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"03";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"04";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"05";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"06";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"07";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"08";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"09";
		clock <= '1';
		wait for 4 ps;
		clock <= '0';
		wait for 4 ps;
		address <= x"0A";
		clock <= '1';
		wait for 4 ps;
	end process;
end mem_arch;