--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity hl is
	port
	(
	--声明ce为逻辑输入，作为使能，输入1有效
	ce	: in std_logic;
	--声明clk为逻辑输入，作为数据输入
	clk	: in std_logic;
	--声明load为逻辑输入，作为清零信号
	load: in std_logic;
	--speed's plus
	din:in std_logic;
	--声明ceout为逻辑输出，作为判断结果输出
	ceout	: out std_logic
	);
--结束主体
end hl;

--声明一个构造体
architecture one of hl is
begin
	process(ce,clk,din) 
	variable time:integer range 0 to 24:=0;
	begin
		if load='0' then
			if ce='1' then
				if clk='1' and clk'event then
					if time < 21 then
						time:=time+1;
					else
						time:=21;
					end if;
				end if;
				if din='1' then
					time:=0;
				end if;
				if time>20 then
					ceout<='0';
				else
					ceout<='1';
				end if;
			end if;
		else
			time:=0;
			ceout<='0';
		end if;
	end process;
end one;
