library ieee;
use ieee.std_logic_1164.all;

entity proc_tb is
end proc_tb;

architecture tb of proc_tb is

component proc_module is
	port (
	clk : in std_logic;
	rst : in std_logic;
	opcode : in std_logic;
	d1 : in std_logic_vector(7 downto 0);
	d2 : in std_logic_vector(7 downto 0);
	r : out	std_logic_vector(15 downto 0)
	);
end component;

signal clk : std_logic := '0';
signal rst, opcode : std_logic;
signal d1 : std_logic_vector(7 downto 0);
signal d2 : std_logic_vector(7 downto 0);
signal r : std_logic_vector(15 downto 0);

constant T : time := 10 ns;

begin
	uut : proc_module port map(
	clk => clk,
	rst => rst,
	opcode => opcode,
	d1 => d1,
	d2 => d2,
	r => r
	);
	
	p_clk : process
	begin
		clk <= not clk; wait for T / 2;
	end process;
	
	opcode <= '0', '1' after 300 ns;
	d1 <= "00001111"; -- 12
	d2 <= "00000110"; -- 6

	rst <= '0', '1' after 5 ns;
end tb;
