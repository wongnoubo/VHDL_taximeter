library ieee;
use ieee.std_logic_1164.all;

entity mult10b is
	port ( d1 , d2 : in std_logic_vector (9 downto 0);
		   q : out std_logic_vector ( 19 downto 0)
	);
end;

architecture bhv of mult10b is
	component mult4b
	generic ( s : integer);
		port ( r: out std_logic_vector (2*s downto 1);
				a , b : in std_logic_vector (s downto 1)
		);
	end component;
begin
	u25_1 : mult4b generic map (s => 10)
				port map (r => q , a => d1 , b => d2);
end;