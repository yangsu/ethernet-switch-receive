LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY receive IS
	PORT (
		aclr					:	IN STD_LOGIC;
		clk25					:	IN STD_LOGIC;
		clk50					:	IN STD_LOGIC;
		hold					:	IN STD_LOGIC;
	);
END receive;

ARCHITECTURE rcv OF receive IS

	COMPONENT inputProcessor IS
		PORT (
			aclr						:	IN  STD_LOGIC;
			clk25						:	IN  STD_LOGIC;
			clk50						:	IN  STD_LOGIC;
			data_in					:	IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			data_in_valid		:	IN  STD_LOGIC;
			data_out				:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			data_out_valid	:	OUT STD_LOGIC;
			crc							:	OUT STD_LOGIC;
			frame_length		:	OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Max frame size is 1542 bytes
			receive_state		:	OUT STD_LOGIC;
			hold_state			:	OUT STD_LOGIC;
			reset_state			:	OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT MII_to_RCV IS
	PORT (	Clock25		: IN		STD_LOGIC;
			Resetx		: IN		STD_LOGIC;
			rcv_data_valid	: OUT	STD_LOGIC;
			rcv_data	:OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
	END COMPONENT;

	SIGNAL data_in					: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL data_in_valid		: STD_LOGIC;
	SIGNAL data_out				:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_out_valid	:	STD_LOGIC;
	SIGNAL crc						:	STD_LOGIC;
	SIGNAL frame_length		:	STD_LOGIC_VECTOR(11 DOWNTO 0); -- Max frame size is 1542 bytes
	SIGNAL receive_state	:	STD_LOGIC;
	SIGNAL hold_state			:	STD_LOGIC;
	SIGNAL reset_state		:	STD_LOGIC;
BEGIN
	inputProc : inputProcessor PORT MAP (
		aclr => aclr,
		clk25 => clk25,
		clk50 => clk50,
		data_in => data_in,
		data_in_valid => data_in_valid,
		data_out => data_out,
		data_out_valid => data_out_valid,
		crc => crc,
		frame_length => frame_length,
		receive_state => receive_state,
		hold_state => hold_state,
		reset_state => reset_state
	);

	physim: MII_to_RCV PORT MAP (
		Clock25 => clk25,
		Resetx => aclr,
		rcv_data_valid => data_in_valid,
		rcv_data => data_in
	);

END rcv