--将运行时间分离到单个位
--150=>2:30
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity separatetime is
	port
	(
	clk,ce,load	: in std_logic;
	totaltime : in integer range 0 to 1440;
	ffen,sfen,fh,sh:out std_logic_vector(3 downto 0)
	);
--结束主体
end separatetime;
--声明构造体one
architecture one of separatetime is
begin
--价格的进制转换
process(clk,totaltime)
	--声明一个10位变量q
	variable comb:integer range 0 to 1441;
	variable comba,combb,combc,combd:std_logic_vector(3 downto 0);
	begin
	--当没有清零信号输入，程序正常进行
	if load='0'then
		--当使能输入为1，程序正常进行
		if ce='1' then
			--输入din为上升沿时，执行下面程序
			if clk'event and clk='1' then
				if comb < totaltime then 
					if(comba=9 and combb=5 and combc=9)then
						comba:="0000";
						combb:="0000";
						combc:="0000";
						combd:=combd+1;
						comb:=comb+1;
					elsif(comba=9 and combb=5)then
						comba:="0000";
						combb:="0000";
						combc:=combc+1;
						comb:=comb+1;
					elsif(comba=9 and combb=5 and combc=9 and combd=5) then
						comba:="0000";
						combb:="0000";
						combc:="0000";
						combd:="0000";
						comb:=comb;
					elsif(comba=9) then
						comba:="0000";
						combb:=combb+1;
						comb:=comb+1;
					else
						comba:=comba+1;
						comb:=comb+1;
					end if;
				else
					sfen<=combb;
					ffen<=comba;
					fh<=combc;
					sh<=combd;
					comb:=totaltime;
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
		sfen<="0000";
		ffen<="0000";
		sh<="0000";
	end if;
	--结束进程
	end process;
--结束构造体
end one;
