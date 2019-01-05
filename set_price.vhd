--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--Set the initial price
entity set_price is
	port(
			clk       : in std_logic;  --ʱ��
			price_state : in std_logic;  --����ģʽ����
			sel , set : in std_logic;  --ѡ��λ��+1
			confirm : in std_logic;  --ȷ��
			day_starting_price_j , day_starting_price_y , day_starting_price_t , day_starting_price_h : out integer range 0 to 9 ;		--�����𲽼�
			night_starting_price_j , night_starting_price_y , night_starting_price_t , night_starting_price_h : out integer range 0 to 9 ;		--ҹ���𲽼�
			day_mileage_price_j , day_mileage_price_y , day_mileage_price_t , day_mileage_price_h  : out integer range 0 to 9 ;			--������ͨ��̼۸�
			day_timing_price_j , day_timing_price_y , day_timing_price_t , day_timing_price_h  : out integer range 0 to 9 ;			--�����ʱ�Ƽ�
			day_long_distance_price_j , day_long_distance_price_y , day_long_distance_price_t , day_long_distance_price_h  : out integer range 0 to 9;	--���쳤;�Ƽ�
			pricesel : out integer
	);
end entity set_price;

architecture price of set_price is
begin
	process(clk , price_state , sel , set , confirm )
		variable price_sel : integer  := 0 ;
		variable day_starting_price_jiao , day_starting_price_yuan , day_starting_price_ten , day_starting_price_hundred : integer  := 0;
		variable night_starting_price_jiao , night_starting_price_yuan , night_starting_price_ten , night_starting_price_hundred : integer  := 0;
		variable day_mileage_price_jiao , day_mileage_price_yuan , day_mileage_price_ten , day_mileage_price_hundred : integer  := 0;
		variable day_timing_price_jiao , day_timing_price_yuan , day_timing_price_ten , day_timing_price_hundred : integer  := 0;
		variable day_long_distance_price_jiao , day_long_distance_price_yuan , day_long_distance_price_ten , day_long_distance_price_hundred : integer  := 0;
		variable bit_sel     : integer   := 0;
	begin
		if rising_edge( clk ) then 
			if price_state = '1' and price_sel <5 then
				price_sel := price_sel + 1;
				pricesel<=price_sel;
			elsif price_state = '1' and price_sel =5 then
				price_sel := 1;
				pricesel<=price_sel;
			end if;
			case price_sel is
				when 1 =>
					bit_sel := 0;
					if (sel = '1') and (bit_sel < 3)  --λѡ
					then
						bit_sel := bit_sel + 1;
						elsif (sel = '1' )and (bit_sel = 3)
						then 
							bit_sel := 0;
						else bit_sel := bit_sel;
					end if;
					if set = '1'   --+1
					then
						case bit_sel is
							when 0 =>
								if( day_starting_price_jiao < 9 ) then
									day_starting_price_jiao := day_starting_price_jiao +1;
								elsif (day_starting_price_jiao = 9) then
									day_starting_price_jiao := 0;
								end if;
							when 1 =>
								if( day_starting_price_yuan < 9 ) then
									day_starting_price_yuan := day_starting_price_yuan +1;
								elsif (day_starting_price_yuan = 9) then
									day_starting_price_yuan := 0;
								end if;
							when 2 =>
								if( day_starting_price_ten < 9 ) then
									day_starting_price_ten := day_starting_price_ten +1;
								elsif (day_starting_price_ten = 9) then
									day_starting_price_ten := 0;
								end if;
							when 3 =>
								if( day_starting_price_hundred < 9 ) then
									day_starting_price_hundred := day_starting_price_hundred +1;
								elsif (day_starting_price_hundred = 9) then
									day_starting_price_hundred := 0;
								end if;
							when others =>
								null;
						end case;
					end if;
				when 2 =>
					bit_sel := 0;
					if (sel = '1') and (bit_sel < 3)  --λѡ
					then
						bit_sel := bit_sel + 1;
						elsif (sel = '1' )and (bit_sel = 3)
						then 
							bit_sel := 0;
						else bit_sel := bit_sel;
					end if;
					if set = '1'   --+1
					then
						case bit_sel is
							when 0 =>
								if( night_starting_price_jiao < 9 ) then
									night_starting_price_jiao := night_starting_price_jiao +1;
								elsif (night_starting_price_jiao = 9) then
									night_starting_price_jiao := 0;
								end if;
							when 1 =>
								if( night_starting_price_yuan < 9 ) then
									night_starting_price_yuan := night_starting_price_yuan +1;
								elsif (night_starting_price_yuan = 9) then
									night_starting_price_yuan := 0;
								end if;
							when 2 =>
								if( night_starting_price_ten < 9 ) then
									night_starting_price_ten := night_starting_price_ten +1;
								elsif (night_starting_price_ten = 9) then
									night_starting_price_ten := 0;
								end if;
							when 3 =>
								if( night_starting_price_hundred < 9 ) then
									night_starting_price_hundred := night_starting_price_hundred +1;
								elsif (night_starting_price_hundred = 9) then
									night_starting_price_hundred := 0;
								end if;
							when others =>
								null;
						end case;
					end if;
				when 3 =>
					bit_sel := 0;
					if (sel = '1') and (bit_sel < 3)  --λѡ
					then
						bit_sel := bit_sel + 1;
						elsif (sel = '1' )and (bit_sel = 3)
						then 
							bit_sel := 0;
						else bit_sel := bit_sel;
					end if;
					if set = '1'   --+1
					then
						case bit_sel is
							when 0 =>
								if( day_mileage_price_jiao < 9 ) then
									day_mileage_price_jiao := day_mileage_price_jiao +1;
								elsif (day_mileage_price_jiao = 9) then
									day_mileage_price_jiao := 0;
								end if;
							when 1 =>
								if( day_mileage_price_yuan < 9 ) then
									day_mileage_price_yuan := day_mileage_price_yuan +1;
								elsif (day_mileage_price_yuan = 9) then
									day_mileage_price_yuan := 0;
								end if;
							when 2 =>
								if( day_mileage_price_ten < 9 ) then
									day_mileage_price_ten := day_mileage_price_ten +1;
								elsif (day_mileage_price_ten = 9) then
									day_mileage_price_ten := 0;
								end if;
							when 3 =>
								if( day_mileage_price_hundred < 9 ) then
									day_mileage_price_hundred := day_mileage_price_hundred +1;
								elsif (day_mileage_price_hundred = 9) then
									day_mileage_price_hundred := 0;
								end if;
							when others =>
								null;
						end case;
					end if;
				when 4 =>
					bit_sel := 0;
					if (sel = '1') and (bit_sel < 3)  --λѡ
					then
						bit_sel := bit_sel + 1;
						elsif (sel = '1' )and (bit_sel = 3)
						then 
							bit_sel := 0;
						else bit_sel := bit_sel;
					end if;
					if set = '1'   --+1
					then
						case bit_sel is
							when 0 =>
								if( day_timing_price_jiao < 9 ) then
									day_timing_price_jiao := day_timing_price_jiao +1;
								elsif (day_timing_price_jiao = 9) then
									day_timing_price_jiao := 0;
								end if;
							when 1 =>
								if( day_timing_price_yuan < 9 ) then
									day_timing_price_yuan := day_timing_price_yuan +1;
								elsif (day_timing_price_yuan = 9) then
									day_timing_price_yuan := 0;
								end if;
							when 2 =>
								if( day_timing_price_ten < 9 ) then
									day_timing_price_ten := day_timing_price_ten +1;
								elsif (day_timing_price_ten = 9) then
									day_timing_price_ten := 0;
								end if;
							when 3 =>
								if( day_timing_price_hundred < 9 ) then
									day_timing_price_hundred := day_timing_price_hundred +1;
								elsif (day_timing_price_hundred = 9) then
									day_timing_price_hundred := 0;
								end if;
							when others =>
								null;
						end case;
					end if;
				when 5 =>
					bit_sel := 0;
					if (sel = '1') and (bit_sel < 3)  --λѡ
					then
						bit_sel := bit_sel + 1;
						elsif (sel = '1' )and (bit_sel = 3)
						then 
							bit_sel := 0;
						else bit_sel := bit_sel;
					end if;
					if set = '1'   --+1
					then
						case bit_sel is
							when 0 =>
								if( day_long_distance_price_jiao < 9 ) then
									day_long_distance_price_jiao := day_long_distance_price_jiao +1;
								elsif (day_long_distance_price_jiao = 9) then
									day_long_distance_price_jiao := 0;
								end if;
							when 1 =>
								if( day_long_distance_price_yuan < 9 ) then
									day_long_distance_price_yuan := day_long_distance_price_yuan +1;
								elsif (day_long_distance_price_yuan = 9) then
									day_long_distance_price_yuan := 0;
								end if;
							when 2 =>
								if( day_long_distance_price_ten < 9 ) then
									day_long_distance_price_ten := day_long_distance_price_ten +1;
								elsif (day_long_distance_price_ten = 9) then
									day_long_distance_price_ten := 0;
								end if;
							when 3 =>
								if( day_long_distance_price_hundred < 9 ) then
									day_long_distance_price_hundred := day_long_distance_price_hundred +1;
								elsif (day_long_distance_price_hundred = 9) then
									day_long_distance_price_hundred := 0;
								end if;
							when others =>
								null;
						end case;
					end if;
				when others =>
					bit_sel := 0;
					price_sel := 0;
					pricesel<=0;
			end case;
			day_starting_price_j <= day_starting_price_jiao ;
			day_starting_price_y <= day_starting_price_yuan ;
			day_starting_price_t <= day_starting_price_ten  ;
			day_starting_price_h <= day_starting_price_hundred;
			night_starting_price_j <= night_starting_price_jiao;
			night_starting_price_y <= night_starting_price_yuan;
			night_starting_price_t <= night_starting_price_ten;
			night_starting_price_h <= night_starting_price_hundred;
			day_mileage_price_j <= day_mileage_price_jiao;
			day_mileage_price_y <= day_mileage_price_yuan;
			day_mileage_price_t <= day_mileage_price_ten;
			day_mileage_price_h <= day_mileage_price_hundred;
			day_timing_price_j <= day_timing_price_jiao ;
			day_timing_price_y <= day_timing_price_yuan;
			day_timing_price_t <= day_timing_price_ten;
			day_timing_price_h <= day_timing_price_hundred ;
			day_long_distance_price_j <= day_long_distance_price_jiao;
			day_long_distance_price_y <= day_long_distance_price_yuan;
			day_long_distance_price_t <= day_long_distance_price_ten;
			day_long_distance_price_h  <= day_long_distance_price_hundred;
			if confirm = '1' then
				price_sel := 0;
				pricesel<=0;
			end if;
		end if;
	end process;
end price;