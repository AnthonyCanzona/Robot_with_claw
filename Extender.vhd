-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Extender IS Port
	(
	 clk_input, rst_n												: IN std_logic;
	 extender_en, extender										: IN std_logic;
	 ext_pos   														: IN std_logic_vector (3 downto 0);
	 clk_en, left_right, extender_out, grappler_en		: OUT std_logic := '0'
	 );
END ENTITY;
 

 Architecture design of Extender is
 
  
 TYPE STATE_NAMES IS (retracted, extout_1, extout_2, extout_3, full_ext, extin_3, extin_2, extin_1, release_extend,  release_retract );   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES

 BEGIN
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, rst_n)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN						-- resets the xy_motion system
		current_state <= retracted;
		
	ELSIF(rising_edge(clk_input)) THEN		-- changes state each clock cycle
		
		current_state <= next_State;
		
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (extender_en, extender, current_state) 

BEGIN
     CASE current_state IS
          WHEN retracted =>	
			 
				IF(extender_en = '1' and extender = '1') THEN 	-- when to start to extend
					next_state <= release_extend;
					
				ELSE
					next_state <= retracted;
					
				END IF;
				
				WHEN release_extend =>	
			
				IF (extender = '0') THEN     -- When the button is released extention starts
					next_state <= extout_1;			
				ELSE
					next_state <= release_extend;		--	waiting for button release
				END IF;


		-- States depicting extention process --
				
         WHEN extout_1 =>		
					next_state <= extout_2;

         WHEN extout_2 =>		
					next_state <= extout_3;
				
         WHEN extout_3 =>		
					next_state <= full_ext;

         WHEN full_ext =>	
		
				IF(extender_en = '1' and extender = '1') THEN -- when to start to retract
					next_state <= extin_3;
					
				ELSE
					next_state <= full_ext;
					
				END IF;
				
			WHEN release_retract =>	
			
				IF (extender = '0') THEN     -- When the button is released extention starts
					next_state <= extin_3;			
				ELSE
					next_state <= release_retract;		--	waiting for button release
				END IF;

		-- States depicting retraction process --
		
         WHEN extin_3 =>		
					next_state <= extin_2;
				
         WHEN extin_2 =>		
					next_state <= extin_1;
				
         WHEN extin_1 =>		
					next_state <= retracted;

	WHEN OTHERS =>
               next_state <= retracted;
 	END CASE;

 END PROCESS;

-- DECODER SECTION PROCESS (Moore Form)

Decoder_Section: PROCESS (current_state, clk_input) 

BEGIN
     CASE current_state IS		-- having extender in an inactive state when retracted
         WHEN retracted =>	
			
			extender_out 	<= '0';
			grappler_en 	<= '0';
			clk_en 			<= '0';
			left_right 		<= '0';
			
		-- Process of extention --
         WHEN extout_1 =>
			
			extender_out 	<= '1';
			grappler_en 	<= '0';
			clk_en 			<= '1';
			left_right 		<= '1';
			

         WHEN extout_2 =>
			
			extender_out 	<= '1';
			grappler_en 	<= '0';
			clk_en 			<= '1';
			left_right 		<= '1';
			
         WHEN extout_3 =>
			
			extender_out 	<= '1';
			grappler_en 	<= '0';
			clk_en 			<= '1';
			left_right 		<= '1';

         WHEN full_ext =>			-- State becoming extended when it is in an inactive 
											-- state of full extention
			extender_out 	<= '1';
			grappler_en 	<= '1';
			clk_en 			<= '0';
			left_right 		<= '0';

		-- Process of retraction --
         WHEN extin_3 =>	
			
			extender_out 	<= '1';
			grappler_en 	<= '0';
			clk_en 			<= '1';
			left_right 		<= '0';
				
         WHEN extin_2 =>	
			
			extender_out 	<= '1';
			grappler_en 	<= '0';
			clk_en 			<= '1';
			left_right 		<= '0';
				
         WHEN extin_1 =>
			
			extender_out 	<= '1';
			grappler_en 	<= '0';
			clk_en 			<= '1';
			left_right		<= '0';
			
			WHEN release_extend =>
			
			WHEN release_retract =>
			
         WHEN OTHERS =>	
			
  END CASE;
 END PROCESS;

 END ARCHITECTURE design;
