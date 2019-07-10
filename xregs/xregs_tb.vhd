library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xregs_tb is
end xregs_tb;

architecture xregs_arch of xregs_tb is

signal clk, wren, rst : std_logic;
signal ro1, ro2, data : std_logic_vector(31 downto 0);
signal rs1, rs2, rd : std_logic_vector(4 downto 0);
signal aux1, aux2 : integer;

component xregs is
	port (
		clk, wren, rst : in std_logic;
		rs1, rs2, rd : in std_logic_vector(4 downto 0);
		data : in std_logic_vector(31 downto 0);
		ro1, ro2 : out std_logic_vector(31 downto 0));
end component;

begin
	i1 : xregs
	port map (
		clk => clk,
		wren => wren,
		rst => rst,
		rs1 => rs1,
		rs2 => rs2,
		rd => rd,
		data => data,
		ro1 => ro1,
		ro2 => ro2);
		
	init : process
	begin
	
		-- Escrita nos registradores 1 a 31
		data <= X"00000001";
		wren <= '1';
		rd <= "00001";
		rst <= '0';
		for i in 1 to 31 loop
			clk <= '0';
			wait for 4 ps;
			clk <= '1';
			wait for 4 ps;
			data <= std_logic_vector(signed(data) + 1);
			rd <= std_logic_vector(signed(rd) + 1);
      end loop;
		
		-- Teste 1 - Leitura incremental dos registradores 
		wren <= '0';
		rs1 <= "00001"; -- 1 - 10
		rs2 <= "01011"; -- 11 -- 20
		aux1 <= 1;
		aux2 <= 11;
		for i in 1 to 10 loop
			clk <= '0';
			wait for 4 ps;
			clk <= '1';
			wait for 4 ps;
			Assert(signed(ro1) = aux1) report "Erro Teste 1 ro1" severity ERROR;
			Assert(signed(ro2) = aux2) report "Erro Teste 1 ro2" severity ERROR;
			aux1 <= aux1 + 1;
			aux2 <= aux2 + 1;
			rs1 <= std_logic_vector(signed(rs1) + 1);
			rs2 <= std_logic_vector(signed(rs2) + 1);
      end loop;
		
		-- Teste 2 - Leitura simultânea dos registradores
		wait for 1 ps;
		rs1 <= rs2; -- rs1 = 21, rs2 = 21
		aux1 <= 21;
		aux2 <= 21;
		for i in 21 to 31 loop
			clk <= '0';
			wait for 4 ps;
			clk <= '1';
			wait for 4 ps;
			Assert(signed(ro1) = aux1) report "Erro Teste 2 ro1" severity ERROR;
			Assert(signed(ro2) = aux2) report "Erro Teste 2 ro2" severity ERROR;
			aux1 <= aux1 + 1;
			aux2 <= aux2 + 1;
			rs1 <= std_logic_vector(signed(rs1) + 1);
			rs2 <= std_logic_vector(signed(rs2) + 1);
      end loop;
		
		-- Teste 3 - Escrita no registrador 0
		wren <= '1';
		rd <= "00000";
		data <= X"0000CAFE";
		clk <= '0';
		wait for 4 ps;
		clk <= '1';
		wait for 4 ps;
		
		wren <= '0';
		rs1 <= "00000";
		rs2 <= "00000";
		clk <= '0';
		wait for 4 ps;
		clk <= '1';
		wait for 4 ps;
		Assert(ro1 = X"00000000") report "Erro Teste 3 ro1" severity ERROR;
		Assert(ro2 = X"00000000") report "Erro Teste 3 ro2" severity ERROR;
		
		-- Teste 4 - Escrita no mesmo ciclo
		wren <= '1';
		rd <= "00001";
		wait for 4 ps;
		
		wren <= '0';
		rs1 <= "00001";
		rs2 <= "00001";
		clk <= '0';
		wait for 4 ps;
		clk <= '1';
		wait for 4 ps;
		Assert(ro1 = X"00000001") report "Erro Teste 4 ro1" severity ERROR;
		Assert(ro2 = X"00000001") report "Erro Teste 4 ro2" severity ERROR;
		
		-- Teste 5 - Teste do reset
		rst <= '1';
		wait for 4 ps;
		
		rst <= '0';
		rs1 <= "01001";
		rs2 <= "01001";
		clk <= '0';
		wait for 4 ps;
		clk <= '1';
		wait for 4 ps;
		Assert(ro1 = X"00000000") report "Erro Teste 5 ro1" severity ERROR;
		Assert(ro2 = X"00000000") report "Erro Teste 5 ro2" severity ERROR;
		
	end process init;
end xregs_arch;