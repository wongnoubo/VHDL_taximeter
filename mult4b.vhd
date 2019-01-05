library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity mult4b is
	generic ( s : integer :=4);
	port ( r : out std_logic_vector(2*s downto 1);
			a , b : in std_logic_vector(s downto 1));
end entity mult4b;

architecture one of mult4b is
	signal a0 : std_logic_vector(2*s downto 1);
begin
	a0 <= conv_std_logic_vector(0,s) & a;
		process (a , b)
			variable r1 : std_logic_vector(2*s downto 1);
		begin
			r1 := (others => '0');
			for i in 1 to s loop
				if (b(i) = '1') then
					r1 := r1 + to_stdlogicvector (to_bitvector(a0) sll (i-1));
				end if;
			end loop;
			r <= r1;
		end process;
end architecture one;