LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY countdown_stateController IS
	PORT (
		aclr				:	IN 	STD_LOGIC;
		clk					:	IN 	STD_LOGIC;
		begin_count			:	IN 	STD_LOGIC; 
		frame_length_and_crc:	IN 	STD_LOGIC_VECTOR(11 DOWNTO 0);
		counting			:	OUT STD_LOGIC;
		data_out_valid		:	OUT STD_LOGIC;
		next_length			:	OUT STD_LOGIC  
	);
END countdown_stateController;

ARCHITECTURE state OF countdown_stateController IS

TYPE countdownState IS (IDLE_STATE, POP_STATE, LOAD_STATE, COUNTING_STATE);
SIGNAL countdown_currentState, countdown_nextState	:	countdownState;

SIGNAL signal_loadNext : STD_LOGIC;
SIGNAL signal_count : STD_LOGIC;
SIGNAL signal_pre_count : STD_LOGIC;
SIGNAL signal_currentCount : STD_LOGIC_VECTOR(11 DOWNTO 0);

	COMPONENT countdownCounter IS
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			cnt_en		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			sload		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
-- State Register Update
	PROCESS (clk, aclr)
	BEGIN
		IF (aclr = '1') THEN
			countdown_currentState <= IDLE_STATE;
		ELSIF (clk'EVENT AND clk = '1') THEN
			countdown_currentState <= countdown_nextState;
		END IF;
	END PROCESS;

-- Next State Logic
	PROCESS (countdown_currentState, begin_count, signal_currentCount)
	BEGIN
		CASE countdown_currentState IS
			WHEN IDLE_STATE =>
				IF begin_count = '1' THEN countdown_nextState <= POP_STATE;
				ELSE countdown_nextState <= IDLE_STATE;
				END IF;
			WHEN POP_STATE =>
				countdown_nextState <= LOAD_STATE;
			WHEN LOAD_STATE =>
				countdown_nextState <= COUNTING_STATE;
			WHEN COUNTING_STATE =>
				IF signal_currentCount = "000000000001" THEN countdown_nextState <= IDLE_STATE;
				ELSE countdown_nextState <= COUNTING_STATE;
				END IF;
			
		END CASE;
	END PROCESS;

-- Moore Output Logic
	PROCESS (countdown_currentState)
	BEGIN
		-- Default values
		signal_count <= '0';
		signal_pre_count <= '0';
		signal_loadNext <= '0';
		next_length <= '0';
		
		IF countdown_currentState = LOAD_STATE THEN signal_loadNext <= '1';
		ELSE signal_loadNext <= '0';
		END IF;
		
		IF countdown_currentState = LOAD_STATE THEN signal_pre_count <= '1';
		ELSE signal_pre_count <= '0';
		END IF;
		
		IF countdown_currentState = COUNTING_STATE THEN signal_count <= '1';
		ELSE signal_count <= '0';
		END IF;
		
		IF countdown_currentState = POP_STATE THEN next_length <= '1';
		ELSE next_length <= '0';
		END IF;

	END PROCESS;

-- OTHER	
	stage0: countdownCounter PORT MAP (aclr, clk, signal_count, "0" & frame_length_and_crc(10 DOWNTO 0), signal_loadNext, signal_currentCount);
	stage1: counting <= signal_count OR signal_pre_count;
	stage2: data_out_valid <= frame_length_and_crc(11) AND signal_count;

END state; 

