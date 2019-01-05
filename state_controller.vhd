--״̬��
--���ø���ͷ�ļ�
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--״̬��
entity state_controller is
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
end entity state_controller;

architecture control of state_controller is
	type FSM_ST is ( start_reset , stop , within_starting_price , beyond_starting_price );         
	--start_reset ����ʼ����λ��stop��ֹͣ�Ƽ� �� within_starting_price���𲽼��� ��beyond_starting_price���𲽼���
	signal current_state , next_state : FSM_ST;
	--������
	signal state_start : std_logic;
begin
	REG : 	process(clk ,st)            --����ʱ�����
			begin
				if st = '0' then
					current_state <= stop ;
				elsif clk='1' and clk'event then
					current_state <= next_state;
				end if;
			end process REG;--        ��λ ʹ��
	
	COM : 	process( current_state , qibu , st , tenin )  --������Ͻ���
			begin
				case current_state is 
					when start_reset =>
						load <= '1';
						state_pricing <= 1;
						state_start <= '1';
						next_state <= within_starting_price;
					when within_starting_price =>
						load <= '0';
						state_pricing <= 2;
						if st = '0' then
							next_state <= stop;
						end if;
						if st = '1' and qibu = '1' and state_start = '1' then
							next_state <= beyond_starting_price;
						end if;
						if st = '1' and qibu = '0' and state_start = '1' and tenin = '1' then
							next_state <= beyond_starting_price;
						end if;
						if st = '1' and qibu = '0' and state_start = '1' and tenin = '0' then
							next_state <= within_starting_price;
						end if;
					when beyond_starting_price =>
						load <= '0';
						state_pricing <= 3;
						if st = '0' then
							next_state <= stop;
						end if;
						if st = '1' and qibu = '1' and state_start = '1' then
							next_state <= beyond_starting_price;
						end if;
					when stop =>
						load <= '0';
						state_pricing <= 4;
						state_start <= '0';
						if st = '1' then
							next_state <= start_reset ;
						end if;
					when others =>
						load <= '0';
						state_pricing <= 4;
						next_state <= stop;
				end case;
			end process COM;
end;