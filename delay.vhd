--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--��ʼ����
entity delay is
	port
	(
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
--��������
end delay;

--����һ��������
architecture one of delay is
begin
	process(ce,clk,cein) 
	variable time:integer range 0 to 601:=0;
	variable ten:integer range 0 to 11:=0;
	begin
		if load='0' then
			if ce='1' then
				if clk='1' and clk'event then
					if cein='0' then--��ʱ�Ƽ�
						if time < 600 then
							time:=time+1;
							ceout<='0';
						else
							time:=0;
							ten:=ten+1;
							ceout<='1';
						end if;
						if ten < 10 then
							tenout<='0';
						else
							tenout<='1';
							ten:=11;
						end if;
					end if;
				end if;
			end if;
		else
			time:=0;
			ten:=0;
			ceout<='0';
			tenout<='0';
		end if;
	end process;
end one;
