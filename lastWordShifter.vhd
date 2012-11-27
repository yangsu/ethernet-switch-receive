LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY lastWordShifter IS
	PORT (
		aclr			:	IN	STD_LOGIC;
		clk				:	IN	STD_LOGIC;
		data_in		:	IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		data_out	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END lastWordShifter;

ARCHITECTURE arch OF lastWordShifter IS

	COMPONENT shiftReg8Bit
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			shiftin	: IN STD_LOGIC ;
			q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL out0, out1, out2, out3 : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
	shifter0: shiftReg8Bit PORT MAP (
		aclr		=>	aclr,
		clock		=>	clk,
		shiftin =>	data_in(0),
		q				=>	out0
	);

	shifter1: shiftReg8Bit PORT MAP (
		aclr		=>	aclr,
		clock		=>	clk,
		shiftin =>	data_in(1),
		q				=>	out1
	);

	shifter2: shiftReg8Bit PORT MAP (
		aclr		=>	aclr,
		clock		=>	clk,
		shiftin =>	data_in(2),
		q				=>	out2
	);

	shifter3: shiftReg8Bit PORT MAP (
		aclr		=>	aclr,
		clock		=>	clk,
		shiftin =>	data_in(3),
		q				=>	out3
	);

	data_out(31)	<=	out3(7);
	data_out(30)	<=	out2(7);
	data_out(29)	<=	out1(7);
	data_out(28)	<=	out0(7);
	data_out(27)	<=	out3(6);
	data_out(26)	<=	out2(6);
	data_out(25)	<=	out1(6);
	data_out(24)	<=	out0(6);
	data_out(23)	<=	out3(5);
	data_out(22)	<=	out2(5);
	data_out(21)	<=	out1(5);
	data_out(20)	<=	out0(5);
	data_out(19)	<=	out3(4);
	data_out(18)	<=	out2(4);
	data_out(17)	<=	out1(4);
	data_out(16)	<=	out0(4);
	data_out(15)	<=	out3(3);
	data_out(14)	<=	out2(3);
	data_out(13)	<=	out1(3);
	data_out(12)	<=	out0(3);
	data_out(11)	<=	out3(2);
	data_out(10)	<=	out2(2);
	data_out(9)		<=	out1(2);
	data_out(8)		<=	out0(2);
	data_out(7)		<=	out3(1);
	data_out(6)		<=	out2(1);
	data_out(5)		<=	out1(1);
	data_out(4)		<=	out0(1);
	data_out(3)		<=	out3(0);
	data_out(2)		<=	out2(0);
	data_out(1)		<=	out1(0);
	data_out(0)		<=	out0(0);

END arch;