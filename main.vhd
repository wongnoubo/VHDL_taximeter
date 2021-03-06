--调用各个头文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity main is
port
	(
		--start系统总开关，start=1启动，start=0停止
		key_start: in std_logic;
		key_time : in std_logic;--设置初始时间按键
		key_select : in std_logic;--选择位按键
		key_set : in std_logic;--按下数字+1
		key_conform : in std_logic;--确认按键
		key_price : in std_logic;--设置价格按键
		--声明clk为逻辑输入，作为数据输入
		clk	: in std_logic;
		--车轮脉冲一个表示行进2m
		wheel:in std_logic;
		seltime:out std_logic_vector(2 downto 0);--显示出租车运行总时间的数码管位选
		--位选
		outptime:out std_logic_vector(7 downto 0);--显示出租车运行总时间的数码管段选
		seldistance:out std_logic_vector(2 downto 0);--显示出租车运行总路程的数码管位选
		--位选
		outpdistance:out std_logic_vector(7 downto 0);--显示出租车运行总路程的数码管段选
		selprice:out std_logic_vector(2 downto 0);--价格段选
		outpprice:out std_logic_vector(7 downto 0);--价格位选
		bee_pulse : out std_logic--蜂鸣器
	);
end entity main;
architecture one of main is
	component ss--开始停止模块
	port(
		start: in std_logic;
		ce,load	: out std_logic
	);
	end component;
	component hl--判断高低速模块
	port
	(
		--声明ce为逻辑输入，作为使能，输入1有效
		ce	: in std_logic;
		--声明clk为逻辑输入，作为数据输入
		clk	: in std_logic;
		--声明load为逻辑输入，作为清零信号
		load: in std_logic;
		--speed's plus
		din:in std_logic;
		--声明ceout为逻辑输出，作为判断结果输出
		ceout	: out std_logic
	);
	end component;
	component drivetime --行驶时间脉冲模块
	port(
			--声明din为逻辑输入，作用是输入时钟信号
		--声明ce为逻辑输入，作用是使能，输入0时有效
		--声明load为逻辑输入，作用是清零
		din,ce,load	: in std_logic;
		--每分钟 dout='1'
		dout	: out std_logic;
		--十分钟 tenout='1'
		tenout : out std_logic
	);
	end component;
	component licheng--里程计价脉冲模块
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
	end component;
	component delay--等待时间模块
		port(
			--声明ce为逻辑输入，作为使能，输入1有效
			ce	: in std_logic;
			--声明clk为逻辑输入，作为数据输入
			clk	: in std_logic;
			--声明load为逻辑输入，作为清零信号
			load: in std_logic;
			--高低速判断输入信号
			cein:in std_logic;
			--声明ceout为逻辑输出，停车一分钟脉冲输出
			ceout	: out std_logic;
			--十分钟起步价
			tenout : out std_logic
		);
	end component;
	component total_run--总的行驶里程
	port(
		--声明ce为逻辑输入，作用是使能，输入1有效，从高低速判断模块接入
		ce:in std_logic;
		--声明clk为逻辑输入，作用是输入时钟
		clk:in std_logic;
		--声明din为逻辑输入，作用是输入车轮码盘产生的速度脉冲
		din:in std_logic;
		--声明dp为逻辑输出，作用是输出判断信号，输出0代表车辆正常行进，输出1代表车辆停止
		load:in std_logic;
		--每公里脉冲'1'->1km
		dp_total:out std_logic
	);
	end component;
	component displaytime--数码管显示时间模块
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
	end component;
	component displaydistance--数码管显示距离
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
	end component;--数码管显示距离模块
	component displayprice--数码管显示价格
		port
		(
			--声明din为逻辑输入，作用是输入时钟信号
			--声明ce为逻辑输入，作用是使能，输入1时有效
			--声明load为逻辑输入，作用是清零
			load,ce:in std_logic;
			clk	: in std_logic;
			a,b,c,d:in std_logic_vector(3 downto 0);
			--段选
			sel:out std_logic_vector(2 downto 0);
			--位选
			outp:out std_logic_vector(7 downto 0)
			);
	end component;--数码管显示价格
	component countplus--统计里程脉冲和时间脉冲
		port
		(
		--声明ce为逻辑输入，作为使能，输入1有效
		ce	: in std_logic;
		--声明load为逻辑输入，作为清零信号
		load: in std_logic;
		--脉冲
		din:in std_logic;
		--声明ceout为逻辑输出，作为判断结果输出
		total : out integer range 0 to 1440
		);
	end component;
	component separateprice--价格拆分模块
		port
		(
		clk,ce,load	: in std_logic;
		total : in integer range 0 to 10000;
		dout : out std_logic;
		ge,shi,bai,qian,wan:out std_logic_vector(3 downto 0)
		);
	end component;
	component separatetime--时间拆分模块
		port
		(
		clk,ce,load	: in std_logic;
		totaltime : in integer range 0 to 1440;
		ffen,sfen,fh,sh:out std_logic_vector(3 downto 0)
		);
	end component;
	component remove_jitter--按键消抖
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
			--消抖后的按键信号,
			key_out	: out std_logic
		);
	end component;
	component state_controller--状态机
	port(
			st : in std_logic;
			--qibu脉冲
			qibu : in std_logic;
			clk : in std_logic;
			tenin : in std_logic;
			load : out std_logic;
			--输出计价状态
			state_pricing : out integer range 1 to 4
	);
	end component;
	component unit_price--起步价外计价
	port(
		st : in std_logic;
		load : in std_logic;
		--night drive
		night : in std_logic;
		--每公里脉冲
		dp : in std_logic;
		--时钟脉冲
		clk : in std_logic;
		--远程脉冲
		yuancheng : in std_logic;
		--每分钟脉冲
		minin : in std_logic;
		state_pricing : in integer range 1 to 4;
		--车费
		total_price : out integer range 0 to 10000;
		day_starting_price :in integer range 0 to 200;		--白天起步价
		night_starting_price :in integer range 0 to 200;		--夜晚起步价
		day_mileage_price :in integer range 0 to 100;			--白天普通里程价格
		day_timing_price :in integer range 0 to 100;			--白天计时计价
		day_long_distance_price :in integer range 0 to 100	--白天长途计价
	);
	end component;
	component starting_price--起步价内计价模块
	port(
		st : in std_logic;
		load : in std_logic;
		--night drive
		night : in std_logic;
		--时钟脉冲
		clk : in std_logic;
		--输入状态机判断的计价状态
		state_pricing : in integer range 1 to 4;
		--车费
		day_starting_price :in integer range 0 to 200;
		night_starting_price :in integer range 0 to 200;
		total_price : out integer range 0 to 10000
	);
	end component;
	component lingcheng--凌晨状态脉冲
	port
	(
		--声明clk为逻辑输入，作为数据输入
		clk	: in std_logic;
		--声明ceout为逻辑输出，作为判断结果输出
		ceout : out std_logic;
		timesel : in std_logic;--时间设置模式
		settime : in std_logic_vector(10 downto 0)
	);
	end component;
	component or2total--总价显示或操作
		port
		(
		ce : in std_logic;
		pricesel : in integer;--价格位置选择
		total1	: in integer range 0 to 9999;--起步价外计价
		total2	: in integer range 0 to 9999;--起步价内计价
		price : in integer range 0 to 9999;--设置价格计价
		total	: out integer range 0 to 9999
		);
	--结束主体
	end component;
	component SetInit--设置当前时间24h
	port
	(
		clk : in std_logic;  --时钟
		time_state : in std_logic;  --设置模式开启关闭
		sel , set : in std_logic;  --选择位，+1
		confirm : in std_logic;  --确认
		timesel : out std_logic;
		hour_s, hour_f , min_s , min_f : out integer range 0 to 9 --00:00四位
	);
	end component;
	component settime
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
	end component;
	component set_price--设置价格
	port(
			clk : in std_logic;  --时钟
			price_state : in std_logic;  --设置模式开启
			sel , set : in std_logic;  --选择位，+1
			confirm : in std_logic;  --确认
			pricesel : out integer:=0;--设置价格的状态:0 是确认状态,2 是夜晚起步价,1 是显示白天起步价,3 是白天里程,4 是 白天计时,5 是白天长途
			day_starting_price_j , day_starting_price_y , day_starting_price_t , day_starting_price_h : out integer range 0 to 9 ;		--白天起步价
			night_starting_price_j , night_starting_price_y , night_starting_price_t , night_starting_price_h : out integer range 0 to 9 ;		--夜晚起步价
			day_mileage_price_j , day_mileage_price_y , day_mileage_price_t , day_mileage_price_h  : out integer range 0 to 9 ;			--白天普通里程价格
			day_timing_price_j , day_timing_price_y , day_timing_price_t , day_timing_price_h  : out integer range 0 to 9 ;			--白天计时计价
			day_long_distance_price_j , day_long_distance_price_y , day_long_distance_price_t , day_long_distance_price_h  : out integer range 0 to 9	--白天长途计价
	);
	end component;
	component setprice
	port
		(
			--声明ce为逻辑输入，作为使能，输入1有效
			ce : in std_logic;
			--声明clk为逻辑输入，作为数据输入
			clk :  in std_logic;
			--声明load为逻辑输入，作为清零信号
			load : in std_logic;
			price_state : in std_logic;  --设置模式开启
			day_starting_price_j , day_starting_price_y , day_starting_price_t , day_starting_price_h : in integer range 0 to 9 ;
			night_starting_price_j , night_starting_price_y , night_starting_price_t , night_starting_price_h : in integer range 0 to 9 ;	
			day_mileage_price_j , day_mileage_price_y , day_mileage_price_t , day_mileage_price_h  : in integer range 0 to 9 ;			
			day_timing_price_j , day_timing_price_y , day_timing_price_t , day_timing_price_h  : in integer range 0 to 9 ;			
			day_long_distance_price_j , day_long_distance_price_y , day_long_distance_price_t , day_long_distance_price_h  : in integer range 0 to 9 ;	
			day_starting_price :out integer range 0 to 9999;--白天起步价
			night_starting_price :out integer range 0 to 9999;--夜晚起步价
			day_mileage_price :out integer range 0 to 9999;--白天普通里程价格
			day_timing_price :out integer range 0 to 9999;--白天计时计价
			day_long_distance_price :out integer range 0 to 9999  --白天长途
	);
	end component;
	component or5price--便于设置价格显示的5选1
		port
		(
		ce : in std_logic;
		pricesel : in integer;
		day_starting_price :in integer range 0 to 9999;--白天起步价
		night_starting_price :in integer range 0 to 9999;--夜晚起步价
		day_mileage_price :in integer range 0 to 9999;--白天普通里程价格
		day_timing_price :in integer range 0 to 9999;--白天计时计价
		day_long_distance_price :in integer range 0 to 9999;  --白天长途
		price	: out integer range 0 to 9999
		);
	end component;
	
	component or2time--便于设置时间显示的2选1
		port
		(
		ce : in std_logic;
		timesel : in std_logic;--时间设置标志
		ffen,sfen,fh,sh:in std_logic_vector(3 downto 0);--出租车行驶时间显示
		vffen,vsfen,vfh,vsh:in integer range 0 to 9; --设置时间输入
		rffen,rsfen,rfh,rsh:out std_logic_vector(3 downto 0)
		);
		end component;
		
	component bee
	port
	(
		ce : in std_logic;
		qibu : in std_logic;--起步信号
		run_pulse : in std_logic;--里程脉冲
		wait_pulse : in std_logic;--等待时间脉冲
		bee_pulse : out std_logic--蜂鸣器脉冲
	);
