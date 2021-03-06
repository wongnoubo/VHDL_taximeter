	--调用各个头文件
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--开始主体
	entity or2total is
		port
		(
		--声明din为逻辑输入，作用是输入时钟信号
		--声明load为逻辑输入，作用是清零
		ce : in std_logic;
		pricesel : in integer;--价格位置选择
		total1	: in integer range 0 to 9999;--起步价外计价
		total2	: in integer range 0 to 9999;--起步价内计价
		price : in integer range 0 to 9999;--设置价格计价
		total	: out integer range 0 to 9999
		);
	--结束主体
	end or2total;
	--声明构造体one
	architecture one of or2total is
		begin
	process(ce,total1,total2)
		begin
		if ce='1' then
			if total1>0 and total2=0 and pricesel=0 then
				total<=total1;
			elsif total1=0 and total2>0 and pricesel=0 then
				total<=total2;
			elsif pricesel>0 then
				total<=price;
			end if;
		end if;
		end process;
	--结束构造体
	end one;
