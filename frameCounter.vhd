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
SIGNAL signal_q		:	STD_LOGIC_VECTOR(11 DOWNTO 0);

	COMPONENT counter
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		sload		: IN STD_LOGIC ;
		updown	: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

BEGIN	
	Stage0: counter PORT MAP(
		aclr 		=> 	aclr,
		clock		=>	clk,
		cnt_en		=>	enable,
		data		=> "000000000000",
		sload		=> '0',
		updown	=> '1',
		q			=> signal_q
	);
	Stage1: 
		count <= '0' & signal_q(11 DOWNTO 1);
END arch;
