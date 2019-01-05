	--调用各个头文件
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--开始主体
	entity or5price is
		port
		(
		ce : in std_logic;
		pricesel : in integer;
		day_starting_price :in integer range 0 to 9999;--白天起步价
		night_starting_price :in integer range 0 to 9999;--夜晚起步价
		day_mileage_price:in integer range 0 to 9999;--白天普通里程价格
		day_timing_price :in integer range 0 to 9999;--白天计时计价
		day_long_distance_price :in integer range 0 to 9999;  --白天长途
		price	: out integer range 0 to 9999
		);
	--结束主体
	end or5price;
	--声明构造体one
	architecture one of or5price is
		begin
	process(ce,day_starting_price,night_starting_price,day_mileage_price,day_timing_price,day_long_distance_price)
		begin
		if ce='1' then
			if pricesel=1 then--1 是显示白天起步价
				price<=day_starting_price;
			elsif pricesel=2 then--2 是夜晚起步价
				price<=night_starting_price;
			elsif pricesel=3 then--3 是白天里程
				price<=day_mileage_price;
			elsif pricesel=4 then--4 是 白天计时
				price<=day_timing_price;
			elsif pricesel=5 then--5 是白天长途
				price<=day_long_distance_price;
			end if;
		end if;
		end process;
	--结束构造体
	end one;
