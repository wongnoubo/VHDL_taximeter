	--调用各个头文件
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--开始主体
	entity ss is
		port
		(
		--声明din为逻辑输入，作用是输入时钟信号
		--声明load为逻辑输入，作用是清零
		start	: in std_logic;
		ce,load	: out std_logic
		);
	--结束主体
	end ss;
	--声明构造体one
	architecture one of ss is
	begin
	--声明进程
	process(start)
		begin
		--结束进程	--当使能输入为1，程序正常进行
		load<=start and '1';
		ce<=start xor '1';
		end process;
	--结束构造体
	end one;
