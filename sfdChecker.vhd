LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sfdChecker IS
	PORT (	aclr		:	IN STD_LOGIC;
			clk			:	IN STD_LOGIC;
			enable		: 	IN STD_LOGIC;
			data_in		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			frame_start	:	OUT STD_LOGIC);
END sfdChecker;

ARCHITECTURE sfd OF sfdChecker IS

	SIGNAL shifter0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL shifter1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL shifter2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL shifter3 : STD_LOGIC_VECTOR(1 DOWNTO 0);	
	SIGNAL byte		: STD_LOGIC_VECTOR(7 DOWNTO 0);

-- Shift register
	COMPONENT shiftReg2bit
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			enable		: IN STD_LOGIC ;
			shiftin		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
		);
	END COMPONENT;
		
BEGIN

	stage0: shiftReg2bit PORT MAP (aclr, clk, enable, data_in(0), shifter0);
	stage1: shiftReg2bit PORT MAP (aclr, clk, enable, data_in(1), shifter1);
	stage2: shiftReg2bit PORT MAP (aclr, clk, enable, data_in(2), shifter2);
	stage3: shiftReg2bit PORT MAP (aclr, clk, enable, data_in(3), shifter3);
	stage4:	byte(7) <= shifter3(1);
			byte(6) <= shifter2(1);
			byte(5) <= shifter1(1);
			byte(4) <= shifter0(1);
			byte(3) <= shifter3(0);
			byte(2) <= shifter2(0);
			byte(1) <= shifter1(0);
			byte(0) <= shifter0(0);
	stage5: frame_start <= byte(7) AND NOT byte(6) AND byte(5) AND NOT
							byte(4) AND byte(3) AND NOT byte(2) AND byte(1) AND byte(0);			

END sfd;