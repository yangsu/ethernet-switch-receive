LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MII_to_RCV IS
	PORT (	Clock25		: IN		STD_LOGIC;
			Resetx		: IN		STD_LOGIC;
			rcv_data_valid	: OUT	STD_LOGIC;
			rcv_data	:OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
			);			

END MII_to_RCV;

ARCHITECTURE test_bench OF MII_to_RCV IS
	
component framemem
	PORT
	(
		aclr		: IN STD_LOGIC ;
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
end component;

component cntr12bit
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
end component;

	
	TYPE State_type IS (reset,wait4run,waitx,run,done);
	SIGNAL y_current, y_next			: State_type;
	SIGNAL addr_curr, addr_next			: STD_LOGIC_VECTOR(9 DOWNTO 0);
	CONSTANT frame_len	: STD_LOGIC_VECTOR(11 DOWNTO 0) := "000001000100";
	SIGNAL count_enable, count_reset	: STD_LOGIC;
	SIGNAL count_val	: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL mem_out		: STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN

-- instantiate the components and map the ports

frame_test_mem : framemem PORT MAP (
		aclr	 => Resetx,
		address	 => addr_curr,
		clock	 => Clock25,
		q	 => mem_out
	);

cntrx : cntr12bit PORT MAP (
		aclr	 => ResetX,
		clock	 => Clock25,
		cnt_en	 => count_enable,
		sclr	 => count_reset,
		q	 => count_val
	);



-- state update 
	PROCESS(Resetx,Clock25)
	BEGIN
		IF Resetx = '1' THEN 
			y_current <= reset;
			addr_curr <= "0000000000";
		ELSIF Clock25'EVENT AND Clock25 = '1' THEN
			y_current <= y_next;
			addr_curr <= addr_next;
		END IF;
	END PROCESS;

-- logic for next_state and output
	PROCESS(y_current,count_val,addr_curr)
	BEGIN
		count_enable <= '0';
		addr_next <= addr_curr;
		count_reset <= '0';
		rcv_data_valid <= '0';
		CASE y_current IS
			WHEN reset =>
				y_next <= wait4run;
			WHEN wait4run =>
				count_enable <= '1';
				IF count_val = "000000000111" THEN 
					y_next <= waitx;
					count_reset <= '1';
				ELSE y_next <= wait4run;
				END IF;
			WHEN waitx =>
				y_next <= run;
				addr_next <= count_val(9 DOWNTO 0);
			WHEN run =>
				count_enable <= '1';
				addr_next <= count_val(9 DOWNTO 0);
				rcv_data_valid <= '1';
				IF addr_curr = "0010011010" THEN 
					y_next <= done;
					rcv_data_valid <= '0';
					count_reset <= '1';
				ELSE y_next <= run;
				END IF;			
			WHEN done =>
				y_next <= done;

		END CASE;
	END PROCESS;

	rcv_data <= mem_out;
	

END test_bench;






