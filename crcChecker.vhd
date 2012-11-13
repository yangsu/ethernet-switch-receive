LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crcChecker IS
	PORT (	Resetx			: IN		STD_LOGIC;
			Clock			: IN		STD_LOGIC;			
			compute_enable	: IN		STD_LOGIC;
			u8				: IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
			CRC_out			: OUT		STD_LOGIC;
			curr_word		: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0);
			curr_Q			: OUT		STD_LOGIC_VECTOR(31 DOWNTO 0) );

END crcChecker;

--	for the input u4, the leftmost bit u4(3) is the first bit received

ARCHITECTURE rtl OF crcChecker IS
	SIGNAL Q_next		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Q_current	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	CONSTANT init		: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '1');	

	SIGNAL current_word : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8 : STD_LOGIC_VECTOR(3 DOWNTO 0);

	COMPONENT shiftReg4bit IS
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			enable		: IN STD_LOGIC ;
			shiftin		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
-- state update 
	PROCESS(Resetx,Clock)
	BEGIN
		IF Resetx = '1' THEN 
			Q_current <= ( OTHERS => '0');
		ELSIF Clock'EVENT AND Clock = '1' THEN
			Q_current <= Q_next;
		END IF;
	END PROCESS;
	
-- logic for determining next state
	PROCESS(u8,Q_current,compute_enable)
	VARIABLE ux8	: STD_LOGIC_VECTOR(7 DOWNTO 0);	

	BEGIN
        ux8(0) := Q_current(31) XOR u8(7);  -- fixed
        ux8(1) := Q_current(30) XOR u8(6);
        ux8(2) := Q_current(29) XOR u8(5);
        ux8(3) := Q_current(28) XOR u8(4);
        ux8(4) := Q_current(27) XOR u8(3);
        ux8(5) := Q_current(26) XOR u8(2);
        ux8(6) := Q_current(25) XOR u8(1);
        ux8(7) := Q_current(24) XOR u8(0);
		IF compute_enable = '0' THEN
			Q_next <= (OTHERS => '1');
		ELSE        
            Q_next(31) <= Q_current(23) XOR ux8(2);
            Q_next(30) <= Q_current(22) XOR ux8(0) XOR ux8(3);
            Q_next(29) <= Q_current(21) XOR ux8(0) XOR ux8(1) XOR ux8(4);
            Q_next(28) <= Q_current(20) XOR ux8(1) XOR ux8(2) XOR ux8(5);
            Q_next(27) <= Q_current(19) XOR ux8(0) XOR ux8(2) XOR ux8(3) XOR ux8(6);
            Q_next(26) <= Q_current(18) XOR ux8(1) XOR ux8(3) XOR ux8(4) XOR ux8(7);
            Q_next(25) <= Q_current(17) XOR ux8(4) XOR ux8(5);
            Q_next(24) <= Q_current(16) XOR ux8(0) XOR ux8(5) XOR ux8(6);
            Q_next(23) <= Q_current(15) XOR ux8(1) XOR ux8(6) XOR ux8(7);
            Q_next(22) <= Q_current(14) XOR ux8(7);     
            Q_next(21) <= Q_current(13) XOR ux8(2);
            Q_next(20) <= Q_current(12) XOR ux8(3);
            Q_next(19) <= Q_current(11) XOR ux8(0) XOR ux8(4);
            Q_next(18) <= Q_current(10) XOR ux8(0) XOR ux8(1) XOR ux8(5);
            Q_next(17) <= Q_current(9) XOR ux8(1) XOR ux8(2) XOR ux8(6);
            Q_next(16) <= Q_current(8) XOR ux8(2) XOR ux8(3) XOR ux8(7);
            Q_next(15) <= Q_current(7) XOR ux8(0) XOR ux8(2) XOR ux8(3) XOR ux8(4);
            Q_next(14) <= Q_current(6) XOR ux8(0) XOR ux8(1) XOR ux8(3) XOR ux8(4) XOR ux8(5);
            Q_next(13) <= Q_current(5) XOR ux8(0) XOR ux8(1) XOR ux8(2) XOR ux8(4) XOR ux8(5) XOR ux8(6);
            Q_next(12) <= Q_current(4) XOR ux8(1) XOR ux8(2) XOR ux8(3) XOR ux8(5) XOR ux8(6) XOR ux8(7);
            Q_next(11) <= Q_current(3) XOR ux8(3) XOR ux8(4) XOR ux8(6) XOR ux8(7);
            Q_next(10) <= Q_current(2) XOR ux8(2) XOR ux8(4) XOR ux8(5) XOR ux8(7);
            Q_next(9) <= Q_current(1) XOR ux8(2) XOR ux8(3) XOR ux8(5) XOR ux8(6);
            Q_next(8) <= Q_current(0) XOR ux8(3) XOR ux8(4) XOR ux8(6) XOR ux8(7);
            Q_next(7) <= ux8(0) XOR ux8(2) XOR ux8(4) XOR ux8(5) XOR ux8(7);
            Q_next(6) <= ux8(0) XOR ux8(1) XOR ux8(2) XOR ux8(3) XOR ux8(5) XOR ux8(6);
            Q_next(5) <= ux8(0) XOR ux8(1) XOR ux8(2) XOR ux8(3) XOR ux8(4) XOR ux8(6) XOR ux8(7);
            Q_next(4) <= ux8(1) XOR ux8(3) XOR ux8(4) XOR ux8(5) XOR ux8(7);
            Q_next(3) <= ux8(0) XOR ux8(4) XOR ux8(5) XOR ux8(6);
            Q_next(2) <= ux8(0) XOR ux8(1) XOR ux8(5) XOR ux8(6) XOR ux8(7);
            Q_next(1) <= ux8(0) XOR ux8(1) XOR ux8(6) XOR ux8(7);
            Q_next(0) <= ux8(1) XOR ux8(7);
		END IF;

	END PROCESS;

