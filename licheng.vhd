--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--开始主体dp
entity licheng is
	
	port
	(
		--声明ce为逻辑输入，作用是使能，输入1有效，从高低速判断模块接入
		ce:in std_logic;
		--声明clk为逻辑输入，作用是输入时钟
		clk:in std_logic;
		--声明din为逻辑输入，作用是输入车轮码盘产生的速度脉冲
		din:in std_logic;
		--声明dp为逻辑输出，作用是输出判断信号，输出0代表车辆正常行进，输出1代表车辆停止
		load:in std_logic;
		--高低速判断输入信号
		cein:in std_logic;
		--每公里脉冲'1'->1km
		dp:out std_logic;
		--起步2.5km判断脉冲'0'->不足2.5km;'1'->2.5km以上
		qibu:out std_logic;
		--远程12km判断脉冲'0'->不足12km;'1'->12km以上
		yuancheng:out std_logic
	);
	--结束主体
	end entity licheng;
	--声明一个构造体
	architecture one of licheng is
		--声明一个信号dp_test，测试时用
		--signal dp_test  : std_logic;	
		signal flag : integer range 0 to 1:=0;
	begin
		--声明一个进程
		process(clk,din,cein)
		--声明一个变量run
		variable run : std_logic_vector(12 downto 0):="0000000000000";
		--声明一个变量twofive，起步信号判断
		variable twofive : std_logic_vector(2 downto 0):=(others=>'0');
		variable twenty : std_logic_vector(3 downto 0):=(others=>'0');
			begin	
			if load='0' then
				--当ce为1时，执行下面程序
				if ce='1' then
					--当clk为上升沿时执行下面程序
					if clk'event and clk='1' then
						if flag=0 then--起步状态下里程计数不受到高低速状态的影响
							if din='1' then
								--不足500m
								if run < 250 then
									run:=run+1;
									dp<='0';
								else
									--正好500m
									if run=250 then
										twofive:=twofive+1;
									end if;
									if run<500 then--
										run:=run+1;
										dp<='0';
									else
										twofive:=twofive+1;
										dp<='1';
										twenty:=twenty+1;
										run:="0000000000000";
									end if;
								end if;
							end if;
							if twenty < 12 then
								yuancheng<='0';
							else
								yuancheng<='1';
								--13
								twenty:="1101";
							end if;
							--判断是否到达起步里程
							if twofive < 4 then
								qibu<='0';
							else
								qibu<='1';
								flag<=1;
								dp<='1';
								--5
								twofive:="101";
							end if;
						end if;
						if cein='1' and flag=1 then--高速状态下进行里程计价
							if din='1' then
								--不足500m
								if run < 250 then
									run:=run+1;
									dp<='0';
								else
									--正好500m
									if run=250 then
										twofive:=twofive+1;
									end if;
									if run<500 then
										run:=run+1;
										dp<='0';
									else
										twofive:=twofive+1;
										dp<='1';
										twenty:=twenty+1;
										run:="0000000000000";
									end if;
								end if;
							end if;
							if twenty < 12 then
								yuancheng<='0';
							else
								yuancheng<='1';
								--13
								twenty:="1101";
							end if;
							--判断是否到达起步里程
							if twofive < 4 then
								qibu<='0';
							else
								qibu<='1';
								flag<=1;
								--5
								twofive:="101";
							end if;
						end if;
					end if;
				end if;
			else
				qibu<='0';
				yuancheng<='0';
				run:="0000000000000";
				twofive:=(others=>'0');
				twenty:=(others=>'0');
				dp<='0';
				flag<=1;
			end if;
		--结束仅存
		end process;
	--结束构造体
	end architecture one;
