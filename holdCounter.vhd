LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY holdCounter IS
	PORT (	aclr		:	IN STD_LOGIC;
			clk			:	IN STD_LOGIC;
			enable		:	IN STD_LOGIC;
			count		:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END holdCounter;

ARCHITECTURE counter of holdCounter IS

BEGIN

END counter;