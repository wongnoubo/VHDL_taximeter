--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity delay is
	port
	(
	--声明ce为逻辑输入，作为使能，输入1有效
	ce	: in std_logic;
	--声明clk为逻辑输入，作为数据输入
	clk	: in std_logic;
	--声明load为逻辑输入，作为清零信号
	load: in std_logic;
	--高低速判断输入信号
	cein:in std_logic;
	--声明ceout为逻辑输出，停车一分钟脉冲输出
	ceout	: out std_logic;
	--十分钟起步价
	tenout : out std_logic
	);
--结束主体
end delay;

--声明一个构造体
architecture one of delay is
begin
	process(ce,clk,cein) 
	variable time:integer range 0 to 601:=0;
	variable ten:integer range 0 to 11:=0;
	begin
		if load='0' then
			if ce='1' then
				if clk='1' and clk'event then
					if cein='0' then--计时计价
						if time < 600 then
							time:=time+1;
							ceout<='0';
						else
							time:=0;
							ten:=ten+1;
							ceout<='1';
						end if;
						if ten < 10 then
							tenout<='0';
						else
							tenout<='1';
							ten:=11;
						end if;
					end if;
				end if;
			end if;
		else
			time:=0;
			ten:=0;
			ceout<='0';
			tenout<='0';
		end if;
	end process;
end one;
