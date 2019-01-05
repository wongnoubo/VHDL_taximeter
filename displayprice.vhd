--数码管显示价格
--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity displayprice is
	port
	(
	--声明din为逻辑输入，作用是输入时钟信号
	--声明ce为逻辑输入，作用是使能，输入1时有效
	--声明load为逻辑输入，作用是清零
	load,ce:in std_logic;
	clk	: in std_logic;
	a,b,c,d:in std_logic_vector(3 downto 0);
	--位选 
	sel:out std_logic_vector(2 downto 0);
	--段选
	outp:out std_logic_vector(7 downto 0)
	);
--结束主体
end displayprice;
--声明构造体one
architecture one of displayprice is
begin
--声明进程
process(a,b,c,d,ce,clk)
	variable sell:std_logic_vector(2 downto 0);
	variable temp:std_logic_vector(3 downto 0);
	variable li:integer range 0 to 1;
	begin
	--当没有清零信号输入，程序正常进行
	if load='0'then
		--当使能输入为1，程序正常进行
		if ce='1' then
			--位选
			if rising_edge(clk)  then
				case sell is
					when "000" =>
						sell:="001";
						temp:=a;
					when "001" =>
						sell:="010";
						temp:=b;
						--里程和计价小数点
						li:=1;
					when "010" =>
						sell:="100";
						temp:=c;
					when "100" =>
						sell:="000";
						temp:=d;
					when others =>
						null;
				end case;
				if li=0 then
				case temp is--段选共阴,不包括小数点
					when"0000"=>outp<="00111111";--0
					when"0001"=>outp<="00000110";--1
					when"0010"=>outp<="01011011";--2
					when"0011"=>outp<="01001111";--3
					when"0100"=>outp<="01100110";--4
					when"0101"=>outp<="01101101";--5
					when"0110"=>outp<="01111101";--6
					when"0111"=>outp<="00000111";--7
					when"1000"=>outp<="01111111";--8
					when"1001"=>outp<="01101111";--9
					when others=>outp<=null;
				end case;
				sel<=sell;
				end if;
				if li=1 then
				case temp is
					when"0000"=>outp<="10111111";--0
					when"0001"=>outp<="10000110";--1
					when"0010"=>outp<="11011011";--2
					when"0011"=>outp<="11001111";--3
					when"0100"=>outp<="11100110";--4
					when"0101"=>outp<="11101101";--5
					when"0110"=>outp<="11111101";--6
					when"0111"=>outp<="10000111";--7
					when"1000"=>outp<="11111111";--8
					when"1001"=>outp<="11101111";--9
					when others=>outp<=null;
				end case;
				sel<=sell;
				end if;
				li:=0;--里程和计价小数点
			end if;
		end if;	
	--有清零信号
	else
		--显示默认内容
		outp<="00111111";
		 sell:=(others=>'0');
		 li:=0;
	end if;
	--结束进程
	end process;
--结束构造体
end one;
