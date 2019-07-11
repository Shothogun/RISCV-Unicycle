library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_pkg.all;

entity xregs is
	port (
		clk, wren, rst : in std_logic;
		rs1, rs2, rd : in std_logic_vector(4 downto 0);
		data : in std_logic_vector(31 downto 0);
		ro1, ro2 : out std_logic_vector(31 downto 0));
end xregs;

architecture xregs_arch of xregs is

signal regs : Reg := (others => (others => '0'));

begin
	
	ro1 <= to_stdlogicvector(regs(to_integer(unsigned(rs1))));
	ro2 <= to_stdlogicvector(regs(to_integer(unsigned(rs2))));
	
	proc_regs:process(clk, rst, wren)
	begin
		if (rst = '1') then
			regs <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if (wren = '1') then
				if( rd /= "00000") then
					regs(to_integer(unsigned(rd))) <= to_bitvector(data);
				end if;
			end if;
		else
			regs <= regs;
		end if;
	end process;
end xregs_arch;


	