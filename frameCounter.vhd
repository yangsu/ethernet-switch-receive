LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY frameCounter IS
	PORT (
		aclr		:	IN 		STD_LOGIC;
		clk			:	IN 		STD_LOGIC;
		enable		:	IN	 	STD_LOGIC;
		count		:	OUT 	STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END frameCounter;

ARCHITECTURE counter OF frameCounter IS

BEGIN

END counter;
