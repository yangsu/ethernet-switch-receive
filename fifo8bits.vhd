--	================================================================
--	system description

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_misc.all;
USE work.all;

ENTITY fifo8bits IS PORT	(
	aclr	:IN		STD_LOGIC;
	clk		:IN		STD_LOGIC;
	data	:IN		STD_LOGIC_VECTOR (7 DOWNTO 0);
	q		:OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	rdreq	:IN		STD_LOGIC;
	wrreq	:IN		STD_LOGIC;
	empty	:OUT	STD_LOGIC
);
END fifo8bits;

ARCHITECTURE structure OF fifo8bits IS

BEGIN


END ARCHITECTURE;