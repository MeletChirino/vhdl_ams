library ieee;
use ieee.fluidic_systems.all;
use ieee.mechanical_systems.all;
use ieee.electrical_systems.all;

entity regulateur is
  generic (
    P : real;  	
    tau : real			
    );
  port(terminal V : ELECTRICAL; terminal IN_P : fluidic; terminal OUT_P : fluidic);
end regulateur;

architecture one of regulateur is
  quantity pout across dout through OUT_P;
  quantity PIN across DIN through IN_P;
  quantity vcmd across icmd through V;
  
begin
  DIN == 0.0;
  icmd == 0.0;
	
  pout == Pin * (Vcmd/5.0);
  
end one;
