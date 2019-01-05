--�������ʾʱ��
--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--��ʼ����
entity displaytime is
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
--��������
end displaytime;
--����������one
architecture one of displaytime is
begin
--��������
process(ffen,sfen,fh,sh,ce,clk)
	variable sell:std_logic_vector(2 downto 0);
	variable temp:std_logic_vector(3 downto 0);
	variable fhflag:std_logic:='0';--��һ��Сʱ
	variable sfenflag:std_logic:='0';--�ڶ�������
	begin
	--��û�������ź����룬������������
	if load='0'then
		--��ʹ������Ϊ1��������������
		if ce='1' then
			--λѡ
			if rising_edge(clk)  then
				case sell is
					when "000" =>
						sell:="001";
						temp:=ffen;--00:0x
					when "001" =>
						sell:="010";--00:x0������ʾ
						temp:=sfen;
						sfenflag:='1';
					when "010" =>
						sell:="100";--0x:00
						temp:=fh;
						fhflag:='1';
					when "100" =>
						sell:="000";
						temp:=sh;--x0:00
					when others =>
						null;
				end case;
				if fhflag='0' and sfenflag='0' then--������ʾ����С����
					case temp is--��ѡ����,������С����
						when"0000"=>outp<="00111111";--0
						when"0001"=>outp<="00000110";--1
						when"0010"=>outp<="01011011";--2
						when"0011"=>outp<="01001111";--3
						when"0100"=>outp<="01100110";--4
						when"0101"=>outp<="01101101";--5
						when"0110"=>outp<="01111101";--6
						when"0111"=>outp<="00000111";--7
						when"1000"=>outp<="01111111";--8
						when"1001"=>outp<="01101111";--9
						when others=>outp<=null;
					end case;
					sel<=sell;
				elsif fhflag='1' then--������ʾ����С����
					fhflag:='0';
					case temp is
						when"0000"=>outp<="10111111";--0
						when"0001"=>outp<="10000110";--1
						when"0010"=>outp<="11011011";--2
						when"0011"=>outp<="11001111";--3
						when"0100"=>outp<="11100110";--4
						when"0101"=>outp<="11101101";--5
						when"0110"=>outp<="11111101";--6
						when"0111"=>outp<="10000111";--7
						when"1000"=>outp<="11111111";--8
						when"1001"=>outp<="11101111";--9
						when others=>outp<=null;
					end case;
					sel<=sell;
				elsif sfenflag='1' then
					sfenflag:='0';--������ʾ��С����
					case temp is
						when"0000"=>outp<="10111111";--0
						when"0001"=>outp<="10110000";--1
						when"0010"=>outp<="11011011";--2
						when"0011"=>outp<="11110011";--3
						when"0100"=>outp<="11110100";--4
						when"0101"=>outp<="11101101";--5
						when"0110"=>outp<="11101111";--6
						when"0111"=>outp<="10111000";--7
						when"1000"=>outp<="11111111";--8
						when"1001"=>outp<="11111101";--9
						when others=>outp<=null;
					end case;
					sel<=sell;
				end if;
			end if;
		end if;	
	--�������ź�
	else
		--��ʾĬ������
		outp<="00111111";
		 sell:=(others=>'0');
	end if;
	--��������
	end process;
--����������
end one;