library ieee;
use ieee.fluidic_systems.all;
use ieee.mechanical_systems.all;

entity frein is
  generic (
    coef_fric : real;  	-- Coefficient de friction des plaquettes
    S : real;  			-- Surface piston = 10 cm2
    R : real 			-- Rayon moyen du disque
    );
  port(terminal roue : rotational_velocity; terminal MC : fluidic);
end frein;

architecture one of frein is
  quantity omega across tq through Roue;
  quantity press across debit through MC;
  
begin
	
  debit==0.0;
  
  tq==coef_fric*press*S*R;
  
  --if omega'above(0.0) use tq==friction*press*S*R;
  --else tq==0.0;
  --end use;
  
end one;
