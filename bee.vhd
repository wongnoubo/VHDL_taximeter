	--调用各个头文件
	--计价蜂鸣器
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--开始主体
	entity bee is
		port
		(
		ce : in std_logic;
		qibu : in std_logic;--起步信号
		run_pulse : in std_logic;--里程脉冲
		wait_pulse : in std_logic;--等待时间脉冲
		bee_pulse : out std_logic--蜂鸣器脉冲
		);
	--结束主体
	end bee;
	--声明构造体one
	architecture one of bee is
		begin
	process(ce,run_pulse,wait_pulse,qibu)
		begin
		if ce='1' then
			if qibu='1' then 
				if run_pulse='1' then 
					bee_pulse<='1';
				elsif wait_pulse='1' then
					bee_pulse<='1';
				else
					bee_pulse<='0';
				end if;
			else
				bee_pulse<='0';
			end if;
		end if;
		end process;
	--结束构造体
	end one;
