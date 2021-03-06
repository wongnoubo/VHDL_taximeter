library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity settime is
	port
		(
			--声明ce为逻辑输入，作为使能，输入1有效
			ce : in std_logic;
			--声明clk为逻辑输入，作为数据输入
			clk :  in std_logic;
			--声明load为逻辑输入，作为清零信号
			load : in std_logic;
			--出租车司机设置的时钟初始值，即当前时间
			hour_s , hour_f , min_s , min_f  : in integer range 0 to 9 ;
			--输出设置时间,以分表示,最大为1439
			settime :  out std_logic_vector(10 downto 0)
	);
end settime;

architecture time of settime is
	component mult10b
		port ( d1 , d2 : in std_logic_vector (9 downto 0);
			   q : out std_logic_vector ( 19 downto 0)
		);
	end component;
	--将初始时间的integer转化为std_logic_vector
	signal a , b , c , d : std_logic_vector(9 downto 0);
	--中间值
	signal mul1 , mul2 , mul3 : std_logic_vector(19 downto 0);
	-- 计算结果
	signal transition : std_logic_vector(19 downto 0);
	signal ten : std_logic_vector(9 downto 0) := "0000001010";
	signal sixty : std_logic_vector(9 downto 0) := "0000111100";
	signal six_hundreds : std_logic_vector(9 downto 0) := "1001011000";
begin
	--将初始时间的integer转化为std_logic_vector
	a <= conv_std_logic_vector (hour_s , 10);
	b <= conv_std_logic_vector (hour_f , 10);
	c <= conv_std_logic_vector (min_s  , 10);
	d <= conv_std_logic_vector (min_f  , 10);
	--将小时转化为分钟
	u25_2 : mult10b 	
		port map (q => mul1 , d1 => c , d2 => ten);
	u25_3 : mult10b 
		port map (q => mul2 , d1 => b , d2 => sixty);
	u25_4 : mult10b 
		port map (q => mul3 , d1 => a , d2 => six_hundreds );
	--累加得出分钟数
	process(clk , d , mul1 , mul2 , mul3)
	begin
		if clk'event and clk='1' then 
			transition <= (d + mul1 + mul2 + mul3) ;
			settime(10 downto 0) <= transition(10 downto 0);
		end if;
	end process;
end time;