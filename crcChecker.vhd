LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY crcChecker IS
	PORT (
		aclr		:	IN		STD_LOGIC;
		clk			:	IN		STD_LOGIC;
		u			:	IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		crc			:	OUT 	STD_LOGIC
	);
END crcChecker;

ARCHITECTURE checker OF crcChecker IS

	SIGNAL ux 			: STD_LOGIC_VECTOR(3 DOWNTO 0); 
	SIGNAL Q_current 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Q_next	 	: STD_LOGIC_VECTOR(31 DOWNTO 0);



BEGIN

    ux4(0) := Q_current(31) XOR u4(3);  -- fixed
    ux4(1) := Q_current(30) XOR u4(2);
    ux4(2) := Q_current(29) XOR u4(1);
    ux4(3) := Q_current(28) XOR u4(0);
    
    
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

END checker;

                                                                     
                                                                     
                                                                     
                                             
Here is a description of computing the 32-bit CRC 4 bits at a time:

First look at the bit-serial CRC.  Assume that the shift register is
left-to-right, and that an input bit is XORed with the rightmost output
of the shift register with the result fed into the shift register at
the left end.  Assume that Q_current is the current state (DFF outputs)
and Q_next is the next state (DFF inputs), and that these are defined
to be STD_LOGIC_VECTOR(31 DOWNTO 0).  Ignoring initializtion and enable
issues, we can write a process for the state-update logic like this:

    PROCESS(u,Q_current)
    VARIABLE ux : STD_LOGIC;    
    BEGIN
        ux := Q_current(31) XOR u;
        Q_next(31) <= Q_current(30);
        Q_next(30) <= Q_current(29);
        Q_next(29) <= Q_current(28);
        Q_next(28) <= Q_current(27);
        Q_next(27) <= Q_current(26);
        Q_next(26) <= Q_current(25) XOR ux;
        Q_next(25) <= Q_current(24);
        Q_next(24) <= Q_current(23);
        Q_next(23) <= Q_current(22) XOR ux;
        Q_next(22) <= Q_current(21) XOR ux;     
        Q_next(21) <= Q_current(20);
        Q_next(20) <= Q_current(19);
        Q_next(19) <= Q_current(18);
        Q_next(18) <= Q_current(17);
        Q_next(17) <= Q_current(16);
        Q_next(16) <= Q_current(15) XOR ux;
        Q_next(15) <= Q_current(14);
        Q_next(14) <= Q_current(13);
        Q_next(13) <= Q_current(12);
        Q_next(12) <= Q_current(11) XOR ux;
        Q_next(11) <= Q_current(10) XOR ux;
        Q_next(10) <= Q_current(9) XOR ux;
        Q_next(9) <= Q_current(8);
        Q_next(8) <= Q_current(7) XOR ux;
        Q_next(7) <= Q_current(6) XOR ux;
        Q_next(6) <= Q_current(5);
        Q_next(5) <= Q_current(4) XOR ux;
        Q_next(4) <= Q_current(3) XOR ux;
        Q_next(3) <= Q_current(2);
        Q_next(2) <= Q_current(1) XOR ux;
        Q_next(1) <= Q_current(0) XOR ux;
        Q_next(0) <= ux;
    END PROCESS;
    
To do the computation on 4 input bits at a time, we need to define a
vector containing 4 input bits.  Call this u4, and define it as 
STD_LOGIC_VECTOR(3 DOWNTO 0), such that u4(0) is the first of the four
bits to be received and u4(3) is the last of the four bits to be
received.  To see what happens, we could write out equations based on
the bit-serial process above what we get for Q_next after the first bit,
then what we get for Q_next after the second bit with some rerrangement
to show this Q_next depending on the two input bits and the Q_current
at the beginning, etc.  Ultimately, we could write a process like the
following:

    PROCESS(u4,Q_current)
    VARIABLE ux : STD_LOGIC_VECTOR(3 DOWNTO 0); 
    BEGIN
        ux4(0) := Q_current(31) XOR u4(3);  -- fixed
        ux4(1) := Q_current(30) XOR u4(2);
        ux4(2) := Q_current(29) XOR u4(1);
        ux4(3) := Q_current(28) XOR u4(0);
        
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
    END PROCESS;
    
    