library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oa_tb is
end oa_tb;

architecture tb of oa_tb is
component oa
	port(
	d1: in std_logic_vector(7 downto 0);
	d2: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	rst: in std_logic;
	y: in std_logic_vector(24 downto 1);
	x: out std_logic_vector(6 downto 1);
	r: out std_logic_vector(15 downto 0)
	);
end component;

signal d1 : std_logic_vector(7 downto 0);
signal d2 : std_logic_vector(7 downto 0);
signal clk : std_logic := '0';
signal rst : std_logic;
signal y : std_logic_vector(24 downto 1);
signal x : std_logic_vector(6 downto 1);
signal r : std_logic_vector(15 downto 0);

constant T : time := 10 ns;
begin
	UUT : oa port map(
	d1 => d1,
	d2 => d2,
	clk => clk,
	rst => rst,
	y => y,
	x => x,
	r => r
	);
	
	clk_p : process
	begin
		clk <= not clk; wait for T/2;
	end process clk_p;
	
	y_p : process
	begin
		wait for T;
		y <= (1 => '1', others => '0'); wait for T;
		y <= (2 => '1', others => '0'); wait for T;
		y <= (3 => '1', others => '0'); wait for T;
		y <= (4 => '1', others => '0'); wait for T;
		
		loop
		
		if x(1) = '1' then
			y <= (5 => '1', others => '0'); wait for T;
		end if;
		
		y <= (6 => '1', others => '0'); wait for T;
		y <= (7 => '1', others => '0'); wait for T;
		y <= (8 => '1', others => '0'); wait for T;
		
		if x(2) = '1' then
			y <= (9 => '1', others => '0'); wait for T;
		else
			y <= (10 => '1', others => '0'); wait for T;
		end if;
		
		exit when x(3) = '1';
		
		end loop;
		
		if x(4) = '1' then
			y <= (11 => '1', others => '0'); wait for T;
		end if;
		
		y <= (12 => '1', others => '0'); wait for T;
		
	end process;
	
	rst <= '0', '1' after 10 ns;
	
	d1 <= std_logic_vector(to_signed(12,  d1'length));
	d2 <= std_logic_vector(to_signed(5,  d2'length));
	
end tb;
