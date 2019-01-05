	--���ø���ͷ�ļ�
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--��ʼ����
	entity or5price is
		port
		(
		ce : in std_logic;
		pricesel : in integer;
		day_starting_price :in integer range 0 to 9999;--�����𲽼�
		night_starting_price :in integer range 0 to 9999;--ҹ���𲽼�
		day_mileage_price:in integer range 0 to 9999;--������ͨ��̼۸�
		day_timing_price :in integer range 0 to 9999;--�����ʱ�Ƽ�
		day_long_distance_price :in integer range 0 to 9999;  --���쳤;
		price	: out integer range 0 to 9999
		);
	--��������
	end or5price;
	--����������one
	architecture one of or5price is
		begin
	process(ce,day_starting_price,night_starting_price,day_mileage_price,day_timing_price,day_long_distance_price)
		begin
		if ce='1' then
			if pricesel=1 then--1 ����ʾ�����𲽼�
				price<=day_starting_price;
			elsif pricesel=2 then--2 ��ҹ���𲽼�
				price<=night_starting_price;
			elsif pricesel=3 then--3 �ǰ������
				price<=day_mileage_price;
			elsif pricesel=4 then--4 �� �����ʱ
				price<=day_timing_price;
			elsif pricesel=5 then--5 �ǰ��쳤;
				price<=day_long_distance_price;
			end if;
		end if;
		end process;
	--����������
	end one;
