-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;


entity Compx1 is port (

in_A, in_B  : in std_logic;
out_greater, out_equal, out_less	: out std_logic
	
); 

end Compx1;

architecture compx_design of Compx1 is

-- Basic GreaterThan, LessThan, and EqualTo operation using gates
begin

out_greater <= in_A AND (NOT in_B) ;

out_equal <= in_A XNOR in_B ;

out_less <= in_B AND (NOT in_A) ;
	
end compx_design;


