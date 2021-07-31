-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity grappler IS Port
(
 clk_input, rst_n, grappler_en, grappler		: IN std_logic;
 grappler_on											: OUT std_logic
 );
END ENTITY;
 

 Architecture design of grappler is
 
  
 TYPE STATE_NAMES IS (grappler_open, grappler_closed, release_open, release_closed);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES

 BEGIN
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, rst_n)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= grappler_open;
		
	ELSIF(rising_edge(clk_input)) THEN
	
		current_state <= next_State;
		
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (grappler_en, grappler, current_state) 

BEGIN
     CASE current_state IS
          WHEN grappler_open =>		
			 
				IF(grappler_en ='1' and grappler = '1') THEN 	-- when to open grappler
					next_state <= release_closed;
					
				ELSE
					next_state <= grappler_open;
					
				END IF;
				
				WHEN release_closed =>	
			
				IF (grappler = '0') THEN     -- When the button is released grapple starts
					next_state <= grappler_closed;			
				ELSE
					next_state <= release_closed;		--	waiting for button release
				END IF;


         WHEN grappler_closed =>		
			
				IF(grappler_en ='1' and grappler = '1') THEN		-- when to close grappler
					next_state <= release_open;
					
				ELSE
					next_state <= grappler_closed;
					
				END IF;
				
			WHEN release_open =>	
			
				IF (grappler = '0') THEN     -- When the button is released grapple starts
					next_state <= grappler_open;			
				ELSE
					next_state <= release_open;		--	waiting for button release
				END IF;

			WHEN OTHERS =>
   
 	END CASE;

 END PROCESS;

-- DECODER SECTION PROCESS (Moore Form)

Decoder_Section: PROCESS (current_state) 

BEGIN
    CASE current_state IS
	 
      WHEN grappler_open =>		
		grappler_on <= '0';		-- opens grappler
			
      WHEN grappler_closed =>		
		grappler_on <= '1';		-- close grappler
				
		WHEN release_closed =>	
		
		WHEN release_open =>		
				
      WHEN others =>		
		
  END CASE;
  
 END PROCESS;

 END ARCHITECTURE design;
