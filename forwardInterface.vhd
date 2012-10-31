LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY forwardInterface IS
	PORT (
		aclr				:	IN		STD_LOGIC;
		clk50				:	IN		STD_LOGIC;
		hold				:	IN		STD_LOGIC;
		frame_length_in	:	IN		STD_LOGIC_VECTOR(11 DOWNTO 0);
		frame_length_out	:	OUT	STD_LOGIC_VECTOR(11 DOWNTO 0);
		data_in_valid		:	IN		STD_LOGIC;
		data_in			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		-- crc				:	IN		STD_LOGIC;
		data_out_valid		:	OUT	STD_LOGIC;
		data_out			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END forwardInterface;

ARCHITECTURE subsystem_level_design OF forwardInterface IS

BEGIN

END subsystem_level_design;