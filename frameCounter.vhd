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

ARCHITECTURE arch OF frameCounter IS

	COMPONENT counter
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clk_en		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		sload		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	counter0: counter PORT MAP(
		aclr 	=> 	aclr,
		clk_en	=> 	'1',
		clock	=>	clk,
		cnt_en	=>	enable,
		data	=> "000000000000",
		sload	=> '0',
		q		=> count
	);
END arch;
