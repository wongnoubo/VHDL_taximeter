--数码管显示时间
--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体
entity displaytime is
	port
	(
	--声明din为逻辑输入，作用是输入时钟信号
	--声明ce为逻辑输入，作用是使能，输入1时有效
	--声明load为逻辑输入，作用是清零
	load,ce:in std_logic;
	clk	: in std_logic;
	ffen,sfen,fh,sh:in std_logic_vector(3 downto 0);
	--段选
	sel:out std_logic_vector(2 downto 0);
	--位选
	outp:out std_logic_vector(7 downto 0)
	);
--结束主体
end displaytime;
--声明构造体one
architecture one of displaytime is
begin
--声明进程
process(ffen,sfen,fh,sh,ce,clk)
	variable sell:std_logic_vector(2 downto 0);
	variable temp:std_logic_vector(3 downto 0);
	variable fhflag:std_logic:='0';--第一个小时
	variable sfenflag:std_logic:='0';--第二个分钟
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
						temp:=ffen;--00:0x
					when "001" =>
						sell:="010";--00:x0倒着显示
						temp:=sfen;
						sfenflag:='1';
					when "010" =>
						sell:="100";--0x:00
						temp:=fh;
						fhflag:='1';
					when "100" =>
						sell:="000";
						temp:=sh;--x0:00
					when others =>
						null;
				end case;
				if fhflag='0' and sfenflag='0' then--正常显示不带小数点
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
				elsif fhflag='1' then--正常显示带着小数点
					fhflag:='0';
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
				elsif sfenflag='1' then
					sfenflag:='0';--倒着显示带小数点
					case temp is
						when"0000"=>outp<="10111111";--0
						when"0001"=>outp<="10110000";--1
						when"0010"=>outp<="11011011";--2
						when"0011"=>outp<="11110011";--3
						when"0100"=>outp<="11110100";--4
						when"0101"=>outp<="11101101";--5
						when"0110"=>outp<="11101111";--6
						when"0111"=>outp<="10111000";--7
						when"1000"=>outp<="11111111";--8
						when"1001"=>outp<="11111101";--9
						when others=>outp<=null;
					end case;
					sel<=sell;
				end if;
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