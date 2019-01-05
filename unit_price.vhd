--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--�𲽼���Ƽ�
entity unit_price is
	--generic(
				--day_starting_price : integer range 0 to 200 := 100;		--�����𲽼�
				--night_starting_price : integer range 0 to 200 := 120;		--ҹ���𲽼�
				--day_mileage_price : integer range 0 to 100 := 30;			--������ͨ��̼۸�
				--day_timing_price : integer range 0 to 100 := 30;			--�����ʱ�Ƽ�
				--day_long_distance_price : integer range 0 to 100 := 40	--���쳤;�Ƽ�
				--night_mileage_price :integer range 0 to 100 := 40;
				--ҹ���ʱ����
				--night_timing_price :integer range 0 to 100 := 40;
				--ҹ�䳤;����
				--night_long_distance_price : integer range 0 to 100 := 50
	--);
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
				--ҹ����̵���
				--night_mileage_price : in integer range 0 to 100 := day_mileage_price + 10;
				--ҹ���ʱ����
				--night_timing_price : in integer range 0 to 100 := day_timing_price + 10;
				--ҹ�䳤;����
				--night_long_distance_price : in integer range 0 to 100 := day_long_distance_price + 10;
				--����״̬���жϵļƼ�״̬
				state_pricing : in integer range 1 to 4;
				--����
				total_price : out integer range 0 to 10000;
				day_starting_price :in integer range 0 to 200;		--�����𲽼�
				night_starting_price :in integer range 0 to 200;		--ҹ���𲽼�
				day_mileage_price :in integer range 0 to 100;			--������ͨ��̼۸�
				day_timing_price :in integer range 0 to 100;			--�����ʱ�Ƽ�
				day_long_distance_price :in integer range 0 to 100	--���쳤;�Ƽ�
	);
end entity unit_price;

architecture unit of unit_price is
	signal mileage_price_sum : integer range 0 to 10000;
	signal timing_price_sum : integer range 0 to 10000;
begin
	process ( night , dp , clk, yuancheng ,  minin , state_pricing , load, state_pricing,day_starting_price,night_starting_price,day_mileage_price,day_timing_price,day_long_distance_price)
	variable night_mileage_price :integer range 0 to 100 := 40;
	variable night_timing_price :integer range 0 to 100 := 40;
	variable night_long_distance_price : integer range 0 to 100 := 50;
	begin
		if clk='1' and clk'event then
				night_mileage_price := day_mileage_price + 10;
				--ҹ���ʱ����
				night_timing_price := day_timing_price + 10;
				--ҹ�䳤;����
				night_long_distance_price := day_long_distance_price + 10;
			if state_pricing = 1 and load = '1' then    --�ܼ۸�λΪ0
				total_price <= 0;
				mileage_price_sum <= 0 ;
				timing_price_sum <=0 ;
			end if;
			if state_pricing = 3 then
				if night = '1' then
					if dp = '1' then
						if yuancheng = '1' then
							mileage_price_sum <= mileage_price_sum + night_long_distance_price ; --ҹ��Զ�̼Ƽ�
						elsif yuancheng = '0' then
							mileage_price_sum <= mileage_price_sum + night_mileage_price ; --ҹ����ͨ�Ƽ�
						end if;
					end if;
					if minin = '1' then
						timing_price_sum <= timing_price_sum + night_timing_price;--ҹ���ʱ�Ƽ�
					end if;
				total_price <= mileage_price_sum + timing_price_sum + night_starting_price;
				elsif night = '0' then
					if dp = '1' then
						if yuancheng='1' then
							mileage_price_sum <= mileage_price_sum + day_long_distance_price ;--����Զ��
						elsif yuancheng = '0' then
							mileage_price_sum <=  mileage_price_sum + day_mileage_price ;--������ͨ
						end if;
					end if;
					if minin = '1' then
						timing_price_sum <= timing_price_sum + day_timing_price;  --�����ʱ�Ƽ�
					end if;
				total_price <= mileage_price_sum + timing_price_sum + day_starting_price;
				end if;
			end if;
		end if;
	end process;
end unit;