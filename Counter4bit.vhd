-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Counter4bit IS
   PORT
	(
		Clk				: in	std_logic := '0' ;
		rst_n				: in	std_logic := '0' ;
		clk_en			: in	std_logic := '0' ;
		up1_down0   	: in	std_logic := '0' ;
		counter_bits	: out	std_logic_vector (3 downto 0)
	);
END ENTITY;

ARCHITECTURE one OF Counter4bit IS
	
	signal bin_counter : unsigned (3 downto 0);
	
BEGIN

process (clk, rst_n) is

	begin
	
		if (rst_n = '0') then 			-- resets the counter
			bin_counter <= "0000"; 
			
		elsif ( rising_edge(clk) ) then
		
			if ( (up1_down0 = '1') and (clk_en = '1') ) then  -- increases the value
			
				bin_counter <= (bin_counter + 1); 
				
			elsif ( (up1_down0 = '0') and (clk_en = '1') ) then -- decreases the value
				
				bin_counter <= (bin_counter - 1); 
			
			end if;
			
		end if;
			
end process;

counter_bits <= std_logic_vector(bin_counter); -- outputs the value

END one;