LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY crcChecker IS
	PORT (	aclr		:	IN STD_LOGIC;
			clk			:	IN STD_LOGIC;
			data_in		:	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			crc			:	OUT STD_LOGIC);
END crcChecker;

ARCHITECTURE checker OF crcChecker IS

BEGIN

END checker;