-- buffers
	stage0: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(7), shift1);
	stage1: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(6), shift2);
	stage2: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(5), shift3);
	stage3: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(4), shift4);
	stage4: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(3), shift5);
	stage5: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(2), shift6);
	stage6: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(1), shift7);
	stage7: shiftReg4bit PORT MAP (Resetx, Clock, compute_enable, u8(0), shift8);

-- current word
	current_word(31) <= shift1(3);
	current_word(30) <= shift2(3);
	current_word(29) <= shift3(3);
	current_word(28) <= shift4(3);
	current_word(27) <= shift5(3);
	current_word(26) <= shift6(3);
	current_word(25) <= shift7(3);
	current_word(24) <= shift8(3);
	
	current_word(23) <= shift1(2);
	current_word(22) <= shift2(2);
	current_word(21) <= shift3(2);
	current_word(20) <= shift4(2);
	current_word(19) <= shift5(2);
	current_word(18) <= shift6(2);
	current_word(17) <= shift7(2);
	current_word(16) <= shift8(2);
	
	current_word(15) <= shift1(1);
	current_word(14) <= shift2(1);
	current_word(13) <= shift3(1);
	current_word(12) <= shift4(1);
	current_word(11) <= shift5(1);
	current_word(10) <= shift6(1);
	current_word(9) <= shift7(1);
	current_word(8) <= shift8(1);
	
	current_word(7) <= shift1(0);
	current_word(6) <= shift2(0);
	current_word(5) <= shift3(0);
	current_word(4) <= shift4(0);
	current_word(3) <= shift5(0);
	current_word(2) <= shift6(0);
	current_word(1) <= shift7(0);
	current_word(0) <= shift8(0);

-- output
	CRC_OUT <=  (current_word(31) XOR Q_current(31)) AND
				(current_word(30) XOR Q_current(30)) AND
				(current_word(29) XOR Q_current(29)) AND
				(current_word(28) XOR Q_current(28)) AND
				(current_word(27) XOR Q_current(27)) AND
				(current_word(26) XOR Q_current(26)) AND
				(current_word(25) XOR Q_current(25)) AND
				(current_word(24) XOR Q_current(24)) AND
				(current_word(23) XOR Q_current(23)) AND
				(current_word(22) XOR Q_current(22)) AND
				(current_word(21) XOR Q_current(21)) AND
				(current_word(20) XOR Q_current(20)) AND
				(current_word(19) XOR Q_current(19)) AND
				(current_word(18) XOR Q_current(18)) AND
				(current_word(17) XOR Q_current(17)) AND
				(current_word(16) XOR Q_current(16)) AND
				(current_word(15) XOR Q_current(15)) AND
				(current_word(14) XOR Q_current(14)) AND
				(current_word(13) XOR Q_current(13)) AND
				(current_word(12) XOR Q_current(12)) AND
				(current_word(11) XOR Q_current(11)) AND
				(current_word(10) XOR Q_current(10)) AND
				(current_word(9) XOR Q_current(9)) AND
				(current_word(8) XOR Q_current(8)) AND
				(current_word(7) XOR Q_current(7)) AND
				(current_word(6) XOR Q_current(6)) AND
				(current_word(5) XOR Q_current(5)) AND
				(current_word(4) XOR Q_current(4)) AND
				(current_word(3) XOR Q_current(3)) AND
				(current_word(2) XOR Q_current(2)) AND
				(current_word(1) XOR Q_current(1)) AND
				(current_word(0) XOR Q_current(0));


	curr_word <= current_word;
	curr_q <= Q_current;
END rtl;
