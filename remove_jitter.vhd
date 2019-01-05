--按键消抖
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--消除抖动
entity remove_jitter is
	port
	(
		--声明ce为逻辑输入，作为使能，输入1有效
		ce	: in std_logic;
		--声明clk为逻辑输入，作为数据输入
		clk	: in std_logic;
		--声明load为逻辑输入，作为清零信号
		load : in std_logic;
		--按键输入，每次只有一个按键按下
		key_in	: in std_logic;
		--消抖后的按键信号
		key_out	: out std_logic
	);
end remove_jitter;

architecture bhv of remove_jitter is
	--需达到两个时钟周期
	signal N : integer := 2;
	--计数器
	signal count : integer range 0 to 9;
begin
	process ( clk , key_in )
	begin
		if ( clk'event and clk = '1')
		then
			--有按键按下
			if ( key_in = '1' )
			then
				--循环,计算持续几个脉冲周期
				if ( count = N )
				then 
					count <= count ;
				else 
					count <= count + 1;
				end if;
				--若持续两个脉冲周期，则判断按下
				if ( count = N - 1)
				then
					key_out <= '0';
				else 
					key_out <= '1';
				end if;
			else 
				count <= 0;
			end if;
		end if;
	end process;
end bhv;
				