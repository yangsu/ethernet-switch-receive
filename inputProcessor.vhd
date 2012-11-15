LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY inputProcessor IS
	PORT (	aclr			:	IN STD_LOGIC;
			clk25			:	IN STD_LOGIC;
			clk50			:	IN STD_LOGIC;
			data_in			:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			data_in_valid	: 	IN STD_LOGIC;
			data_out		:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			data_out_valid	:	OUT STD_LOGIC;
			crc				:	OUT STD_LOGIC;
			frame_length	:	OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Max frame size is 1542 bytes
			receive_state	:	OUT STD_LOGIC;
			hold_state		:	OUT STD_LOGIC;
			reset_state		:	OUT STD_LOGIC);
END inputProcessor;

ARCHITECTURE subsystem_level_design OF inputProcessor IS

SIGNAL signal_frame_start	:	STD_LOGIC; -- Output of SFD module, HIGH once SFD is detected
SIGNAL signal_hold_count	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL signal_receiving		:	STD_LOGIC;
SIGNAL signal_reset				:	STD_LOGIC;
SIGNAL signal_hold				:	STD_LOGIC;
SIGNAL signal_crc_check			: 	STD_LOGIC;
SIGNAL signal_data_out		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL signal_readBuffer	:	STD_LOGIC;
SIGNAL signal_crc					:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL signal_shifter			:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL crc_valid					:	STD_LOGIC;
SIGNAL signal_frame_counter_length	:	STD_LOGIC_VECTOR(11 DOWNTO 0); 
SIGNAL signal_frame_current_length	:	STD_LOGIC_VECTOR(11 DOWNTO 0); 
SIGNAL signal_frame_register_length	:	STD_LOGIC_VECTOR(11 DOWNTO 0); 
SIGNAL signal_next_length	:	STD_LOGIC; 




	COMPONENT inputProcessor_stateController IS
		PORT (
			aclr				:	IN 	STD_LOGIC;
			clk					:	IN 	STD_LOGIC;
			frame_start	:	IN 	STD_LOGIC;
			frame_valid	:	IN 	STD_LOGIC; -- Output of SFD module, HIGH once SFD is detected
			crc_valid 	: IN 	STD_LOGIC;
			hold_count	:	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
			receiving		:	OUT STD_LOGIC; -- HIGH if currently in receiving state; will act as enable signal for other modules
			reset				:	OUT STD_LOGIC; -- HIGH if transitioned into IDLE state; resets all components for next frame
			hold				:	OUT STD_LOGIC;-- HIGH if transitioned into HOLD state; must remain in state until  hold_count = 12
			crc_check			:	OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT sfdChecker IS
		PORT (	aclr		:	IN STD_LOGIC;
				clk			:	IN STD_LOGIC;
				enable	    :   IN STD_LOGIC;
				data_in		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				frame_start	:	OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT frameBuffer
		PORT (
			aclr			:IN		STD_LOGIC;
			clk25			:IN		STD_LOGIC;
			clk50			:IN		STD_LOGIC;
			read_enable		:IN		STD_LOGIC;
			write_enable	:IN		STD_LOGIC;
			data_in			:IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			data_out		:OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT crcChecker IS
		PORT (	aclr			: IN		STD_LOGIC;
				clk				: IN		STD_LOGIC;
				compute_enable	: IN		STD_LOGIC;
				u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
				CRC_out			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0) );
	END COMPONENT;

	COMPONENT frameCounter IS
		PORT (	aclr		:	IN STD_LOGIC;
				clk			:	IN STD_LOGIC;
				enable		:	IN STD_LOGIC;
				count		:	OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
	END COMPONENT;

	COMPONENT holdCounter IS
		PORT (	aclr		:	IN STD_LOGIC;
				clk			:	IN STD_LOGIC;
				enable		:	IN STD_LOGIC;
				count		:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT countdown_stateController IS
		PORT (	aclr				:	IN 	STD_LOGIC;
				clk					:	IN 	STD_LOGIC;
				begin_count			:	IN 	STD_LOGIC; 
				frame_length		:	IN 	STD_LOGIC_VECTOR(11 DOWNTO 0);
				counting			:	OUT STD_LOGIC;
				next_length			:	OUT STD_LOGIC  
		);
	END COMPONENT;
	
	COMPONENT register12bit IS
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			enable		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT lengthBuffer IS
		PORT
		(
			aclr		: IN STD_LOGIC  := '0';
			data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			rdclk		: IN STD_LOGIC ;
			rdreq		: IN STD_LOGIC ;
			wrclk		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
		);
	END COMPONENT;


BEGIN

	Stage1: inputProcessor_stateController PORT MAP (aclr, clk50, signal_frame_start, data_in_valid, crc_valid, signal_hold_count, signal_receiving, signal_reset, signal_hold, signal_crc_check);
	Stage2: sfdChecker PORT MAP (aclr OR signal_reset, clk25, data_in_valid, data_in, signal_frame_start);
	Stage3: frameBuffer PORT MAP (aclr OR signal_reset, clk25, clk50, '1', signal_receiving, data_in, signal_data_out);
	Stage4: crcChecker PORT MAP (aclr OR signal_reset, clk25, signal_receiving, data_in, signal_crc);
	Stage5: frameCounter PORT MAP (aclr OR signal_reset, clk25, signal_receiving, signal_frame_counter_length);
	Stage6: holdCounter PORT MAP (aclr OR signal_reset, clk25, signal_hold, signal_hold_count);
	Stage7: data_out <= signal_data_out;
	Stage8: countdown_stateController PORT MAP (aclr OR signal_reset, clk50, crc_valid, signal_frame_register_length, data_out_valid, signal_next_length);
	Stage9: register12bit PORT MAP (aclr OR signal_reset, clk50, signal_frame_current_length, signal_next_length, signal_frame_register_length);
	Stage10: lengthBuffer PORT MAP (aclr OR signal_reset, signal_frame_counter_length, clk50, signal_next_length, clk25, signal_crc_check, signal_frame_current_length);
	

	receive_state <= signal_receiving;
	hold_state <= signal_hold;
	reset_state <= signal_reset;

	signal_shifter(31 DOWNTO 4) <= signal_shifter(27 DOWNTO 0);
	signal_shifter(3 DOWNTO 0) <= data_in;

	crc_valid <= '1' WHEN (signal_shifter XOR signal_crc) = "11111111111111111111111111111111" ELSE '0';
	crc <= crc_valid;
	
	frame_length <= signal_frame_current_length;
	
	
END subsystem_level_design;
