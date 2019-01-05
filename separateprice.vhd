--将车票价格按照个十百千依次分开
--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity separateprice is
	port
	(
	clk,ce,load	: in std_logic;
	total : in integer range 0 to 10000;
	dout : out std_logic;
	ge,shi,bai,qian,wan:out std_logic_vector(3 downto 0)
	);
--结束主体
end separateprice;
--声明构造体one
architecture one of separateprice is
begin
--价格的进制转换
process(clk,total)
	--声明一个10位变量q
	variable comb:integer range 0 to 10001;
	variable comba,combb,combc,combd,combe:std_logic_vector(3 downto 0);
	begin
	--当没有清零信号输入，程序正常进行
	if load='0'then
		--当使能输入为1，程序正常进行
		if ce='1' then
			--输入din为上升沿时，执行下面程序
			if clk'event and clk='1' then
				if comb < total then 
					if(comba=9 and combb=9 and combc=9)then
						comba:="0000";
						combb:="0000";
						combc:="0000";
						combd:=combd+1;
						comb:=comb+1;
					elsif(comba=9 and combb=9)then
						comba:="0000";
						combb:="0000";
						combc:=combc+1;
						comb:=comb+1;
					elsif(comba=9 and combb=9 and combc=9 and combd=9) then
						comba:="0000";
						combb:="0000";
						combc:="0000";
						combd:="0000";
						combe:=combe+1;
						comb:=comb+1;
					elsif(comba=9) then
						comba:="0000";
						combb:=combb+1;
						comb:=comb+1;
					else
						comba:=comba+1;
						comb:=comb+1;
					end if;
				else
					shi<=combb;
					ge<=comba;
					bai<=combc;
					qian<=combd;
					wan<=combe;
					comb:=total;
				end if;
			end if;
		end if;	
	--有清零信号
	else
	--数值清零
		comb:=0;
		comba:="0000";
		combb:="0000";
		combc:="0000";
		combd:="0000";
		combe:="0000";
		shi<="0000";
		ge<="0000";
		bai<="0000";
		qian<="0000";
		wan<="0000";
	end if;
	--结束进程
	end process;
--结束构造体
end one;
