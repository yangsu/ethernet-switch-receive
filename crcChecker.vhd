LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crcChecker IS
	PORT (	aclr			: IN		STD_LOGIC;
			clk				: IN		STD_LOGIC;
			compute_enable	: IN		STD_LOGIC;
			u4				: IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CRC_out			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0) );

END crcChecker;

--	for the input u4, the leftmost bit u4(3) is the first bit received

ARCHITECTURE rtl OF crcChecker IS
	SIGNAL Q_next		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Q_current	: STD_LOGIC_VECTOR(31 DOWNTO 0);
--	CONSTANT init		: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '1');	

BEGIN
-- state update 
	PROCESS(aclr,clk)
	BEGIN
		IF aclr = '1' THEN 
			Q_current <= ( OTHERS => '0');
		ELSIF clk'EVENT AND clk = '1' THEN
			Q_current <= Q_next;
		END IF;
	END PROCESS;
	
-- logic for determining next state
	PROCESS(u4,Q_current,compute_enable)
	VARIABLE ux4	: STD_LOGIC_VECTOR(3 DOWNTO 0);	

	BEGIN
		ux4(0) := Q_current(31) XOR u4(3);
		ux4(1) := Q_current(30) XOR u4(2);
		ux4(2) := Q_current(29) XOR u4(1);
		ux4(3) := Q_current(28) XOR u4(0);
		IF compute_enable = '0' THEN
			Q_next <= (OTHERS => '1');
		ELSE
			Q_next(31) <= Q_current(27);
			Q_next(30) <= Q_current(26);
			Q_next(29) <= Q_current(25) XOR ux4(0);
			Q_next(28) <= Q_current(24) XOR ux4(1);
			Q_next(27) <= Q_current(23) XOR ux4(2);
			Q_next(26) <= Q_current(22) XOR ux4(3) XOR ux4(0);
			Q_next(25) <= Q_current(21) XOR ux4(1) XOR ux4(0);
			Q_next(24) <= Q_current(20) XOR ux4(2) XOR ux4(1);
			Q_next(23) <= Q_current(19) XOR ux4(3) XOR ux4(2);
			Q_next(22) <= Q_current(18) XOR ux4(3);		
			Q_next(21) <= Q_current(17);
			Q_next(20) <= Q_current(16);
			Q_next(19) <= Q_current(15) XOR ux4(0);
			Q_next(18) <= Q_current(14) XOR ux4(1);
			Q_next(17) <= Q_current(13) XOR ux4(2);
			Q_next(16) <= Q_current(12) XOR ux4(3);
			Q_next(15) <= Q_current(11) XOR ux4(0);
			Q_next(14) <= Q_current(10) XOR ux4(1) XOR ux4(0);
			Q_next(13) <= Q_current(9) XOR ux4(2) XOR ux4(1) XOR ux4(0);
			Q_next(12) <= Q_current(8) XOR ux4(3) XOR ux4(2) XOR ux4(1);
			Q_next(11) <= Q_current(7) XOR ux4(3) XOR ux4(2) XOR ux4(0);
			Q_next(10) <= Q_current(6) XOR ux4(3) XOR ux4(1) XOR ux4(0);
			Q_next(9) <= Q_current(5) XOR ux4(2) XOR ux4(1);
			Q_next(8) <= Q_current(4) XOR ux4(3) XOR ux4(2) XOR ux4(0);
			Q_next(7) <= Q_current(3) XOR ux4(3) XOR ux4(1) XOR ux4(0);
			Q_next(6) <= Q_current(2) XOR ux4(2) XOR ux4(1);
			Q_next(5) <= Q_current(1) XOR ux4(3) XOR ux4(2) XOR ux4(0);
			Q_next(4) <= Q_current(0) XOR ux4(3) XOR ux4(1) XOR ux4(0);
			Q_next(3) <= ux4(2) XOR ux4(1) XOR ux4(0);
			Q_next(2) <= ux4(3) XOR ux4(2) XOR ux4(1);
			Q_next(1) <= ux4(3) XOR ux4(2);
			Q_next(0) <= ux4(3);
		END IF;

	END PROCESS;
	
-- output
	CRC_out <= Q_current;

END rtl;
