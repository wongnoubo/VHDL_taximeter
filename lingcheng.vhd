--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity lingcheng is
	port
	(
	--声明clk为逻辑输入，作为数据输入
	clk	: in std_logic;
	--声明load为逻辑输入，作为清零信号
	timesel : in std_logic;--时间设置模式
	settime : in std_logic_vector(10 downto 0);
	--声明ceout为逻辑输出，作为判断结果输出
	ceout : out std_logic
	);
--结束主体
end lingcheng;

--声明一个构造体
architecture one of lingcheng is
begin
--声明一个进程
process(clk,settime)
	--声明一个变量dintest
	variable time:integer range 0 to 61;
	variable mins:std_logic_vector(10 downto 0):=(others=>'0');
	begin
	--没有清零信号，程序正常进行
	--clk出现上升沿，执行下面程序
	if clk'event and clk='1' then 
		if timesel='1' then
			mins:=settime;
		end if;
		if time< 60 then 
			--计数加一
			time:=time + 1;
		else
			time:=0;
			mins:=mins+1;
		end if;
		--6h
		if mins < 360 then
			ceout<='1';
		--23h
		elsif mins > 1380 and mins < 1441 then
			ceout<='1';
			--输出为0，让后面的计数器先不要计数
		elsif mins > 1440 then
			time:=0;
			mins:=(others=>'0');
			--输出1，起步价结束，后面的计数器计数开始
		else
		--6h-23h
			ceout<='0';
		end if;
	end if;
	--结束进程
	end process;
--结束构造体
end one;