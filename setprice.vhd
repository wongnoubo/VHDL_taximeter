library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity setprice is
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
end entity setprice;

architecture setprice of setprice is
	component mult10b
		port ( d1 , d2 : in std_logic_vector (9 downto 0);
			   q : out std_logic_vector ( 19 downto 0)
		);
	end component ;
	signal day_starting_price_a , day_starting_price_b , day_starting_price_c , day_starting_price_d : std_logic_vector(9 downto 0);
	signal night_starting_price_a , night_starting_price_b , night_starting_price_c , night_starting_price_d : std_logic_vector(9 downto 0);
	signal day_mileage_price_a , day_mileage_price_b , day_mileage_price_c , day_mileage_price_d : std_logic_vector(9 downto 0);
	signal day_timing_price_a , day_timing_price_b , day_timing_price_c , day_timing_price_d : std_logic_vector(9 downto 0);
	signal day_long_distance_price_a , day_long_distance_price_b , day_long_distance_price_c , day_long_distance_price_d : std_logic_vector(9 downto 0);
	signal mul11 , mul12 , mul13 : std_logic_vector(19 downto 0);
	signal mul21 , mul22 , mul23 : std_logic_vector(19 downto 0);
	signal mul31 , mul32 , mul33 : std_logic_vector(19 downto 0);
	signal mul41 , mul42 , mul43 : std_logic_vector(19 downto 0);
	signal mul51 , mul52 , mul53 : std_logic_vector(19 downto 0);
	signal transition1 ,transition2 ,transition3 , transition4 ,transition5 : std_logic_vector(19 downto 0);
	signal ten : std_logic_vector(9 downto 0) := "0000001010";
	signal hundred : std_logic_vector(9 downto 0) := "0001100100";
	signal thousand : std_logic_vector(9 downto 0) := "1111101000";
begin
	day_starting_price_a <= conv_std_logic_vector (day_starting_price_h , 10);
	day_starting_price_b <= conv_std_logic_vector (day_starting_price_t , 10);
	day_starting_price_c <= conv_std_logic_vector (day_starting_price_y  , 10);
	day_starting_price_d <= conv_std_logic_vector (day_starting_price_j  , 10);
	night_starting_price_a <= conv_std_logic_vector (night_starting_price_h , 10);
	night_starting_price_b <= conv_std_logic_vector (night_starting_price_t , 10);
	night_starting_price_c <= conv_std_logic_vector (night_starting_price_y  , 10);
	night_starting_price_d <= conv_std_logic_vector (night_starting_price_j  , 10);
	day_mileage_price_a <= conv_std_logic_vector (day_mileage_price_h , 10);
	day_mileage_price_b <= conv_std_logic_vector (day_mileage_price_t , 10);
	day_mileage_price_c <= conv_std_logic_vector (day_mileage_price_y  , 10);
	day_mileage_price_d <= conv_std_logic_vector (day_mileage_price_j  , 10);
	day_timing_price_a <= conv_std_logic_vector (day_timing_price_h, 10);
	day_timing_price_b <= conv_std_logic_vector (day_timing_price_t , 10);
	day_timing_price_c <= conv_std_logic_vector (day_timing_price_y  , 10);
	day_timing_price_d <= conv_std_logic_vector (day_timing_price_j  , 10);
	day_long_distance_price_a <= conv_std_logic_vector (day_long_distance_price_h , 10);
	day_long_distance_price_b <= conv_std_logic_vector (day_long_distance_price_t , 10);
	day_long_distance_price_c <= conv_std_logic_vector (day_long_distance_price_y , 10);
	day_long_distance_price_d <= conv_std_logic_vector (day_long_distance_price_j  , 10);
	u28_2:  mult10b 	
		port map (q => mul11 , d1 => day_starting_price_a , d2 => thousand );
	u28_3:  mult10b 	
		port map (q => mul12 , d1 => day_starting_price_b , d2 => hundred);
	u28_4: mult10b 	
		port map (q => mul13 , d1 => day_starting_price_c , d2 => ten);
	u28_5:  mult10b 	
		port map (q => mul21 , d1 => night_starting_price_a , d2 => thousand);
	u28_6:  mult10b 	
		port map (q => mul22 , d1 => night_starting_price_b , d2 => hundred);
	u28_7:  mult10b 	
		port map (q => mul23 , d1 => night_starting_price_c , d2 => ten);
	u28_8:  mult10b 	
		port map (q => mul31 , d1 => day_mileage_price_a , d2 => thousand);
	u28_9:  mult10b 	
		port map (q => mul32 , d1 => day_mileage_price_b , d2 => hundred);
	u28_10:  mult10b 	
		port map (q => mul33 , d1 => day_mileage_price_c , d2 => ten);
	u28_11:  mult10b 	
		port map (q => mul41 , d1 => day_timing_price_a , d2 => thousand);
	u28_12:  mult10b 	
		port map (q => mul42 , d1 => day_timing_price_b , d2 => hundred);
	u28_13:  mult10b 	
		port map (q => mul43 , d1 => day_timing_price_c , d2 => ten);
	u28_14:  mult10b 	
		port map (q => mul51 , d1 => day_long_distance_price_a , d2 => thousand);
	u28_15:  mult10b 	
		port map (q => mul52 , d1 => day_long_distance_price_b , d2 => hundred);
	u28_16:  mult10b 	
		port map (q => mul53 , d1 => day_long_distance_price_c , d2 => ten);
		
	process(clk ,day_starting_price_d , night_starting_price_d , day_mileage_price_d , day_timing_price_d, day_long_distance_price_d, mul11 , mul12 , mul13 , mul21 , mul22 , mul23 , mul31 , mul32 , mul33 , mul41 , mul42 , mul43 , mul51 , mul52 , mul53 )
	begin 
		if clk'event and clk='1' then 
			if price_state='1' then
				transition1 <= (day_starting_price_d + mul11 + mul12 + mul13) ;
				day_starting_price <= conv_integer (transition1 );
				transition2 <= (night_starting_price_d + mul21 + mul22 + mul23) ;
				night_starting_price <= conv_integer (transition2 );
				transition3 <= (day_mileage_price_d + mul31 + mul32 + mul33) ;
				day_mileage_price <= conv_integer (transition3 );
				transition4 <= (day_timing_price_d + mul41 + mul42 + mul43) ;
				day_timing_price <= conv_integer (transition4 );
				transition5 <= (day_long_distance_price_d + mul51 + mul52 + mul53) ;
				day_long_distance_price <= conv_integer (transition5 );
			else
				day_starting_price <=100;--白天起步价
				night_starting_price <=120;--夜晚起步价
				day_mileage_price <=30;--白天普通里程价格
				day_timing_price <=30;--白天计时计价
				day_long_distance_price <=40;  --白天长途
			end if;
		end if;
	end process;
end setprice;