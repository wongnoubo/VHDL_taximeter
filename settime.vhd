library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity settime is
	port
		(
			--����ceΪ�߼����룬��Ϊʹ�ܣ�����1��Ч
			ce : in std_logic;
			--����clkΪ�߼����룬��Ϊ��������
			clk :  in std_logic;
			--����loadΪ�߼����룬��Ϊ�����ź�
			load : in std_logic;
			--���⳵˾�����õ�ʱ�ӳ�ʼֵ������ǰʱ��
			hour_s , hour_f , min_s , min_f  : in integer range 0 to 9 ;
			--�������ʱ��,�Էֱ�ʾ,���Ϊ1439
			settime :  out std_logic_vector(10 downto 0)
	);
end settime;

architecture time of settime is
	component mult10b
		port ( d1 , d2 : in std_logic_vector (9 downto 0);
			   q : out std_logic_vector ( 19 downto 0)
		);
	end component;
	--����ʼʱ���integerת��Ϊstd_logic_vector
	signal a , b , c , d : std_logic_vector(9 downto 0);
	--�м�ֵ
	signal mul1 , mul2 , mul3 : std_logic_vector(19 downto 0);
	-- ������
	signal transition : std_logic_vector(19 downto 0);
	signal ten : std_logic_vector(9 downto 0) := "0000001010";
	signal sixty : std_logic_vector(9 downto 0) := "0000111100";
	signal six_hundreds : std_logic_vector(9 downto 0) := "1001011000";
begin
	--����ʼʱ���integerת��Ϊstd_logic_vector
	a <= conv_std_logic_vector (hour_s , 10);
	b <= conv_std_logic_vector (hour_f , 10);
	c <= conv_std_logic_vector (min_s  , 10);
	d <= conv_std_logic_vector (min_f  , 10);
	--��Сʱת��Ϊ����
	u25_2 : mult10b 	
		port map (q => mul1 , d1 => c , d2 => ten);
	u25_3 : mult10b 
		port map (q => mul2 , d1 => b , d2 => sixty);
	u25_4 : mult10b 
		port map (q => mul3 , d1 => a , d2 => six_hundreds );
	--�ۼӵó�������
	process(clk , d , mul1 , mul2 , mul3)
	begin
		if clk'event and clk='1' then 
			transition <= (d + mul1 + mul2 + mul3) ;
			settime(10 downto 0) <= transition(10 downto 0);
		end if;
	end process;
end time;