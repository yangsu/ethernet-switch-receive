--	================================================================
--	system description

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_misc.all;
USE work.all;

ENTITY forward_interface IS PORT (
	aclr					:	IN		STD_LOGIC;
	clk						:	IN		STD_LOGIC;
	hold					:	IN		STD_LOGIC;
	data_in_valid			:	IN		STD_LOGIC;
	data_out_valid			:	OUT	STD_LOGIC;
	data_in				:	IN		STD_LOGIC_VECTOR	(7 DOWNTO 0);
	data_out				:	OUT	STD_LOGIC_VECTOR	(7 DOWNTO 0);
	frame_length_in		:	IN		STD_LOGIC_VECTOR	(11 DOWNTO 0);
	frame_length_out		:	OUT	STD_LOGIC_VECTOR	(11 DOWNTO 0)
);
END forward_interface;

ARCHITECTURE structure OF forward_interface IS

--	================================================================
--	SIGNALs
	SIGNAL	empty				:	STD_LOGIC;
	SIGNAL	frame_length		:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL	transmit_data		:	STD_LOGIC;
	-- SIGNAL	receive_data		:	STD_LOGIC;
	SIGNAL	transmit_length	:	STD_LOGIC;
	SIGNAL	receive_length	:	STD_LOGIC;
--	================================================================
--	structure description

BEGIN
	controller: interface_controller PORT MAP (
		aclr				=>	aclr,
		clk					=>	clk,
		hold				=>	hold,
		data_in_valid		=>	data_in_valid,
		frame_length		=>	frame_length,
		empty				=>	empty,
		transmit_data		=>	transmit_data,
		-- receive_data	=>	receive_data,
		transmit_length	=>	transmit_length,
		receive_length	=>	receive_length
	);
	length_buffer: fifo12bits PORT MAP	(
		aclr	=>	aclr,
		clk		=>	clk,
		data	=>	frame_length_in,
		q		=>	frame_length,
		rdreq	=>	transmit_length,
		wrreq	=>	receive_length,
		empty	=>	empty
	);
	data_buffer: fifo8bits PORT MAP	(
		aclr	=>	aclr,
		clk		=>	clk,
		data	=>	data_in,
		q		=>	data_out,
		rdreq	=>	transmit_data,
		wrreq	=>	data_in_valid
	);
	frame_length_out	<= frame_length;
	data_out_valid	<= transmit_data;
END structure;