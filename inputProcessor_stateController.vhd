LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY inputProcessor_stateController IS
	PORT (	aclr		:	IN STD_LOGIC;
			clk			:	IN STD_LOGIC;
			frame_start	:	IN STD_LOGIC; -- Output of SFD module, HIGH once SFD is detected
			frame_end	:	IN STD_LOGIC; -- Input from data_in_valid
			hold_count	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			receiving	:	OUT STD_LOGIC; -- HIGH if currently in receiving state; will act as enable signal for other modules
			reset		:	OUT STD_LOGIC; -- HIGH if transitioned into IDLE state; resets all components for next frame
			hold		:	OUT STD_LOGIC); -- HIGH if transitioned into HOLD state; must remain in state until hold_count = 12
END inputProcessor_stateController;

ARCHITECTURE state OF inputProcessor_stateController IS
	
TYPE inputProcessorState IS
	(IDLE_STATE, RECEIVING_STATE, HOLD_STATE, RESET_STATE);
SIGNAL inputProcessor_currentState, inputProcessor_nextState	:	inputProcessorState;

BEGIN
-- State Register Update
	PROCESS (clk, aclr)
	BEGIN
		IF (aclr = '1') THEN 
			inputProcessor_currentState <= IDLE_STATE;
		ELSIF (clk'EVENT AND clk = '1') THEN
			inputProcessor_currentState <= inputProcessor_nextState;
		END IF;
	END PROCESS;

-- Next State Logic
	PROCESS (inputProcessor_currentState, frame_start, frame_end)
	BEGIN
		CASE inputProcessor_currentState IS
			WHEN IDLE_STATE =>
				IF frame_start = '1' THEN inputProcessor_nextState <= RECEIVING_STATE; 
				ELSE inputProcessor_nextState <= IDLE_STATE;
				END IF;
			WHEN RECEIVING_STATE =>
				IF frame_end = '0' THEN inputProcessor_nextState <= HOLD_STATE;
				ELSE inputProcessor_nextState <= RECEIVING_STATE;				
				END IF;
			WHEN HOLD_STATE =>
				if hold_count = "0110" then inputProcessor_nextState <= IDLE_STATE;
				ELSE inputProcessor_nextState <= HOLD_STATE;
				END IF;
			WHEN RESET_STATE =>
				inputProcessor_nextState <= IDLE_STATE;
		END CASE;
	END PROCESS;

-- Moore Output Logic
	PROCESS (inputProcessor_currentState)
	BEGIN
		-- Default values
		receiving <= '0';
		reset <= '0';
		hold <= '0'; 
		IF inputProcessor_currentState = RECEIVING_STATE THEN receiving <= '1';
		ELSE receiving <= '0';
		END IF;
		IF inputProcessor_currentState = RESET_STATE THEN reset <= '1';
		ELSE reset <= '0';
		END IF;
		IF inputProcessor_currentState = HOLD_STATE THEN hold <= '1';
		ELSE hold <= '0';
		END IF;
	END PROCESS;
	
END state;
