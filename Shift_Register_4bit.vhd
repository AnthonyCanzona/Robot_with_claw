-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Shift_Register_4bit IS
   PORT
	(
		Clk				: in	std_logic := '0' ;
		rst_n				: in	std_logic := '0' ;
		clk_en			: in	std_logic := '0' ;
		left0_right1   : in	std_logic := '0' ;
		reg_bits			: out	std_logic_vector (3 downto 0)
	);
END ENTITY;

ARCHITECTURE one OF Shift_Register_4bit IS
	
	signal sreg : std_logic_vector (3 downto 0);
	
BEGIN

process (clk, rst_n, clk_en) is

	begin
	
		if (rst_n = '0') then 		-- reset the shift register
			sreg <= "0000";
			
		elsif ( (rising_edge(clk)) and (clk_en = '1') ) then
			
			if (left0_right1 = '1') then 
			
				sreg (3 downto 0) <= '1' & sreg (3 downto 1); -- shifts value to add 1 to from the right
				
			elsif (left0_right1 = '0') then 
				
				sreg (3 downto 0) <=  sreg (2 downto 0) & '0';	-- shifts value to add 0 to from the left
			
			end if;
			
		end if;
			
end process;

reg_bits <= sreg;

END one;
