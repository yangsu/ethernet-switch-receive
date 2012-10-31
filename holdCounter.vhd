LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY holdCounter IS
	PORT (
		aclr			:	IN		STD_LOGIC;
		clk				:	IN		STD_LOGIC;
		enable			:	IN		STD_LOGIC;
		count			:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		twelvecycles	:	OUT	STD_LOGIC
	);
END holdCounter;

ARCHITECTURE arch of holdCounter IS

	COMPONENT counter
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clk_en		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		sload		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL	isEqual12		:	STD_LOGIC;
	SIGNAL	tempCount	:	STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN

	counter0: counter PORT MAP(
		aclr 	=> 	aclr,
		clk_en	=> 	'1',
		clock	=>	clk,
		cnt_en	=>	enable AND NOT isEqual12,
		data	=> "000000000000",
		sload	=> '0',
		q		=> tempCount
	);

	isEqual12 <= '1' WHEN (tempCount = "000000001100") ELSE '0';
	twelvecycles <= isEqual12;
	count <= tempCount(3 DOWNTO 0);
END arch;