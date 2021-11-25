library ieee;
use ieee.mechanical_systems.all;
use ieee.fluidic_systems.all;
use ieee.electrical_systems.all;

entity Calc_ABS is
port(
terminal veh : translational_velocity;
terminal roue : rotational_velocity;
terminal hydro : fluidic;
terminal vcmde : electrical;
);
end Calc_ABS;

architecture simple of Calc_ABS is
  quantity vv across ii through vcmde;
  quantity pin across din through hydro;
  quantity vit across force through veh;
  quantity omega across tq through roue;

begin
vv==..
pin==..
...

process
   
 


end process;


end simple;
