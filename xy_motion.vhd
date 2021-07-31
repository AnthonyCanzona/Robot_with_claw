-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity xy_motion IS Port
(
	clk, rst_n 											: IN std_logic;
	x_greater, x_equal, x_less						: IN std_logic;
	y_greater, y_equal, y_less						: IN std_logic;
	motion, extender_out								: IN std_logic;
	x_target, y_target								: IN std_logic_vector (3 downto 0);
	x_reg, y_reg										: OUT std_logic_vector (3 downto 0);
	clk_en_x, clk_en_y, up_down_x, up_down_y 	: OUT std_logic := '0';
	error, extender_en 								: OUT std_logic := '0'
 );
END ENTITY;
 

Architecture design of xy_motion is

 TYPE STATE_NAMES IS (start, move_deside, error_state, ending, button_release);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	: STATE_NAMES;     	-- signals of type STATE_NAMES
 
--------------------------------------------------------------------------------
--State Machine:
--------------------------------------------------------------------------------
 
BEGIN

register_Section: PROCESS (clk, rst_n)  -- this process synchronizes the activity to a clock
	
	BEGIN
	
		IF (rst_n = '0') THEN				-- resets the xy_motion system
			current_state <= ending;			
		ELSIF( rising_edge(clk) ) THEN			
			current_state <= next_state;	-- changes state each clock cycle
		END IF;
		
	END PROCESS;	

Transition_Section: PROCESS (current_state, extender_out, x_equal, y_equal, motion) -- Process links all current state to 
																												-- their next states 
 BEGIN
 
     CASE current_state IS
         WHEN start =>	
			
				IF (extender_out = '1') THEN     -- Error state is set when extender is out after motion starts 
					next_state <= error_state;			
				ELSE
					next_state <= button_release;		--	After Start initializes everything movement begins
				END IF;
				
				WHEN button_release =>	
			
				IF (motion = '0') THEN     -- When the button is released motion starts
					next_state <= move_deside;			
				ELSE
					next_state <= button_release;		--	waiting for button release
				END IF;

         WHEN move_deside =>	
			
				IF( (x_equal = '1') AND (y_equal = '1') ) THEN  -- When destination is reached movement ends
					next_state <= ending;
				ELSE
					next_state <= move_deside;							-- Movement continues if destination is not met
				END IF;	
				
					
			WHEN ending =>		
					
				IF (motion = '1') THEN			-- motion starts when motion button is pressed
					next_state <= start;					
				ELSE
					next_state <= ending;		-- If the button is not press it stays waiting for a button press			
				END IF;
					
			WHEN error_state =>		
			
				IF (extender_out = '1') THEN 	-- error continues if extender is extended
					next_state <= error_state;					
				ELSE
					next_state <= start;			-- once extender is retracted error state ends
				END IF;
					
 	END CASE;
	
 END PROCESS;

Decoder_Section: PROCESS (current_state, x_greater, x_equal, x_less, y_greater, y_equal, y_less, x_target, y_target) 

 BEGIN

     CASE current_state IS
	  
         WHEN start =>		
				x_reg <= x_target;		-- setting targets to reg variables
				y_reg <= y_target;
				extender_en <= '0';		-- turning extender off
				error 		<= '0';		-- turning error off
			
         WHEN error_state =>		
				error 		<= '1'; 		-- turning error on
				extender_en	<= '1';		-- turning extender on to close it

         WHEN move_deside =>	
				clk_en_x 	<= '1';				-- the chain of logic determining when and how 
				clk_en_y 	<= '1';				-- to move to get target = position
				
					IF (x_greater = '1') THEN
						up_down_x 	<= '0';
						clk_en_x 	<= '1';
					ELSIF (x_less = '1') THEN
						up_down_x 	<= '1';
						clk_en_x 	<= '1';						
					ELSIF (x_equal = '1') THEN 
						clk_en_x		<= '0';					
					END IF; 
				
					IF (y_greater = '1') THEN
						up_down_y 	<= '0';
						clk_en_y	 	<= '1';						
					ELSIF (y_less = '1') THEN
						up_down_y 	<= '1';
						clk_en_y 	<= '1';						
					ELSIF (y_equal = '1') THEN 	
						clk_en_y 	<= '0';						
					END IF; 
			
			WHEN ending =>		
				extender_en	<= '1';			-- activating extender
				clk_en_x 	<= '0';			-- ending the movement process
				clk_en_y 	<= '0';	
			
			WHEN button_release =>	
				
			WHEN OTHERS => 
			
	END CASE;
	
 END PROCESS;
 
END ARCHITECTURE design;
