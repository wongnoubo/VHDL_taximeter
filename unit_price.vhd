--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--起步价外计价
entity unit_price is
	--generic(
				--day_starting_price : integer range 0 to 200 := 100;		--白天起步价
				--night_starting_price : integer range 0 to 200 := 120;		--夜晚起步价
				--day_mileage_price : integer range 0 to 100 := 30;			--白天普通里程价格
				--day_timing_price : integer range 0 to 100 := 30;			--白天计时计价
				--day_long_distance_price : integer range 0 to 100 := 40	--白天长途计价
				--night_mileage_price :integer range 0 to 100 := 40;
				--夜间计时单价
				--night_timing_price :integer range 0 to 100 := 40;
				--夜间长途单价
				--night_long_distance_price : integer range 0 to 100 := 50
	--);
		port(
				st : in std_logic;
				load : in std_logic;
				--night drive
				night : in std_logic;
				--每公里脉冲
				dp : in std_logic;
				--时钟脉冲
				clk : in std_logic;
				--远程脉冲
				yuancheng : in std_logic;
				--每分钟脉冲
				minin : in std_logic;
				--夜间里程单价
				--night_mileage_price : in integer range 0 to 100 := day_mileage_price + 10;
				--夜间计时单价
				--night_timing_price : in integer range 0 to 100 := day_timing_price + 10;
				--夜间长途单价
				--night_long_distance_price : in integer range 0 to 100 := day_long_distance_price + 10;
				--输入状态机判断的计价状态
				state_pricing : in integer range 1 to 4;
				--车费
				total_price : out integer range 0 to 10000;
				day_starting_price :in integer range 0 to 200;		--白天起步价
				night_starting_price :in integer range 0 to 200;		--夜晚起步价
				day_mileage_price :in integer range 0 to 100;			--白天普通里程价格
				day_timing_price :in integer range 0 to 100;			--白天计时计价
				day_long_distance_price :in integer range 0 to 100	--白天长途计价
	);
end entity unit_price;

architecture unit of unit_price is
	signal mileage_price_sum : integer range 0 to 10000;
	signal timing_price_sum : integer range 0 to 10000;
begin
	process ( night , dp , clk, yuancheng ,  minin , state_pricing , load, state_pricing,day_starting_price,night_starting_price,day_mileage_price,day_timing_price,day_long_distance_price)
	variable night_mileage_price :integer range 0 to 100 := 40;
	variable night_timing_price :integer range 0 to 100 := 40;
	variable night_long_distance_price : integer range 0 to 100 := 50;
	begin
		if clk='1' and clk'event then
				night_mileage_price := day_mileage_price + 10;
				--夜间计时单价
				night_timing_price := day_timing_price + 10;
				--夜间长途单价
				night_long_distance_price := day_long_distance_price + 10;
			if state_pricing = 1 and load = '1' then    --总价复位为0
				total_price <= 0;
				mileage_price_sum <= 0 ;
				timing_price_sum <=0 ;
			end if;
			if state_pricing = 3 then
				if night = '1' then
					if dp = '1' then
						if yuancheng = '1' then
							mileage_price_sum <= mileage_price_sum + night_long_distance_price ; --夜间远程计价
						elsif yuancheng = '0' then
							mileage_price_sum <= mileage_price_sum + night_mileage_price ; --夜间普通计价
						end if;
					end if;
					if minin = '1' then
						timing_price_sum <= timing_price_sum + night_timing_price;--夜晚计时计价
					end if;
				total_price <= mileage_price_sum + timing_price_sum + night_starting_price;
				elsif night = '0' then
					if dp = '1' then
						if yuancheng='1' then
							mileage_price_sum <= mileage_price_sum + day_long_distance_price ;--白天远程
						elsif yuancheng = '0' then
							mileage_price_sum <=  mileage_price_sum + day_mileage_price ;--白天普通
						end if;
					end if;
					if minin = '1' then
						timing_price_sum <= timing_price_sum + day_timing_price;  --白天计时计价
					end if;
				total_price <= mileage_price_sum + timing_price_sum + day_starting_price;
				end if;
			end if;
		end if;
	end process;
end unit;