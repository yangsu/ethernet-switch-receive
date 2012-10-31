--	================================================================
--	system description

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.all;

entity fifo8bits is port	(
			aclr		:in		std_logic;
			clk		:in		std_logic;
			data	:in		std_logic_vector (7 downto 0);
			q		:out	std_logic_vector (7 downto 0);
			rdreq	:in		std_logic;
			wrreq	:in		std_logic;
			empty	:out	std_logic
);
end fifo8bits;

architecture structure of fifo8bits is

begin
	
	
end architecture;