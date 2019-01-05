--统计里程脉冲总数和实际运行分钟总的脉冲
--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity countplus is
	port
	(
	--声明ce为逻辑输入，作为使能，输入1有效
	ce	: in std_logic;
	--声明load为逻辑输入，作为清零信号
	load: in std_logic;
	--脉冲
	din:in std_logic;
	--声明ceout为逻辑输出，作为判断结果输出
	total : out integer range 0 to 1440
	);
--结束主体
end countplus;

--声明一个构造体
architecture one of countplus is
begin
	process(ce,din) 
	variable comb:integer range 0 to 1440;
	begin
		if load='0' then
			if ce='1' then
				if din='1' and din'event then
					comb:=comb+1;
					total<=comb;
				end if;
			end if;
		else
			comb:=0;
			total<=0;
		end if;
	end process;
end one;
