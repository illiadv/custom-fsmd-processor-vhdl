library ieee;
use ieee.std_logic_1164.all;

entity ka_tb is
end ka_tb;

architecture tb of ka_tb is

component ka is
	port(
	clk : in std_logic;
	rst : in std_logic;
	x : in std_logic_vector(7 downto 1);
	y : out std_logic_vector(24 downto 1)
	);
end component;

signal clk : std_logic := '0';
signal rst : std_logic;
signal x : std_logic_vector(7 downto 1);
signal y : std_logic_vector(24 downto 1);

constant T : time := 10 ns;

begin
	uut : ka port map(
	clk => clk,
	rst => rst,
	x => x,
	y => y
	);
	
	p_clk : process
	begin
		clk <= not clk; wait for T / 2;
	end process;
	
	x_p : process
	begin
		x(7) <= '0';
		x(1) <= '0';
		wait for T*5;
		--y8
		x(1) <= '1';
		x(2) <= '1';
		x(3) <= '0';
		wait for T*2;
		x(2) <= '0';
		x(3) <= '1';
		x(4) <= '0';
		wait for T*5;
		
		x(7) <= '1';
		x(3) <= '0';
		wait for T*2;
		
		x(5) <= '0';
		x(6) <= '0';
		wait for T*4;
		x(5) <= '0';
		x(6) <= '1';
		wait for T*4;
		x(5) <= '1';
		x(6) <= '0';
		wait for T*4;
		x(5) <= '1';
		x(6) <= '1';
		x(3) <= '1';

		wait;
	end process;
	rst <= '0', '1' after 5 ns;
end tb;
