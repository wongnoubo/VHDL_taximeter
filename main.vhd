--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity main is
port
	(
		--startϵͳ�ܿ��أ�start=1������start=0ֹͣ
		key_start: in std_logic;
		key_time : in std_logic;--���ó�ʼʱ�䰴��
		key_select : in std_logic;--ѡ��λ����
		key_set : in std_logic;--��������+1
		key_conform : in std_logic;--ȷ�ϰ���
		key_price : in std_logic;--���ü۸񰴼�
		--����clkΪ�߼����룬��Ϊ��������
		clk	: in std_logic;
		--��������һ����ʾ�н�2m
		din:in std_logic;
		seltime:out std_logic_vector(2 downto 0);--��ʾ���⳵������ʱ��������λѡ
		--λѡ
		outptime:out std_logic_vector(7 downto 0);--��ʾ���⳵������ʱ�������ܶ�ѡ
		seldistance:out std_logic_vector(2 downto 0);--��ʾ���⳵������·�̵������λѡ
		--λѡ
		outpdistance:out std_logic_vector(7 downto 0);--��ʾ���⳵������·�̵�����ܶ�ѡ
		selprice:out std_logic_vector(2 downto 0);--�۸��ѡ
		outpprice:out std_logic_vector(7 downto 0)--�۸�λѡ
	);
