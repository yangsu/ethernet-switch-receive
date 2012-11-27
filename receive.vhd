LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY receive IS
	PORT (
		aclr						:	IN STD_LOGIC;
		clk50						:	IN STD_LOGIC;
		-- clk25						:	IN STD_LOGIC;
		-- clk50						:	IN STD_LOGIC;
		-- hold						:	IN STD_LOGIC;
		data_in						:	BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
		data_in_valid				: 	BUFFER STD_LOGIC;
		data_out					:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out_valid				:	OUT STD_LOGIC;
		crc							:	OUT STD_LOGIC; -- testing
		computed_crc				:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- testing
		last_word					:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- testing
		frame_length				:	OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Max frame size is 1542 bytes
		receive_state				:	OUT STD_LOGIC; -- testing
		hold_state					:	OUT STD_LOGIC; -- testing
		crc_check_state				:	OUT STD_LOGIC; -- testing
		reset_state					:	OUT STD_LOGIC  -- testing
	);
END receive;

ARCHITECTURE rcv OF receive IS

	COMPONENT inputProcessor IS
		PORT (
			aclr						:	IN  STD_LOGIC;
			clk25						:	IN  STD_LOGIC;
			clk50						:	IN  STD_LOGIC;
			data_in						:	IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			data_in_valid				:	IN  STD_LOGIC;
			data_out					:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			data_out_valid				:	OUT STD_LOGIC;
			crc							:	OUT STD_LOGIC;
			computed_crc				:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			last_word					:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- testing
			frame_length				:	OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Max frame size is 1542 bytes
			receive_state				:	OUT STD_LOGIC;
			hold_state					:	OUT STD_LOGIC;
			crc_check_state				:	OUT STD_LOGIC;
			reset_state					:	OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT MII_to_RCV IS
	PORT (
		Clock25					: IN		STD_LOGIC;
		Resetx					: IN		STD_LOGIC;
		rcv_data_valid	: OUT	STD_LOGIC;
		rcv_data				: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	END COMPONENT;


	COMPONENT pll IS
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL clk25 : STD_LOGIC;

	COMPONENT imem IS
	PORT
		(
			address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			clken		: IN STD_LOGIC  := '1';
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT counter IS
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			cnt_en		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			sload		: IN STD_LOGIC ;
			updown		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL address : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL data : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN

	div: pll PORT MAP (clk50, clk25);

	inputProc : inputProcessor PORT MAP (
		aclr => aclr,
		clk25 => clk25,
		clk50 => clk50,
		data_in => data_in,
		data_in_valid => data_in_valid,
		data_out => data_out,
		data_out_valid => data_out_valid,
		crc => crc,
		computed_crc => computed_crc,
		last_word => last_word,
		frame_length => frame_length,
		receive_state => receive_state,
		hold_state => hold_state,
		crc_check_state => crc_check_state,
		reset_state => reset_state
	);

	physim: MII_to_RCV PORT MAP (
		Clock25 => clk25,
		Resetx => aclr,
		rcv_data_valid => data_in_valid,
		rcv_data => data_in
	);

	memory: imem PORT MAP (
		address	=> address,
		clken		=> NOT aclr,
		clock		=> clk25,
		q				=> data
	);

	PCCounter: counter PORT MAP (
		aclr		=> aclr,
		clock		=> clk25,
		cnt_en	=> NOT aclr,
		data		=> "000000000000",
		sload		=> '0',
		updown		=> '1',
		q		=> address
	);

END rcv;