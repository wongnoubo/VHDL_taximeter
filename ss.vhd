	--���ø���ͷ�ļ�
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--��ʼ����
	entity ss is
		port
		(
		--����dinΪ�߼����룬����������ʱ���ź�
		--����loadΪ�߼����룬����������
		start	: in std_logic;
		ce,load	: out std_logic
		);
	--��������
	end ss;
	--����������one
	architecture one of ss is
	begin
	--��������
	process(start)
		begin
		--��������	--��ʹ������Ϊ1��������������
		load<=start and '1';
		ce<=start xor '1';
		end process;
	--����������
	end one;
