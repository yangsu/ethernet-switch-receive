LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY frameBuffer IS
	PORT (
		aclr			:	IN		STD_LOGIC;
		clk25			:	IN		STD_LOGIC;
		clk50			:	IN		STD_LOGIC;
		read_enable		:	IN		STD_LOGIC;
		write_enable	:	IN		STD_LOGIC;
		data_in			:	IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		data_out		:	OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END frameBuffer;

ARCHITECTURE buff OF frameBuffer IS
	COMPONENT fifo8dc IS
	PORT
	(
		aclr		:	IN		STD_LOGIC  := '0';
		data		:	IN		STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdclk		:	IN		STD_LOGIC ;
		rdreq		:	IN		STD_LOGIC ;
		wrclk		:	IN		STD_LOGIC ;
		wrreq		:	IN		STD_LOGIC ;
		q			:	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdempty	:	OUT	STD_LOGIC ;
		rdusedw	:	OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
		wrfull		:	OUT	STD_LOGIC ;
		wrusedw	:	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL discard1: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL discard2: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL buffer_empty, buffer_full: STD_LOGIC;

BEGIN
	fifo_inst: fifo8dc PORT MAP (
		aclr		=>	aclr,
		data		=>	data_in,
		rdclk		=>	clk50,
		rdreq		=>	read_enable,
		wrclk		=>	clk25,
		wrreq		=>	write_enable,
		q			=>	data_out,
		rdempty	=>	buffer_empty,
		rdusedw	=> 	discard1,
		wrfull		=>	buffer_full,
		wrusedw	=> 	discard2
	);

	PROCESS(clk25, write_enable)
	BEGIN
		IF (clk25'EVENT AND clk25 = '1' AND write_enable = '1') THEN
		END IF;
	END PROCESS;
END buff;