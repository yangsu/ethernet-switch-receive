--	================================================================
--	system description
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_misc.all;
USE work.all;
ENTITY interface_controller IS PORT	(
	aclr				:in		STD_LOGIC;
	clk					:in		STD_LOGIC;
	hold				:in		STD_LOGIC;
	data_in_valid		:in		STD_LOGIC;
	frame_length		:in		STD_LOGIC_VECTOR (11 DOWNTO 0);
	empty				:in		STD_LOGIC;
	transmit_data		:out	STD_LOGIC;
	transmit_length	:out	STD_LOGIC;
	receive_length	:out	STD_LOGIC
);
END interface_controller;
ARCHITECTURE behavior of interface_controller IS
--	================================================================
--	declarations
	TYPE state IS (idling, transmitting);
	SIGNAL	next_state				:	state;
	SIGNAL	current_state			:	state;
	SIGNAL	previous_state		:	state;
	SIGNAL	transmit_start			:	STD_LOGIC;
	SIGNAL	transmit_valid			:	STD_LOGIC;
	SIGNAL	data_in_valid_delay	:	STD_LOGIC;
	SIGNAL	transmit_countdown	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
--	================================================================
--	ARCHITECTURE description
BEGIN
	-----------------------------------------------------------------------------------------------------------------------
	--generating transmit_countdown using down counter
		transmit_down_counter: counter PORT MAP (
			cnt_en		=>	transmit_valid,
			aclr		=>	aclr,
			clock		=>	clk ,
			data		=>	frame_length ,
			sload		=>	transmit_start ,
			updown	=> '0',
			q			=>	transmit_countdown
		);
	-----------------------------------------------------------------------------------------------------------------------
	--generating instruction to transmit
		transmit_valid	<= '1' WHEN current_state = transmitting ELSE '0';
		transmit_data	<= transmit_valid;
	-----------------------------------------------------------------------------------------------------------------------
	--generating instruction to start transmiting
		transmit_start	<='1' WHEN (current_state = transmitting AND previous_state = idling) ELSE '0';
		transmit_length <=transmit_start;
	-----------------------------------------------------------------------------------------------------------------------
	--generating instruction to receive length
	PROCESS (clk)
	BEGIN
		IF	rising_edge (clk) THEN data_in_valid_delay<=data_in_valid;
		END IF;
	END PROCESS;
	receive_length<=data_in_valid AND (NOT data_in_valid_delay) AND (NOT aclr);
	--data_in_valid is high in receiving period; data_in_valid_delay is low in the 1st cycle of receiving period;
	--receive_length is high in the 1st cycle of receiving period if no aclr;
	-----------------------------------------------------------------------------------------------------------------------
	--transmitting state machine update mechanism
		PROCESS (clk, aclr)
		BEGIN
			IF	(aclr='1')	THEN	current_state<=idling; previous_state<=idling;
				elsif	rising_edge (clk)	THEN current_state<=next_state;	previous_state<= current_state;
			END IF;
		END PROCESS;
	-----------------------------------------------------------------------------------------------------------------------
	--transmitting state machine next state evaluation
		PROCESS (current_state, transmit_countdown, empty, hold)
		BEGIN
			case current_state IS
				WHEN idling=>
								IF empty='0' AND hold='0' THEN	next_state<=transmitting;
													ELSE	next_state<=idling;
								END IF;
				WHEN transmitting=>
								IF transmit_countdown="000000000010" THEN	next_state<=idling;
								--state machine should transit at countdown approximately at 0, careful timing ajustment required
															ELSE	next_state<=transmitting;
								END IF;
			END case;
		END PROCESS;
	-----------------------------------------------------------------------------------------------------------------------
END ARCHITECTURE;
