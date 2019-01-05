--ÉèÖÃÊ±¼ä
--µ÷ÓÃ¸÷¸öÍ·ÎÄ¼ş
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--Set the inital value
entity SetInit is
	port
	(
		clk       : in std_logic;  --Ê±ÖÓ
		time_state : in std_logic;  --ÉèÖÃÄ£Ê½¿ªÆô¹Ø±Õ
		sel , set : in std_logic;  --Ñ¡ÔñÎ»£¬+1
		confirm : in std_logic;  --È·ÈÏ
		timesel : out std_logic;--ÉèÖÃÊ±¼ä±êÖ¾Î»
		hour_s, hour_f , min_s , min_f : out integer range 0 to 9 --00:00ËÄÎ»
	);
end entity SetInit;

architecture set of SetInit is
begin
	process(clk,time_state,sel,set,confirm)
		variable time_sel : std_logic := '0' ;
		variable a , b , c , d : integer :=0  ;
		variable bit_sel       : integer :=0  ;
	begin
		if rising_edge( clk )
		then 
			if time_state = '1'   --´¦ÓÚÉèÖÃÄ£Ê½
			then
				if time_sel = '0' then
					time_sel := '1';
					timesel<='1';
				elsif time_sel = '1' then
					time_sel := '0';
					timesel<='0';
				end if;
			end if;
			if time_sel = '1' then
				if (sel = '1') and (bit_sel < 3)  --Î»Ñ¡
				then
					bit_sel := bit_sel + 1;
					elsif (sel = '1' )and (bit_sel = 3)
					then 
						bit_sel := 0;
					else bit_sel := bit_sel;
				end if;
				if set = '1'   --+1
				then
					case (bit_sel) is  -- ËÄÎ»·Ö±ğ¼ÓÖµ
						when 0 =>     --00:00µÚËÄÎ»
							if d < 9
							then
								d := d + 1;
								elsif d = 9
								then
									d := 0;
							end if;
						when 1 =>    --00:00µÚÈıÎ
							if c <5
							then 
								c := c + 1;
								elsif c = 5
								then 
									c := 0;
							end if;
						when 2 =>    --00:00¶şÎ»
							if ((a < 2) and (b  < 9))
							then
								b := b + 1;
								elsif ((a < 2) and (b = 9))
								then
									b := 0;
							end if;
							if ((a = 2) and (b <4))
							then
								b := b + 1;
								elsif ((a = 2) and (b =4))
								then 
									b := 0;
							end if;
						when 3 =>   --00:00µÚÒ»Î»
							if a < 2
							then 
								a := a +1;
								elsif (a = 2)
								then
									a := 0 ;
							end if;
						when others =>
							null;
					end case;
				end if;
			end if ;
			hour_s <= a;
			hour_f <= b;
			min_s  <= c;
			min_f  <= d;
			if ( confirm = '1' )  --ÍË³öÉèÖÃÄ£Ê½£¬Î»Ñ¡¸´Î»£¬Ê±¼ä²»±ä
			then
				bit_sel := 0;
				time_sel := '0';
				timesel<='0';
			end if;
		end if;
	end process;
end set;