end entity main;
architecture one of main is
	component ss--��ʼֹͣģ��
	port(
		start: in std_logic;
		ce,load	: out std_logic
	);
	end component;
	component hl--�жϸߵ���ģ��
	port
	(
		--����ceΪ�߼����룬��Ϊʹ�ܣ�����1��Ч
		ce	: in std_logic;
		--����clkΪ�߼����룬��Ϊ��������
		clk	: in std_logic;
		--����loadΪ�߼����룬��Ϊ�����ź�
		load: in std_logic;
		--speed's plus
		din:in std_logic;
		--����ceoutΪ�߼��������Ϊ�жϽ�����
		ceout	: out std_logic
	);
	end component;
	component drivetime --��ʻʱ������ģ��
	port(
			--����dinΪ�߼����룬����������ʱ���ź�
		--����ceΪ�߼����룬������ʹ�ܣ�����0ʱ��Ч
		--����loadΪ�߼����룬����������
		din,ce,load	: in std_logic;
		--ÿ���� dout='1'
		dout	: out std_logic;
		--ʮ���� tenout='1'
		tenout : out std_logic
	);
	end component;
	component licheng--��̼Ƽ�����ģ��
	port
	(
		--����ceΪ�߼����룬������ʹ�ܣ�����1��Ч���Ӹߵ����ж�ģ�����
		ce:in std_logic;
		--����clkΪ�߼����룬����������ʱ��
		clk:in std_logic;
		--����dinΪ�߼����룬���������복�����̲������ٶ�����
		din:in std_logic;
		--����dpΪ�߼����������������ж��źţ����0�����������н������1������ֹͣ
		load:in std_logic;
		--�ߵ����ж������ź�
		cein:in std_logic;
		--ÿ��������'1'->1km
		dp:out std_logic;
		--��2.5km�ж�����'0'->����2.5km;'1'->2.5km����
		qibu:out std_logic;
		--Զ��12km�ж�����'0'->����12km;'1'->12km����
		yuancheng:out std_logic
	);
	end component;
	component delay--�ȴ�ʱ��ģ��
		port(
			--����ceΪ�߼����룬��Ϊʹ�ܣ�����1��Ч
			ce	: in std_logic;
			--����clkΪ�߼����룬��Ϊ��������
			clk	: in std_logic;
			--����loadΪ�߼����룬��Ϊ�����ź�
			load: in std_logic;
			--�ߵ����ж������ź�
			cein:in std_logic;
			--����ceoutΪ�߼������ͣ��һ�����������
			ceout	: out std_logic;
			--ʮ�����𲽼�
			tenout : out std_logic
		);
	end component;
	component total_run--�ܵ���ʻ���
	port(
		--����ceΪ�߼����룬������ʹ�ܣ�����1��Ч���Ӹߵ����ж�ģ�����
		ce:in std_logic;
		--����clkΪ�߼����룬����������ʱ��
		clk:in std_logic;
		--����dinΪ�߼����룬���������복�����̲������ٶ�����
		din:in std_logic;
		--����dpΪ�߼����������������ж��źţ����0�����������н������1������ֹͣ
		load:in std_logic;
		--ÿ��������'1'->1km
		dp_total:out std_logic
	);
	end component;
	component displaytime--�������ʾʱ��ģ��
	port
	(
		--����dinΪ�߼����룬����������ʱ���ź�
		--����ceΪ�߼����룬������ʹ�ܣ�����1ʱ��Ч
		--����loadΪ�߼����룬����������
		load,ce:in std_logic;
		clk	: in std_logic;
		ffen,sfen,fh,sh:in std_logic_vector(3 downto 0);
		--��ѡ
		sel:out std_logic_vector(2 downto 0);
		--λѡ
		outp:out std_logic_vector(7 downto 0)
	);
	end component;
	component displaydistance--�������ʾ����
		port
		(
			--����dinΪ�߼����룬����������ʱ���ź�
			--����ceΪ�߼����룬������ʹ�ܣ�����1ʱ��Ч
			--����loadΪ�߼����룬����������
			load,ce:in std_logic;
			clk	: in std_logic;
			ge,shi,bai,qian:in std_logic_vector(3 downto 0);
			--��ѡ
			sel:out std_logic_vector(2 downto 0);
			--λѡ
			outp:out std_logic_vector(7 downto 0)
		);
	end component;--�������ʾ����ģ��
	component displayprice--�������ʾ�۸�
		port
		(
			--����dinΪ�߼����룬����������ʱ���ź�
			--����ceΪ�߼����룬������ʹ�ܣ�����1ʱ��Ч
			--����loadΪ�߼����룬����������
			load,ce:in std_logic;
			clk	: in std_logic;
			a,b,c,d:in std_logic_vector(3 downto 0);
			--��ѡ
			sel:out std_logic_vector(2 downto 0);
			--λѡ
			outp:out std_logic_vector(7 downto 0)
			);
	end component;--�������ʾ�۸�
	component countplus--ͳ����������ʱ������
		port
		(
		--����ceΪ�߼����룬��Ϊʹ�ܣ�����1��Ч
		ce	: in std_logic;
		--����loadΪ�߼����룬��Ϊ�����ź�
		load: in std_logic;
		--����
		din:in std_logic;
		--����ceoutΪ�߼��������Ϊ�жϽ�����
		total : out integer range 0 to 1440
		);
	end component;
	component separateprice--�۸���ģ��
		port
		(
		clk,ce,load	: in std_logic;
		total : in integer range 0 to 10000;
		dout : out std_logic;
		ge,shi,bai,qian,wan:out std_logic_vector(3 downto 0)
		);
	end component;
	component separatetime--ʱ����ģ��
		port
		(
		clk,ce,load	: in std_logic;
		totaltime : in integer range 0 to 1440;
		ffen,sfen,fh,sh:out std_logic_vector(3 downto 0)
		);
	end component;
	component remove_jitter--��������
		port
		(
			--����ceΪ�߼����룬��Ϊʹ�ܣ�����1��Ч
			ce	: in std_logic;
			--����clkΪ�߼����룬��Ϊ��������
			clk	: in std_logic;
			--����loadΪ�߼����룬��Ϊ�����ź�
			load : in std_logic;
			--�������룬ÿ��ֻ��һ����������
			key_in	: in std_logic;
			--������İ����ź�,
			key_out	: out std_logic
		);
	end component;
	component state_controller--״̬��
	port(
			st : in std_logic;
			--qibu����
			qibu : in std_logic;
			clk : in std_logic;
			tenin : in std_logic;
			load : out std_logic;
			--����Ƽ�״̬
			state_pricing : out integer range 1 to 4
	);
	end component;
	component unit_price--�𲽼���Ƽ�
	port(
		st : in std_logic;
		load : in std_logic;
		--night drive
		night : in std_logic;
		--ÿ��������
		dp : in std_logic;
		--ʱ������
		clk : in std_logic;
		--Զ������
		yuancheng : in std_logic;
		--ÿ��������
		minin : in std_logic;
		state_pricing : in integer range 1 to 4;
		--����
		total_price : out integer range 0 to 10000;
		day_starting_price :in integer range 0 to 200;		--�����𲽼�
		night_starting_price :in integer range 0 to 200;		--ҹ���𲽼�
		day_mileage_price :in integer range 0 to 100;			--������ͨ��̼۸�
		day_timing_price :in integer range 0 to 100;			--�����ʱ�Ƽ�
		day_long_distance_price :in integer range 0 to 100	--���쳤;�Ƽ�
	);
	end component;
	component starting_price--�𲽼��ڼƼ�ģ��
	port(
		st : in std_logic;
		load : in std_logic;
		--night drive
		night : in std_logic;
		--ʱ������
		clk : in std_logic;
		--����״̬���жϵļƼ�״̬
		state_pricing : in integer range 1 to 4;
		--����
		day_starting_price :in integer range 0 to 200;
		night_starting_price :in integer range 0 to 200;
		total_price : out integer range 0 to 10000
	);
	end component;
	component lingcheng--�賿״̬����
	port
	(
		--����clkΪ�߼����룬��Ϊ��������
		clk	: in std_logic;
		--����ceoutΪ�߼��������Ϊ�жϽ�����
		ceout : out std_logic;
		settime : in std_logic_vector(10 downto 0)
	);
	end component;
	component or2total--�ܼ���ʾ�����
		port
		(
		ce : in std_logic;
		pricesel : in integer;--�۸�λ��ѡ��
		total1	: in integer range 0 to 9999;--�𲽼���Ƽ�
		total2	: in integer range 0 to 9999;--�𲽼��ڼƼ�
		price : in integer range 0 to 9999;--���ü۸�Ƽ�
		total	: out integer range 0 to 9999
		);
	--��������
	end component;
	component SetInit--���õ�ǰʱ��24h
	port
	(
		clk : in std_logic;  --ʱ��
		time_state : in std_logic;  --����ģʽ�����ر�
		sel , set : in std_logic;  --ѡ��λ��+1
		confirm : in std_logic;  --ȷ��
		timesel : out std_logic;
		hour_s, hour_f , min_s , min_f : out integer range 0 to 9 --00:00��λ
	);
	end component;
	component settime
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
	end component;
	component set_price--���ü۸�
	port(
			clk : in std_logic;  --ʱ��
			price_state : in std_logic;  --����ģʽ����
			sel , set : in std_logic;  --ѡ��λ��+1
			confirm : in std_logic;  --ȷ��
			pricesel : out integer:=0;--���ü۸��״̬:0 ��ȷ��״̬,2 ��ҹ���𲽼�,1 ����ʾ�����𲽼�,3 �ǰ������,4 �� �����ʱ,5 �ǰ��쳤;
			day_starting_price_j , day_starting_price_y , day_starting_price_t , day_starting_price_h : out integer range 0 to 9 ;		--�����𲽼�
			night_starting_price_j , night_starting_price_y , night_starting_price_t , night_starting_price_h : out integer range 0 to 9 ;		--ҹ���𲽼�
			day_mileage_price_j , day_mileage_price_y , day_mileage_price_t , day_mileage_price_h  : out integer range 0 to 9 ;			--������ͨ��̼۸�
			day_timing_price_j , day_timing_price_y , day_timing_price_t , day_timing_price_h  : out integer range 0 to 9 ;			--�����ʱ�Ƽ�
			day_long_distance_price_j , day_long_distance_price_y , day_long_distance_price_t , day_long_distance_price_h  : out integer range 0 to 9	--���쳤;�Ƽ�
	);
	end component;
	component setprice
	port
		(
			--����ceΪ�߼����룬��Ϊʹ�ܣ�����1��Ч
			ce : in std_logic;
			--����clkΪ�߼����룬��Ϊ��������
			clk :  in std_logic;
			--����loadΪ�߼����룬��Ϊ�����ź�
			load : in std_logic;
			price_state : in std_logic;  --����ģʽ����
			day_starting_price_j , day_starting_price_y , day_starting_price_t , day_starting_price_h : in integer range 0 to 9 ;
			night_starting_price_j , night_starting_price_y , night_starting_price_t , night_starting_price_h : in integer range 0 to 9 ;	
			day_mileage_price_j , day_mileage_price_y , day_mileage_price_t , day_mileage_price_h  : in integer range 0 to 9 ;			
			day_timing_price_j , day_timing_price_y , day_timing_price_t , day_timing_price_h  : in integer range 0 to 9 ;			
			day_long_distance_price_j , day_long_distance_price_y , day_long_distance_price_t , day_long_distance_price_h  : in integer range 0 to 9 ;	
			day_starting_price :out integer range 0 to 9999;--�����𲽼�
			night_starting_price :out integer range 0 to 9999;--ҹ���𲽼�
			day_mileage_price :out integer range 0 to 9999;--������ͨ��̼۸�
			day_timing_price :out integer range 0 to 9999;--�����ʱ�Ƽ�
			day_long_distance_price :out integer range 0 to 9999  --���쳤;
	);
	end component;
	component or5price--�������ü۸���ʾ��5ѡ1
		port
		(
		ce : in std_logic;
		pricesel : in integer;
		day_starting_price :in integer range 0 to 9999;--�����𲽼�
		night_starting_price :in integer range 0 to 9999;--ҹ���𲽼�
		day_mileage_price :in integer range 0 to 9999;--������ͨ��̼۸�
		day_timing_price :in integer range 0 to 9999;--�����ʱ�Ƽ�
		day_long_distance_price :in integer range 0 to 9999;  --���쳤;
		price	: out integer range 0 to 9999
		);
	end component;
	
	component or2time--��������ʱ����ʾ��2ѡ1
		port
		(
		ce : in std_logic;
		timesel : in std_logic;--ʱ�����ñ�־
		ffen,sfen,fh,sh:in std_logic_vector(3 downto 0);--���⳵��ʻʱ����ʾ
		vffen,vsfen,vfh,vsh:in integer range 0 to 9; --����ʱ������
		rffen,rsfen,rfh,rsh:out std_logic_vector(3 downto 0)
		);
		end component;
	
	--�ڲ��ź���
	signal ce0,load0 : std_logic;
	signal net1 : std_logic;--�ߵ���ģ������ڲ��ź���
	signal net2,net3,net4 : std_logic;--��̼Ƽ�ģ��������壬�𲽣�Զ���ڲ�������
	signal net5,net6 : std_logic;--���ټ�ʱģ���ڲ��ź�,�������壬ʮ�����ź�
	signal net7 : std_logic;--�ܹ����й�����ģ���ڲ��ź�:��������
	signal net8,net9 : std_logic; --������ʱ����������ʮ��������,ʮ��������û��
	signal net10,net11 :integer range 0 to 1440;--�ֱ�ͳ�Ƴ��⳵���к�Ĺ������ͷ�����
	signal net12,net13,net14,net15: std_logic_vector(3 downto 0);--���⳵����ʱ����
	signal net16,net17,net18,net19: std_logic_vector(3 downto 0);--���⳵����·�̲��
	signal net20:std_logic;--���״̬��״̬
	signal net21 :integer range 1 to 4;--����Ƽ�״̬
	signal net22 : std_logic;--����賿״̬
	signal net23 : integer range 0 to 10000;--�𲽼��ڼƼ�ģ�����
	signal net24 : integer range 0 to 10000;--�𲽼���Ƽ�ģ��
	signal net25 : integer range 0 to 10000;
	signal net26,net27,net28,net29: std_logic_vector(3 downto 0);--�Ƽ۲��
	signal startnet:std_logic;--��ʼstart��������
	signal key_timenet : std_logic;
	signal key_pricenet : std_logic;--���ü۸񰴼�����
	signal key_conformnet : std_logic;--ȷ�ϰ�������
	signal key_selectnet : std_logic;--ѡ�񰴼�����
	signal key_setnet : std_logic;--
	signal hour_snet, hour_fnet , min_snet , min_fnet : integer range 0 to 9;--ʱ������ģ����
	signal settimenet : std_logic_vector(10 downto 0);--����ʱ����
	signal day_starting_pricenet_j,day_starting_pricenet_y,day_starting_pricenet_t,day_starting_pricenet_h :integer range 0 to 9;
	signal night_starting_pricenet_j,night_starting_pricenet_y,night_starting_pricenet_t,night_starting_pricenet_h :integer range 0 to 9;
	signal day_mileage_pricenet_j,day_mileage_pricenet_y,day_mileage_pricenet_t,day_mileage_pricenet_h :integer range 0 to 9;
	signal day_timing_pricenet_j,day_timing_pricenet_y,day_timing_pricenet_t,day_timing_pricenet_h :integer range 0 to 9;
	signal day_long_distance_pricenet_j,day_long_distance_pricenet_y,day_long_distance_pricenet_t,day_long_distance_pricenet_h : integer range 0 to 9;
	signal priceselnet : integer;--���ó��⳵�۸��״̬
	signal day_starting_pricenet :integer range 0 to 9999;--�����𲽼�
	signal night_starting_pricenet :integer range 0 to 9999;--ҹ���𲽼�
	signal day_mileage_pricenet : integer range 0 to 9999;--������ͨ��̼۸�
	signal day_timing_pricenet : integer range 0 to 9999;--�����ʱ�Ƽ�
	signal day_long_distance_pricenet : integer range 0 to 9999;  --���쳤;
	signal pricenet : integer range 0 to 9999;--���ü۸�ļ۸����
	signal timeselnet : std_logic;--�۸����ñ�־λ
	signal net30,net31,net32,net33: std_logic_vector(3 downto 0);
	begin 
	u1 : hl port map(ce=>key_start,load=>load0,clk=>clk,din=>din,ceout=>net1);--�ж��Ǹ�����ʻ���ǵ�����ʻ
	u2 : licheng port map(ce=>key_start,load=>load0,clk=>clk,din=>din,cein=>net1,dp=>net2,qibu=>net3,yuancheng=>net4);--������̼Ƽ۵������
	u3 : delay port map(ce=>key_start,load=>load0,clk=>clk,cein=>net1,ceout=>net5,tenout=>net6);--���ڼ�ʱ�Ƽ۵ķ�����
	u4 : total_run port map(ce=>key_start,load=>load0,clk=>clk,din=>din,dp_total=>net7);--���⳵���������е������
	u5 : drivetime port map(ce=>key_start,load=>load0,din=>clk,dout=>net8,tenout=>net9);--���⳵���������еķ�����
	u6 : countplus port map(ce=>key_start,load=>load0,din=>net7,total=>net10);--���⳵���������е����������
	u7 : countplus port map(ce=>key_start,load=>load0,din=>net8,total=>net11);--���⳵���������еķ���������
	u8 : separatetime port map(ce=>key_start,load=>load0,clk=>clk,totaltime=>net11,ffen=>net12,sfen=>net13,fh=>net14,sh=>net15);--���⳵����ʱ����
	u9 : displaytime port map(ce=>key_start,load=>load0,clk=>clk,ffen=>net30,sfen=>net31,fh=>net32,sh=>net33,sel=>seltime,outp=>outptime);--���⳵����ʱ�������ʱ�������ʱ����ʾλѡ�Ͷ�ѡ
	u10 : separateprice port map(ce=>key_start,load=>load0,clk=>clk,total=>net10,ge=>net16,shi=>net17,bai=>net18,qian=>net19);--���⳵���������е�������������
	u11 : displaydistance port map(ce=>key_start,load=>load0,clk=>clk,ge=>net16,shi=>net17,bai=>net18,qian=>net19,sel=>seldistance,outp=>outpdistance);--���⳵���������е�����������������ʾ
	u12 : state_controller port map(st=>key_start,qibu=>net3,clk=>clk,load=>load0,state_pricing=>net21,tenin=>net6);--״̬��
	u13 : lingcheng port map(clk=>clk,ceout=>net22,settime=>settimenet);--�賿״̬����
	u14 : starting_price port map(st=>key_start,load=>net20,night=>net22,clk=>clk,state_pricing=>net21,total_price=>net23,day_starting_price=>day_starting_pricenet,night_starting_price=>night_starting_pricenet);--�𲽼��ڼƼ�ģ��
	u15 : unit_price port map(st=>key_start,load=>net20,night=>net22,clk=>clk,state_pricing=>net21,yuancheng=>net4,minin=>net5,dp=>net2,total_price=>net24,day_starting_price=>day_starting_pricenet,night_starting_price=>night_starting_pricenet,day_timing_price=>day_timing_pricenet,day_long_distance_price=>day_long_distance_pricenet,day_mileage_price=>day_mileage_pricenet);--�𲽼���Ƽ�ģ��
	u16 : or2total port map(ce=>key_start,total1=>net24,total2=>net23,total=>net25,pricesel=>priceselnet,price=>pricenet);
	u17 : separateprice port map(ce=>key_start,load=>load0,clk=>clk,total=>net25,ge=>net26,shi=>net27,bai=>net28,qian=>net29);--�۸���
	u18 : displayprice port map(ce=>key_start,load=>load0,clk=>clk,a=>net26,b=>net27,c=>net28,d=>net29,sel=>selprice,outp=>outpprice);--�۸���ʾ
	--u19 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_start,key_out=>startnet);--��ʼ��������
	u19 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_time,key_out=>key_timenet);--���ó�ʼʱ�䰴������
	u20 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_select,key_out=>key_selectnet);--ѡ�񰴼�����
	u21 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_conform,key_out=>key_conformnet);--ȷ�ϰ�������
	u22 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_set,key_out=>key_setnet);--
	u23 : remove_jitter port map(clk=>clk,ce=>key_start,load=>load0,key_in=>key_price,key_out=>key_pricenet);--���ü۸񰴼�����
	u24 : SetInit port map(clk=>clk,time_state=>key_timenet,sel=>key_selectnet,set=>key_setnet,confirm=>key_conformnet,hour_s=>hour_snet,hour_f=>hour_fnet,min_s=>min_snet,min_f=>min_fnet,timesel=>timeselnet);
	u25 : settime port map(clk=>clk,ce=>key_start,load=>load0,hour_s=>hour_snet,hour_f=>hour_fnet,min_s=>min_snet,min_f=>min_fnet,settime=>settimenet);
	u26 : set_price port map(price_state=>key_pricenet,clk=>clk,sel=>key_selectnet,set=>key_setnet,confirm=>key_conformnet,day_starting_price_j=>day_starting_pricenet_j,day_starting_price_y=>day_starting_pricenet_y,day_starting_price_t=>day_starting_pricenet_t,day_starting_price_h=>day_starting_pricenet_h,night_starting_price_j=>night_starting_pricenet_j,night_starting_price_y=>night_starting_pricenet_y,night_starting_price_t=>night_starting_pricenet_t,night_starting_price_h=>night_starting_pricenet_h,day_mileage_price_j=>day_mileage_pricenet_j,day_mileage_price_y=>day_mileage_pricenet_y,day_mileage_price_t=>day_mileage_pricenet_t,day_mileage_price_h=>day_mileage_pricenet_h,day_timing_price_j=>day_timing_pricenet_j,day_timing_price_y=>day_timing_pricenet_y,day_timing_price_t=>day_timing_pricenet_t,day_timing_price_h=>day_timing_pricenet_h,day_long_distance_price_j=>day_long_distance_pricenet_j,day_long_distance_price_y=>day_long_distance_pricenet_y,day_long_distance_price_t=>day_long_distance_pricenet_t,day_long_distance_price_h=>day_long_distance_pricenet_h,pricesel=>priceselnet);
	u27 : setprice port map(clk=>clk,ce=>key_start,load=>load0,price_state=>key_pricenet,day_starting_price_j=>day_starting_pricenet_j,day_starting_price_y=>day_starting_pricenet_y,day_starting_price_t=>day_starting_pricenet_t,day_starting_price_h=>day_starting_pricenet_h,night_starting_price_j=>night_starting_pricenet_j,night_starting_price_y=>night_starting_pricenet_y,night_starting_price_t=>night_starting_pricenet_t,night_starting_price_h=>night_starting_pricenet_h,day_mileage_price_j=>day_mileage_pricenet_j,day_mileage_price_y=>day_mileage_pricenet_y,day_mileage_price_t=>day_mileage_pricenet_t,day_mileage_price_h=>day_mileage_pricenet_h,day_timing_price_j=>day_timing_pricenet_j,day_timing_price_y=>day_timing_pricenet_y,day_timing_price_t=>day_timing_pricenet_t,day_timing_price_h=>day_timing_pricenet_h,day_long_distance_price_j=>day_long_distance_pricenet_j,day_long_distance_price_y=>day_long_distance_pricenet_y,day_long_distance_price_t=>day_long_distance_pricenet_t,day_long_distance_price_h=>day_long_distance_pricenet_h,day_starting_price=>day_starting_pricenet,night_starting_price =>night_starting_pricenet,day_mileage_price=>day_mileage_pricenet,day_timing_price=>day_timing_pricenet,day_long_distance_price=>day_long_distance_pricenet);
	u28 : or5price port map(ce=>key_start,pricesel=>priceselnet,day_starting_price=>day_starting_pricenet,night_starting_price=>night_starting_pricenet, day_mileage_price=>day_mileage_pricenet,day_timing_price=>day_timing_pricenet,day_long_distance_price=>day_long_distance_pricenet,price=>pricenet);--���ü۸���ѡһ,�����������ʾ
	u29 : or2time port map(ce=>key_start,timesel=>timeselnet,ffen=>net12,sfen=>net13,fh=>net14,sh=>net15,vffen=>min_fnet,vsfen=>min_snet,vfh=>hour_fnet,vsh=>hour_snet,rffen=>net30,rsfen=>net31,rfh=>net32,rsh=>net33);
end architecture one;