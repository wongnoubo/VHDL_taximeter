	--调用各个头文件
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_arith.all;
	--开始主体
	entity or2time is
		port
		(
		--声明din为逻辑输入，作用是输入时钟信号
		--声明load为逻辑输入，作用是清零
		ce : in std_logic;
		timesel : in std_logic;--时间设置标志
		ffen,sfen,fh,sh:in std_logic_vector(3 downto 0);--出租车行驶时间显示
		vffen,vsfen,vfh,vsh:in integer range 0 to 9; --设置时间输入
		rffen,rsfen,rfh,rsh:out std_logic_vector(3 downto 0)
		);
	--结束主体
	end or2time;
	--声明构造体one
	architecture one of or2time is
	signal vffentemp,vsfentemp,vfhtemp,vshtemp:integer range 0 to 9;
	signal rffentemp,rsfentemp,rfhtemp,rshtemp:std_logic_vector(3 downto 0);
		begin 
	process(ce,ffen,sfen,fh,sh,vffen,vsfen,vfh,vsh)
		begin
		if ce='1' then
			vffentemp<=vffen;
			vsfentemp<=vsfen;
			vfhtemp<=vfh;
			vshtemp<=vsh;
			if timesel='1' then --设置状态
				rffentemp<=conv_std_logic_vector(vffentemp,4);
				rsfentemp<=conv_std_logic_vector(vsfentemp,4);
				rfhtemp<=conv_std_logic_vector(vfhtemp,4);
				rshtemp<=conv_std_logic_vector(vshtemp,4);
				rffen<=rffentemp;
				rsfen<=rsfentemp;
				rfh<=rfhtemp;
				rsh<=rshtemp;
			else
				rffen<=ffen;
				rsfen<=sfen;
				rfh<=fh;
				rsh<=sh;
			end if;
		end if;
		end process;
	--结束构造体
	end one;
