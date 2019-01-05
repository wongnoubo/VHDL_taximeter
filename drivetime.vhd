--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--��ʼ����
entity drivetime is
	port
	(
	--����dinΪ�߼����룬����������ʱ���ź�
	--����ceΪ�߼����룬������ʹ�ܣ�����0ʱ��Ч
	--����loadΪ�߼����룬����������
	din,ce,load	: in std_logic;
	--ÿ���� dout='1'
	dout	: out std_logic;
	--ʮ���� tenout='1'
	tenout : out std_logic
	);
--��������
end drivetime;
--����������one
architecture one of drivetime is
begin
--��������
process(din,ce)
	--����һ��10λ����q
	variable q:std_logic_vector(9 downto 0);
	--10mins����
	variable ten:std_logic_vector(3 downto 0);
	begin
	--��û�������ź����룬������������
	if load='0'then
		--��ʹ������Ϊ0��������������
		if ce='0' then
			--����dinΪ������ʱ��ִ���������
			if din'event and din='1' then
				--�ж�q�Ƿ����600��Ҳ�����Ƿ�ﵽ1���ӣ�qС��600��û�ﵽһ����
				if q<600 then
					--q��һ
					q:=q+1;
				--�ﵽһ����
				else 
					--q����
					q:=(others=>'0');
				end if;
				--�ж�q����ֵ�Ƿ����600��Ҳ�����Ƿ�ﵽ1���ӣ�q����600���ﵽ1����
				if q="1001011000" then 
					ten:=ten+1;
				--���һ������
					dout<='1';
				--û�ﵽһ����
				else
				--���������
					dout<='0';
				end if;
				if ten < 10 then
					tenout<='0';
				else
					tenout<='1';
					ten:="1011";
				end if;
			end if;
		end if;	
	--�������ź�
	else
	--��ֵ����
		q:=(others=>'0');
		ten:=(others=>'0');
		tenout<='0';
	end if;
	--��������
	end process;
--����������
end one;