--结束主体
	end component;
	
	--内部信号线
	signal ce0,load0 : std_logic;
	signal net1 : std_logic;--高低速模块输出内部信号线
	signal net2,net3,net4 : std_logic;--里程计价模块里程脉冲，起步，远程内部数据线
	signal net5,net6 : std_logic;--低速计时模块内部信号,分钟脉冲，十分钟信号
	signal net7 : std_logic;--总共运行公里数模块内部信号:公里脉冲
	signal net8,net9 : std_logic; --运行总时间分钟脉冲和十分钟脉冲,十分钟脉冲没用
	signal net10,net11 :integer range 0 to 1440;--分别统计出租车运行后的公里数和分钟数
	signal net12,net13,net14,net15: std_logic_vector(3 downto 0);--出租车运行时间拆分
	signal net16,net17,net18,net19: std_logic_vector(3 downto 0);--出租车运行路程拆分
	signal net20:std_logic;--输出状态机状态
	signal net21 :integer range 1 to 4;--输出计价状态
	signal net22 : std_logic;--输出凌晨状态
	signal net23 : integer range 0 to 10000;--起步价内计价模块输出
	signal net24 : integer range 0 to 10000;--起步价外计价模块
	signal net25 : integer range 0 to 10000;
	signal net26,net27,net28,net29: std_logic_vector(3 downto 0);--计价拆分
	signal startnet:std_logic;--开始start按键消抖
	signal key_timenet : std_logic;
	signal key_pricenet : std_logic;--设置价格按键消抖
	signal key_conformnet : std_logic;--确认按键消抖
	signal key_selectnet : std_logic;--选择按键消抖
	signal key_setnet : std_logic;--
	signal hour_snet, hour_fnet , min_snet , min_fnet : integer range 0 to 9;--时间设置模块拆分
	signal settimenet : std_logic_vector(10 downto 0);--设置时间结果
	signal day_starting_pricenet_j,day_starting_pricenet_y,day_starting_pricenet_t,day_starting_pricenet_h :integer range 0 to 9;
	signal night_starting_pricenet_j,night_starting_pricenet_y,night_starting_pricenet_t,night_starting_pricenet_h :integer range 0 to 9;
	signal day_mileage_pricenet_j,day_mileage_pricenet_y,day_mileage_pricenet_t,day_mileage_pricenet_h :integer range 0 to 9;
	signal day_timing_pricenet_j,day_timing_pricenet_y,day_timing_pricenet_t,day_timing_pricenet_h :integer range 0 to 9;
	signal day_long_distance_pricenet_j,day_long_distance_pricenet_y,day_long_distance_pricenet_t,day_long_distance_pricenet_h : integer range 0 to 9;
	signal priceselnet : integer;--设置出租车价格的状态
	signal day_starting_pricenet :integer range 0 to 9999;--白天起步价
	signal night_starting_pricenet :integer range 0 to 9999;--夜晚起步价
	signal day_mileage_pricenet : integer range 0 to 9999;--白天普通里程价格
	signal day_timing_pricenet : integer range 0 to 9999;--白天计时计价
	signal day_long_distance_pricenet : integer range 0 to 9999;  --白天长途
	signal pricenet : integer range 0 to 9999;--设置价格的价格输出
	signal timeselnet : std_logic;--价格设置标志位
	signal net30,net31,net32,net33: std_logic_vector(3 downto 0);
	begin 
	u1 : hl port map(ce=>key_start,load=>load0,clk=>clk,din=>wheel,ceout=>net1);--判断是高速行驶还是低速行驶
	u2 : licheng port map(ce=>key_start,load=>load0,clk=>clk,din=>wheel,cein=>net1,dp=>net2,qibu=>net3,yuancheng=>net4);--用于里程计价的里程数
	u3 : delay port map(ce=>key_start,load=>load0,clk=>clk,cein=>net1,ceout=>net5,tenout=>net6);--用于计时计价的分钟数
	u4 : total_run port map(ce=>key_start,load=>load0,clk=>clk,din=>wheel,dp_total=>net7);--出租车启动后运行的里程数
	u5 : drivetime port map(ce=>key_start,load=>load0,din=>clk,dout=>net8,tenout=>net9);--出租车启动后运行的分钟数
	u6 : countplus port map(ce=>key_start,load=>load0,din=>net7,total=>net10);--出租车启动后运行的里程数总数
	u7 : countplus port map(ce=>key_start,load=>load0,din=>net8,total=>net11);--出租车启动后运行的分钟数总数
	u8 : separatetime port map(ce=>key_start,load=>load0,clk=>clk,totaltime=>net11,ffen=>net12,sfen=>net13,fh=>net14,sh=>net15);--出租车运行时间拆分
	u9 : displaytime port map(ce=>key_start,load=>load0,clk=>clk,ffen=>net30,sfen=>net31,fh=>net32,sh=>net33,sel=>seltime,outp=>outptime);--出租车运行时间和设置时间数码管时间显示位选和段选
	u10 : separateprice port map(ce=>key_start,load=>load0,clk=>clk,total=>net10,ge=>net16,shi=>net17,bai=>net18,qian=>net19);--出租车启动后运行的里程数总数拆分
	u11 : displaydistance port map(ce=>key_start,load=>load0,clk=>clk,ge=>net16,shi=>net17,bai=>net18,qian=>net19,sel=>seldistance,outp=>outpdistance);--出租车启动后运行的里程数总数数码管显示
	u12 : state_controller port map(st=>key_start,qibu=>net3,clk=>clk,load=>load0,state_pricing=>net21,tenin=>net6);--状态机
	u13 : lingcheng port map(clk=>clk,ceout=>net22,settime=>settimenet,timesel=>key_timenet);--凌晨状态脉冲
	u14 : starting_price port map(st=>key_start,load=>net20,night=>net22,clk=>clk,state_pricing=>net21,total_price=>net23,day_starting_price=>day_starting_pricenet,night_starting_price=>night_starting_pricenet);--起步价内计价模块
	u15 : unit_price port map(st=>key_start,load=>net20,night=>net22,clk=>clk,state_pricing=>net21,yuancheng=>net4,minin=>net5,dp=>net2,total_price=>net24,day_starting_price=>day_starting_pricenet,night_starting_price=>night_starting_pricenet,day_timing_price=>day_timing_pricenet,day_long_distance_price=>day_long_distance_pricenet,day_mileage_price=>day_mileage_pricenet);--起步价外计价模块
	u16 : or2total port map(ce=>key_start,total1=>net24,total2=>net23,total=>net25,pricesel=>priceselnet,price=>pricenet);
	u17 : separateprice port map(ce=>key_start,load=>load0,clk=>clk,total=>net25,ge=>net26,shi=>net27,bai=>net28,qian=>net29);--价格拆分
	u18 : displayprice port map(ce=>key_start,load=>load0,clk=>clk,a=>net26,b=>net27,c=>net28,d=>net29,sel=>selprice,outp=>outpprice);--价格显示
	u19 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_time,key_out=>key_timenet);--设置初始时间按键消抖
	u20 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_select,key_out=>key_selectnet);--选择按键消抖
	u21 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_conform,key_out=>key_conformnet);--确认按键消抖
	u22 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_set,key_out=>key_setnet);--
	u23 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_price,key_out=>key_pricenet);--设置价格按键消抖
	u24 : SetInit port map(clk=>clk,time_state=>key_timenet,sel=>key_selectnet,set=>key_setnet,confirm=>key_conformnet,hour_s=>hour_snet,hour_f=>hour_fnet,min_s=>min_snet,min_f=>min_fnet,timesel=>timeselnet);
	u25 : settime port map(clk=>clk,ce=>key_start,load=>load0,hour_s=>hour_snet,hour_f=>hour_fnet,min_s=>min_snet,min_f=>min_fnet,settime=>settimenet);
	u26 : set_price port map(price_state=>key_pricenet,clk=>clk,sel=>key_selectnet,set=>key_setnet,confirm=>key_conformnet,day_starting_price_j=>day_starting_pricenet_j,day_starting_price_y=>day_starting_pricenet_y,day_starting_price_t=>day_starting_pricenet_t,day_starting_price_h=>day_starting_pricenet_h,night_starting_price_j=>night_starting_pricenet_j,night_starting_price_y=>night_starting_pricenet_y,night_starting_price_t=>night_starting_pricenet_t,night_starting_price_h=>night_starting_pricenet_h,day_mileage_price_j=>day_mileage_pricenet_j,day_mileage_price_y=>day_mileage_pricenet_y,day_mileage_price_t=>day_mileage_pricenet_t,day_mileage_price_h=>day_mileage_pricenet_h,day_timing_price_j=>day_timing_pricenet_j,day_timing_price_y=>day_timing_pricenet_y,day_timing_price_t=>day_timing_pricenet_t,day_timing_price_h=>day_timing_pricenet_h,day_long_distance_price_j=>day_long_distance_pricenet_j,day_long_distance_price_y=>day_long_distance_pricenet_y,day_long_distance_price_t=>day_long_distance_pricenet_t,day_long_distance_price_h=>day_long_distance_pricenet_h,pricesel=>priceselnet);
	u27 : setprice port map(clk=>clk,ce=>key_start,load=>load0,price_state=>key_pricenet,day_starting_price_j=>day_starting_pricenet_j,day_starting_price_y=>day_starting_pricenet_y,day_starting_price_t=>day_starting_pricenet_t,day_starting_price_h=>day_starting_pricenet_h,night_starting_price_j=>night_starting_pricenet_j,night_starting_price_y=>night_starting_pricenet_y,night_starting_price_t=>night_starting_pricenet_t,night_starting_price_h=>night_starting_pricenet_h,day_mileage_price_j=>day_mileage_pricenet_j,day_mileage_price_y=>day_mileage_pricenet_y,day_mileage_price_t=>day_mileage_pricenet_t,day_mileage_price_h=>day_mileage_pricenet_h,day_timing_price_j=>day_timing_pricenet_j,day_timing_price_y=>day_timing_pricenet_y,day_timing_price_t=>day_timing_pricenet_t,day_timing_price_h=>day_timing_pricenet_h,day_long_distance_price_j=>day_long_distance_pricenet_j,day_long_distance_price_y=>day_long_distance_pricenet_y,day_long_distance_price_t=>day_long_distance_pricenet_t,day_long_distance_price_h=>day_long_distance_pricenet_h,day_starting_price=>day_starting_pricenet,night_starting_price =>night_starting_pricenet,day_mileage_price=>day_mileage_pricenet,day_timing_price=>day_timing_pricenet,day_long_distance_price=>day_long_distance_pricenet);
	u28 : or5price port map(ce=>key_start,pricesel=>priceselnet,day_starting_price=>day_starting_pricenet,night_starting_price=>night_starting_pricenet, day_mileage_price=>day_mileage_pricenet,day_timing_price=>day_timing_pricenet,day_long_distance_price=>day_long_distance_pricenet,price=>pricenet);--设置价格五选一,用于数码管显示
	u29 : or2time port map(ce=>key_start,timesel=>timeselnet,ffen=>net12,sfen=>net13,fh=>net14,sh=>net15,vffen=>min_fnet,vsfen=>min_snet,vfh=>hour_fnet,vsh=>hour_snet,rffen=>net30,rsfen=>net31,rfh=>net32,rsh=>net33);
	u30 : bee port map(ce=>key_start,wait_pulse=>net5,run_pulse=>net2,bee_pulse=>bee_pulse,qibu=>net3);
end architecture one;