--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--��ʼ����
entity hl is
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
--��������
end hl;

--����һ��������
architecture one of hl is
begin
	process(ce,clk,din) 
	variable time:integer range 0 to 24:=0;
	begin
		if load='0' then
			if ce='1' then
				if clk='1' and clk'event then
					if time < 21 then
						time:=time+1;
					else
						time:=21;
					end if;
				end if;
				if din='1' then
					time:=0;
				end if;
				if time>20 then
					ceout<='0';
				else
					ceout<='1';
				end if;
			end if;
		else
			time:=0;
			ceout<='0';
		end if;
	end process;
end one;
