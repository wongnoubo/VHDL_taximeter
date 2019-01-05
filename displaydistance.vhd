--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity displaydistance is
	port
	(
	--声明din为逻辑输入，作用是输入时钟信号
	--声明ce为逻辑输入，作用是使能，输入1时有效
	--声明load为逻辑输入，作用是清零
	load,ce:in std_logic;
	clk	: in std_logic;
	ge,shi,bai,qian:in std_logic_vector(3 downto 0);
	--段选
	sel:out std_logic_vector(2 downto 0);
	--位选
	outp:out std_logic_vector(7 downto 0)
	);
--结束主体
end displaydistance;
--声明构造体one
architecture one of displaydistance is
begin
--声明进程
process(ge,shi,bai,qian,ce,clk)
	variable sell:std_logic_vector(2 downto 0);
	variable temp:std_logic_vector(3 downto 0);
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
						temp:=ge;
					when "001" =>
						sell:="010";
						temp:=shi;
					when "010" =>
						sell:="100";
						temp:=bai;
					when "100" =>
						sell:="000";
						temp:=qian;
					when others =>
						null;
				end case;
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
		end if;	
	--有清零信号
	else
		--显示默认内容
		outp<="00111111";
		 sell:=(others=>'0');
	end if;
	--结束进程
	end process;
--结束构造体
end one;