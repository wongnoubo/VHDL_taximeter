	--���ø���ͷ�ļ�
	--�Ƽ۷�����
	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	--��ʼ����
	entity bee is
		port
		(
		ce : in std_logic;
		qibu : in std_logic;--���ź�
		run_pulse : in std_logic;--�������
		wait_pulse : in std_logic;--�ȴ�ʱ������
		bee_pulse : out std_logic--����������
		);
	--��������
	end bee;
	--����������one
	architecture one of bee is
		begin
	process(ce,run_pulse,wait_pulse,qibu)
		begin
		if ce='1' then
			if qibu='1' then 
				if run_pulse='1' then 
					bee_pulse<='1';
				elsif wait_pulse='1' then
					bee_pulse<='1';
				else
					bee_pulse<='0';
				end if;
			else
				bee_pulse<='0';
			end if;
		end if;
		end process;
	--����������
	end one;
