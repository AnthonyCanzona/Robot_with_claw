-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS

   PORT
	(
	clk			: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(2 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
	leds			: out std_logic_vector(21 downto 0)	
	);
	
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS

--------------------------------------------------------------------------------
-- Component Declarations --
--------------------------------------------------------------------------------

	component xy_motion PORT
		 (
		 clk, rst_n                                        : IN std_logic;
		 x_greater, x_equal, x_less                        : IN std_logic;
		 y_greater, y_equal, y_less                        : IN std_logic;
		 motion, extender_out                              : IN std_logic;
		 x_target, y_target                                : IN std_logic_vector (3 downto 0);
		 x_reg, y_reg                                      : OUT std_logic_vector (3 downto 0);
		 clk_en_x, clk_en_y, up_down_x, up_down_y     		: OUT std_logic;
		 error, extender_en                                : OUT std_logic
		 );
	end component xy_motion;

	component Extender Port
		 (
		 clk_input, rst_n                                   : IN std_logic;
		 extender_en, extender                              : IN std_logic;
		 ext_pos                                            : IN std_logic_vector (3 downto 0);
		 clk_en, left_right, extender_out, grappler_en      : OUT std_logic
		 );
	END component Extender;

	component grappler Port
		 (
		 clk_input, rst_n, grappler_en, grappler    			 : IN std_logic;
		 grappler_on                                        : OUT std_logic
		 );
	END component grappler;

	component Shift_Register_4bit PORT
		 (
		 Clk                : in    std_logic ;
		 rst_n              : in    std_logic ;
		 clk_en             : in    std_logic ;
		 left0_right1   	  : in    std_logic ;
		 reg_bits           : out   std_logic_vector (3 downto 0)
		 );
	end component Shift_Register_4bit;
		 
	component Counter4bit PORT
		 (
		 Clk                : in    std_logic ;
		 rst_n              : in    std_logic ;
		 clk_en             : in    std_logic ;
		 up1_down0          : in    std_logic ;
		 counter_bits       : out   std_logic_vector (3 downto 0)
		 );
	end component Counter4bit;

	component Compx4 PORT 
		 (
		 in_A, in_B                          : in std_logic_vector (3 downto 0);
		 out_greater, out_equal, out_less    : out std_logic
		 ); 
	end component Compx4;

-------------------------------------------------------------------
-- SIGNALS
-------------------------------------------------------------------
	 
signal X_LT, X_EQ, X_GT, Y_LT, Y_EQ, Y_GT, ext_out, ext_en, motion: std_logic;

signal clk_enx, clk_eny, up_downx, up_downy, clk_e, left_r, grap_en, extend, grapple : std_logic;

signal ext_p, x_pos, y_pos, x_reg, y_reg, x_targ, y_targ  : std_logic_vector(3 downto 0);

	
BEGIN

-- linking inputs to variables --
motion 	<= pb(2);
extend 	<= pb(1);
grapple 	<= pb(0);
x_targ 	<= sw(7 downto 4);
y_targ 	<= sw(3 downto 0);

-- instance of counter ajusting x-position --
counter_x: Counter4bit port map (
											clk,
											rst_n,
											clk_enx,
											up_downx,
											x_pos
										  );	
										  
-- instance of counter ajusting y-position --												
counter_y: Counter4bit port map (
											clk,
											rst_n,
											clk_eny,
											up_downy,
											y_pos
											);
											
-- instance of comparator determining when to ajusting x-position --
Compx4_x: Compx4 port map (
									x_pos, x_reg,
									X_GT, X_EQ, X_LT
									);
									
-- instance of comparator determining when to ajusting y-position --
Compx4_y: Compx4 port map (
									y_pos, y_reg,
									Y_GT, Y_EQ, Y_LT
									);
									
-- instance of the motion control system --									
xy_motion_inst: xy_motion port map (
												clk, rst_n,
												X_GT, X_EQ, X_LT,
												Y_GT, Y_EQ, Y_LT,
												motion, ext_out, x_targ, y_targ,
												x_reg, y_reg,
												clk_enx, clk_eny, up_downx, up_downy,
												leds(0), ext_en
												);
												
-- instance of the extention extender --  									
shift_inst: Shift_Register_4bit port map (
														clk,
														rst_n,
														clk_e,
														left_r, 
														ext_p
														);
														
-- instance of the extention control system --  																																											
Extender_inst: Extender port map (
											clk, rst_n,
											ext_en, extend,
											ext_p,
											clk_e, left_r, ext_out, grap_en
											);
													
-- instance of the grappler control system -- 											
grappler_inst: grappler port map (
											clk, rst_n, grap_en, grapple,
										   leds(1)
											);
											
-- linking outputs to their leds --										
leds(13 downto 10) 	<= x_pos;
leds(21 downto 18) 	<= x_reg;
leds(9 downto 6) 		<= y_pos;
leds(17 downto 14) 	<= y_reg;
leds(5 downto 2) 		<= ext_p;

												
END Circuit;
