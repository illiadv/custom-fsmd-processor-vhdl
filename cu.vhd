library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ka is
	port(
	clk : in std_logic;
	rst : in std_logic;
	x : in std_logic_vector(7 downto 1);
	y : out std_logic_vector(24 downto 1)
	);
end ka;

architecture ka of ka is
subtype tcommand is std_logic_vector(24 downto 0);
type trom is array (0 to 19) of tcommand;
constant rom : trom := (
--y1     y2      y3     y4     y5    x       a0        a1
--321-----098-----76-----54-----3-----210-----98765-----43210
"0000" & "000" & "00" & "00" & "0" & "111" & "00001" & "01010",
"0001" & "001" & "01" & "01" & "0" & "000" & "00010" & "00000",
"0000" & "000" & "00" & "00" & "0" & "001" & "00100" & "00011",
"0010" & "000" & "00" & "00" & "0" & "000" & "00100" & "00000",
"0011" & "010" & "10" & "00" & "0" & "010" & "00110" & "00101",
"0100" & "000" & "00" & "00" & "0" & "011" & "00010" & "00111",
"0101" & "000" & "00" & "00" & "0" & "011" & "00010" & "00111",
"0000" & "000" & "00" & "00" & "0" & "100" & "01001" & "01000",
"0110" & "000" & "00" & "00" & "0" & "000" & "01001" & "00000",
"0111" & "000" & "00" & "00" & "0" & "000" & "00000" & "00000",
"0001" & "101" & "01" & "10" & "1" & "101" & "01100" & "01011",
"0000" & "000" & "00" & "00" & "0" & "110" & "01101" & "01111",
"0000" & "000" & "00" & "00" & "0" & "110" & "01110" & "10000",
"1000" & "000" & "00" & "00" & "0" & "000" & "10001" & "00000",
"1001" & "000" & "00" & "00" & "0" & "000" & "10001" & "00000",
"1010" & "000" & "00" & "00" & "0" & "000" & "10001" & "00000",
"1011" & "000" & "00" & "00" & "0" & "000" & "10001" & "00000",
"1100" & "011" & "00" & "00" & "0" & "011" & "10010" & "10011",
"1101" & "100" & "10" & "00" & "0" & "101" & "01100" & "01011",
"1110" & "000" & "00" & "00" & "0" & "000" & "00000" & "00000"
);

signal reg_com : tcommand;
signal y1_decoded : std_logic_vector (15 downto 0);
signal y2_decoded : std_logic_vector (7 downto 0);
signal y3_decoded : std_logic_vector (3 downto 0);
signal y4_decoded : std_logic_vector (3 downto 0);
signal y5_decoded : std_logic_vector (1 downto 0);
signal x_buf: std_logic_vector(7 downto 0);

component decoder is
		generic(
			N: integer := 3
			);
		port(D: in std_logic_vector (N-1 downto 0);
			En: in std_logic;
			Q: out std_logic_vector (2**N -1 downto 0)
			); 
end component;

begin
	x_buf <= x & "0";
	
	y1_dc: decoder
	generic map(N => 4)
	port map(D => reg_com(24 downto 21), En=>'0', Q=> y1_decoded);
	
	y2_dc: decoder
	generic map(N => 3)
	port map(D => reg_com(20 downto 18), En=>'0', Q=> y2_decoded);
	
	y3_dc: decoder
	generic map(N => 2)
	port map(D => reg_com(17 downto 16), En=>'0', Q=> y3_decoded);
		
	y4_dc: decoder
	generic map(N => 2)
	port map(D => reg_com(15 downto 14), En=>'0', Q=> y4_decoded);
		
	y5_dc: decoder
	generic map(N => 1)
	port map(D => reg_com(13 downto 13), En=>'0', Q=> y5_decoded);

process (rst, clk) is
begin
	if rst='0' then reg_com <= (others => '0');
	elsif rising_edge(clk) then
		if x_buf(conv_integer(reg_com(12 downto 10))) = '0' then
			reg_com <= rom(conv_integer(reg_com(9 downto 5)));
		else
			reg_com <= rom(conv_integer(reg_com(4 downto 0)));
		end if;
	end if;
end process;

y(1)  <= y1_decoded(1);
y(2)  <= y2_decoded(1);
y(3)  <= y3_decoded(1);
y(4)  <= y4_decoded(1);
y(5)  <= y1_decoded(2);
y(6)  <= y1_decoded(3);
y(7)  <= y2_decoded(2);
y(8)  <= y3_decoded(2);
y(9)  <= y1_decoded(4);
y(10) <= y1_decoded(5);
y(11) <= y1_decoded(6);
y(12) <= y1_decoded(7);
y(13) <= y4_decoded(2);
y(14) <= y5_decoded(1);
y(15) <= y1_decoded(8);
y(16) <= y1_decoded(9);
y(17) <= y1_decoded(10);
y(18) <= y1_decoded(11);
y(19) <= y1_decoded(12);
y(20) <= y2_decoded(3);
y(21) <= y1_decoded(13);
y(22) <= y2_decoded(4);
y(23) <= y1_decoded(14);
y(24) <= y2_decoded(5);

end ka;
