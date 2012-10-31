--	================================================================
--	system description

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.all;

entity forward_interface is port (
			aclr				:in	std_logic;
			clk				:in	std_logic;
			hold			:in	std_logic;
			data_in_valid		:in	std_logic;
			data_out_valid	:out	std_logic;
			data_in			:in	std_logic_vector	(7 downto 0);
			data_out			:out	std_logic_vector	(7 downto 0);
			frame_length_in	:in	std_logic_vector	(11 downto 0);
			frame_length_out	:out std_logic_vector	(11 downto 0)
);
end forward_interface;

architecture structure of forward_interface is

--	================================================================
--	signals
	signal	empty			:std_logic;
	signal	frame_length		:std_logic_vector (11 downto 0);
	signal	transmit_data	:std_logic;
	-- signal	receive_data		:std_logic;
	signal	transmit_length	:std_logic;
	signal	receive_length	:std_logic;
--	================================================================
--	structure description

begin
	controller: interface_controller port map (
		aclr				=>aclr,
		clk				=>clk,
		hold			=>hold,
		data_in_valid		=>data_in_valid,
		frame_length		=>frame_length,
		empty			=>empty,
		transmit_data	=>transmit_data,
		-- receive_data		=>receive_data,
		transmit_length	=>transmit_length,
		receive_length	=>receive_length
	);
	length_buffer: fifo12bits port map	(
		aclr		=>aclr,
		clk		=>clk,
		data	=>frame_length_in,
		q		=>frame_length,
		rdreq	=>transmit_length,
		wrreq	=>receive_length,
		empty	=>empty
	);
	data_buffer: fifo8bits port map	(
		aclr		=>aclr,
		clk		=>clk,
		data	=>data_in,
		q		=>data_out,
		rdreq	=>transmit_data,
		wrreq	=>data_in_valid
	);
	frame_length_out	<= frame_length;
	data_out_valid	<= transmit_data;
end structure;