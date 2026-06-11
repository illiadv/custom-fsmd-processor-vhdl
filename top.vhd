library ieee;
use ieee.std_logic_1164.all;

entity proc_module is
	port (
	clk : in std_logic;
	rst : in std_logic;
	opcode : in std_logic;
	d1 : in std_logic_vector(7 downto 0);
	d2 : in std_logic_vector(7 downto 0);
	r : out	std_logic_vector(15 downto 0)
	);
end proc_module;

architecture arch of proc_module is
component ka is 
	port(
	clk : in std_logic;
	rst : in std_logic;
	x : in std_logic_vector(7 downto 1);
	y : out std_logic_vector(24 downto 1)
	);
end component;

component oa is
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

signal y : std_logic_vector(24 downto 1);
signal x : std_logic_vector(6 downto 1);
signal xop : std_logic_vector(7 downto 1);
signal nclk : std_logic;

begin
	nclk <= not clk;
	xop <= opcode & x;

dd1 : ka port map (clk => clk, rst => rst, x => xop, y => y);
dd2 : oa port map (d1 => d1, d2 => d2, clk => nclk, rst => rst,
	y => y, x => x, r => r);
end arch;
