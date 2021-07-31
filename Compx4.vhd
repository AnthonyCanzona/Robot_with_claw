-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;


entity Compx4 is port (

			in_A, in_B 								:in std_logic_vector (3 downto 0);
			out_greater, out_equal, out_less	:out std_logic
			
			); 

end Compx4;

architecture compx_design of Compx4 is

-- Basic 1-bit Magnitude Comparator component

	component Compx1 port (
	in_A, in_B  							: in std_logic;
	out_greater, out_equal, out_less	: out std_logic
	);		
	end component;		

----------------------------------------------------------------
-- Signal Declaration --
----------------------------------------------------------------

signal in_greater0, in_equal0, in_less0 :  std_logic;

signal in_greater1, in_equal1, in_less1 :  std_logic;

signal in_greater2, in_equal2, in_less2 :  std_logic;

signal in_greater3, in_equal3, in_less3 :  std_logic;

----------------------------------------------------------------
-- 4-bit Magnitude Comparator Design --
----------------------------------------------------------------

begin

-- Using instances to compare each bit --

-- bit 0 comparison
comp1_0 : Compx1 port map (
									in_A(0), in_B(0),
									in_greater0, in_equal0, in_less0
									);
-- bit 1 comparison
comp1_1 : Compx1 port map (
									in_A(1), in_B(1),
									in_greater1, in_equal1, in_less1
									);
-- bit 2 comparison									
comp1_2 : Compx1 port map (
									in_A(2), in_B(2),
									in_greater2, in_equal2, in_less2
									);
-- bit 3 comparison									
comp1_3 : Compx1 port map (
									in_A(3), in_B(3),
									in_greater3, in_equal3, in_less3
									);
				
-- Formulating outputs with bit comparisons and logical operations
				
out_greater <= (in_greater3 OR (in_greater2 AND in_equal3) OR (in_greater1 AND in_equal3 AND in_equal2) OR (in_greater0 AND in_equal3 AND in_equal2 AND in_equal1));

out_equal <= (in_equal0 AND in_equal1 AND in_equal2 AND in_equal3);

out_less <= (in_less3 OR (in_less2 AND in_equal3) OR (in_less1 AND in_equal3 AND in_equal2) OR (in_less0 AND in_equal3 AND in_equal2 AND in_equal1));									
									
	
end compx_design;
