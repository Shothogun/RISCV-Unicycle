library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32_tb is
end genImm32_tb;

architecture genImm32_arch of genImm32_tb is

signal instr : std_logic_vector(31 downto 0);
signal imm32 : signed(31 downto 0);

component genImm32
	port (
		instr : in std_logic_vector(31 downto 0);
		imm32 : out signed(31 downto 0));
end component;

begin
	i1 : genImm32
	port map (
		instr => instr,
		imm32 => imm32);
		
	init : process
	begin
		instr <= X"000002b3";
		wait for 3 ps;
		instr <= X"01002283";
		wait for 3 ps;
		instr <= X"f9c00313";
		wait for 3 ps;
		instr <= X"fff2c293";
		wait for 3 ps;
		instr <= X"16200313";
		wait for 3 ps;
		instr <= X"01800067";
		wait for 3 ps;
		instr <= X"00002437";
		wait for 3 ps;
		instr <= X"02542e23";
		wait for 3 ps;
		instr <= X"fe5290e3";
		wait for 3 ps;
		instr <= X"00c000ef";
		wait for 3 ps;
		
	end process init;
end genImm32_arch;