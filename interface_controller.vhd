--	================================================================
--	system description
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.all;
entity interface_controller is port	(
		aclr				:in		std_logic;
		clk				:in		std_logic;
		hold			:in		std_logic;
		data_in_valid		:in		std_logic;
		frame_length		:in		std_logic_vector (11 downto 0);
		empty			:in		std_logic;
		transmit_data	:out	std_logic;
		transmit_length	:out	std_logic;
		receive_length	:out	std_logic
);
end interface_controller;
architecture behavior of interface_controller is	
--	================================================================
--	declarations
	type state is (idling, transmitting);
	signal	next_state			:	state;
	signal	current_state			:	state;
	signal	previous_state		:	state;
	signal	transmit_start		:	std_logic;
	signal	transmit_valid		:	std_logic;
	signal	data_in_valid_delay	:	std_logic;
	signal	transmit_countdown	:	std_logic_vector (11 downto 0);
--	================================================================
--	architecture description
begin
	-----------------------------------------------------------------------------------------------------------------------
	--generating transmit_countdown using down counter
		transmit_down_counter: counter port map (
			clk_en	=>transmit_valid ,
			cnt_en	=>transmit_valid,
			aclr		=>aclr,
			clock	=>clk ,
			data	=>frame_length ,
			sload	=>transmit_start ,
			q		=>transmit_countdown
		);
	-----------------------------------------------------------------------------------------------------------------------
	--generating instruction to transmit
		transmit_valid	<='1' when current_state = transmitting else '0';
		transmit_data	<=transmit_valid;
	-----------------------------------------------------------------------------------------------------------------------
	--generating instruction to start transmiting
		transmit_start	<='1' when (current_state = transmitting and previous_state = idling) else '0';
		transmit_length	<=transmit_start;
	-----------------------------------------------------------------------------------------------------------------------
	--generating instruction to receive length
	process (clk)
	begin
		if	rising_edge (clk) then data_in_valid_delay<=data_in_valid;
		end if;
	end process;
	receive_length<=data_in_valid and (not data_in_valid_delay) and (not aclr);
	--data_in_valid is high in receiving period; data_in_valid_delay is low in the 1st cycle of receiving period;
	--receive_length is high in the 1st cycle of receiving period if no aclr;
	-----------------------------------------------------------------------------------------------------------------------
	--transmitting state machine update mechanism
		process (clk, aclr)
		begin
			if	(aclr='1')	then	current_state<=idling; previous_state<=idling;
				elsif	rising_edge (clk)	then current_state<=next_state;	previous_state<= current_state;
			end if;
		end process;
	-----------------------------------------------------------------------------------------------------------------------
	--transmitting state machine next state evaluation
		process (current_state, transmit_countdown, empty, hold)
		begin
			case current_state is
				when idling=>
								if empty='0' and hold='0' then	next_state<=transmitting;
													else	next_state<=idling;
								end if;
				when transmitting=>
								if transmit_countdown="000000000010" then	next_state<=idling;
								--state machine should transit at countdown approximately at 0, careful timing ajustment required
															else	next_state<=transmitting;
								end if;
			end case;
		end process;
	-----------------------------------------------------------------------------------------------------------------------
end architecture;
