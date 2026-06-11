library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity oa is
	port(
	d1: in std_logic_vector(7 downto 0);
	d2: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	rst: in std_logic;
	y: in std_logic_vector(24 downto 1);
	x: out std_logic_vector(6 downto 1);
	r: out std_logic_vector(15 downto 0)
	);
end oa;

architecture oa of oa is
signal a, b, ain, bin : std_logic_vector(7 downto 0);
signal cnt : integer range 8 downto 0;
signal c, cin : std_logic_vector(9 downto 0);
signal c1 : std_logic_vector(7 downto 0);
signal ofl, cf, tgb, tgf1, tgf2, c2, c3 : std_logic;
signal sum : std_logic_vector(9 downto 0) := (others => '0');

begin
	ain <= d1 when y(1) = '1'
		else a(6 downto 0) & "0" when y(22) = '1'
		else a;
		
	bin <= d2 when y(2) = '1'
		else c(0) & b(7 downto 1) when y(7) = '1'
		else b;
		
	c1 <= (not a) when y(11) = '1' 
		else a when y(5) = '1' 
		else "00000110" when y(15) = '1'
		else (others => '0') when y(16) = '1'
		else "01100110" when y(17) = '1'
		else "01100000";

	c2 <= '1' when y(11) = '1' 
		else '0' when y(5) = '1' 
		else a(7); --y(11)
		
	c3 <= cf when y(10) = '1'
		else c(7);
	
	sum <= c + c1 + c2 when (y(5) or y(11) or y(15) or y(16) or y(17) or y(18)) = '1'  -- tut byl '0' &
		else sum;
	
	cin <= (others=>'0') when y(3)='1'
		else sum when (y(5) or y(11) or y(15) or y(16) or y(17) or y(18))='1'
		else "00" & c3 & c(7 downto 1) when (y(9) or y(10))='1'
		else c(8 downto 0) & '0' when y(21) = '1'
		else c;
			
	process(clk, rst) is 
	begin
		if rst = '0' then
			a <= (others => '0');
			b <= (others => '0');
			c <= (others => '0');
			
			cnt <= 0;
			ofl <= '0'; cf <= '0'; tgb <= '0'; tgf1 <= '0'; tgf2 <= '0';
			
		elsif rising_edge(clk) then
			a <= ain;
			b <= bin;
			c <= cin;
			
			if y(4) = '1' then
				cnt <= 8;
			elsif y(24) = '1' then
				cnt <= 7;
			elsif y(8) = '1' then
				cnt <= cnt - 1;
			end if;
			
			if y(6) = '1' then
				tgb <= b(0);
			end if;
			
			if y(13) = '1' then
				tgf1 <= '0';
			end if;
			
			if y(14) = '1' then
				tgf2 <= '0';
			end if;
				
			if y(19) = '1' then
				tgf1 <= c(3) or (c(2) and (c(1) or c(0)));
			end if;
			
			if y(20) = '1' then
				tgf2 <= c(7) or (c(6) and (c(5) or c(4)));
			end if;
			
			if y(5) = '1' or y(11) = '1' then

				cf <= sum(8);
				ofl <= c(7) xor c1(7) xor sum(7) xor sum(8);
			end if;
			
		end if;
	end process;	
			
	x(1) <= b(0);
	x(2) <= ofl;
	x(3) <= '1' when cnt = 0 else '0';
	x(4) <= tgb;
	x(5) <= tgf1;
	x(6) <= tgf2;
	r <= c(7 downto 0) & b when y(12) = '1'
	else "000000" & c(9 downto 0) when y(23) = '1'
	else (others => 'Z');

end oa;
