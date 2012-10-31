LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY receive IS
	PORT (
		aclr				:	IN		STD_LOGIC;
		hold				:	IN		STD_LOGIC;
		clk25				:	IN		STD_LOGIC;
		clk50				:	IN		STD_LOGIC;
		data_in			:	IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		data_in_valid		:	IN		STD_LOGIC;
		data_out_valid		:	OUT	STD_LOGIC;
		data_out			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		frame_length_out	:	OUT	STD_LOGIC_VECTOR(11 DOWNTO 0));
END receive;

ARCHITECTURE high_level_design OF receive IS
SIGNAL signal_data				:	STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL signal_data_valid		:	STD_LOGIC;
SIGNAL signal_crc_complete	:	STD_LOGIC;
SIGNAL signal_frame_length	:	STD_LOGIC_VECTOR(11 DOWNTO 0);

	COMPONENT inputProcessor
	PORT (
		aclr			:	IN STD_LOGIC;
		clk25			:	IN STD_LOGIC;
		clk50			:	IN STD_LOGIC;
		data_in			:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		data_in_valid	: 	IN STD_LOGIC;
		data_out		:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out_valid:	out std_logic;
		crc				:	OUT STD_LOGIC;
		frame_length	:	OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	); -- Max frame size is 1542 bytes
	END COMPONENT;

	COMPONENT forward_interface IS PORT (
		aclr				:in	std_logic;
		clk				:in	std_logic;
		hold			:in	std_logic;
		data_in_valid		:in	std_logic;
		data_out_valid	:out	std_logic;
		data_in			:in	std_logic_vector	(7 downto 0);
		data_out			:out	std_logic_vector	(7 downto 0);
		frame_length_in	:in	std_logic_vector	(11 downto 0);
		frame_length_out	:out std_logic_vector	(11 downto 0)
	);
	END COMPONENT;
BEGIN

	Stage0: inputProcessor PORT MAP (
		aclr,
		clk25,
		clk50,
		data_in,
		data_in_valid,
		signal_data,signal_data_valid,
		signal_crc_complete,
		signal_frame_length
	);
	Stage1: forward_interface PORT MAP	(
		aclr				=>	aclr,
		clk					=>	clk50,
		hold				=>	hold,
		data_in_valid		=>	signal_data_valid,
		data_out_valid		=>	data_out_valid,
		data_in			=>	signal_data,
		data_out			=>	data_out,
		frame_length_in	=>	signal_frame_length,
		frame_length_out	=>	frame_length_out
	);

END high_level_design;