library ieee;
use ieee.mechanical_systems.all;
use ieee.fluidic_systems.all;
use ieee.math_real.all;
use ieee.electrical_systems.all;

use work.MES_TYPES.all;
use work.MES_CONSTANTES.all;

entity test is
constant m_veh : MASS := 1500.0;
end test;

--------------------------------------------------------------------------------------------------------------
-- Test véhicule seul
--------------------------------------------------------------------------------------------------------------
architecture A of test is

terminal t1 : translational_velocity;
quantity force through t1; 

begin
		
force==2800.0;
Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

end A;


architecture B of test is

terminal t1 : translational_velocity;
quantity force through t1; 

begin
		
force==-2800.0;
Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

end B;

--------------------------------------------------------------------------------------------------------------
-- Test véhicule et roue
--------------------------------------------------------------------------------------------------------------

architecture C of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
quantity cr through t2; 

begin 

cr==800.0;

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>seche, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

end C; 

--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue et frein
--------------------------------------------------------------------------------------------------------------

architecture D of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
quantity press across df through t3; 

begin 

press==18000000.0;

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>seche, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

end D; 

--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue, frein et MC
--------------------------------------------------------------------------------------------------------------

architecture E of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
quantity f :FORCE := 180.0;

begin 

f==180.0;

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>seche, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

u_MC:  entity maitre_cylindre(one) generic map (S=>1.0e-4, coef_assistance=>10.0)
    port map(hyd=>t3, force => f);

end E; 

--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue, frein, MC et ramp
--------------------------------------------------------------------------------------------------------------

architecture F of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
quantity f :FORCE := 180.0;
signal COND :real := 0.0;

begin 

cond <= 180.0 after 100 ms;
f==cond;
break on cond;

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>seche, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

u_MC:  entity maitre_cylindre(one) generic map (S=>1.0e-4, coef_assistance=>10.0)
    port map(hyd=>t3, force => f);

end F; 

--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue, frein, MC et ramp version 2
--------------------------------------------------------------------------------------------------------------

architecture G of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
quantity f :FORCE := 180.0;
signal COND :real := 0.0;

begin 

cond <= 180.0 after 100 ms;
f==cond'ramp(0.5);

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>seche, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

u_MC:  entity maitre_cylindre(one) generic map (S=>1.0e-4, coef_assistance=>10.0)
    port map(hyd=>t3, force => f);

end G; 


--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue, frein, MC et ramp version 2 plus regulateur
--------------------------------------------------------------------------------------------------------------

architecture H of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
terminal t4 : fluidic; 
terminal t5 : electrical; 
quantity f :FORCE := 180.0;
quantity volt across i through t5;
signal COND :real := 0.0;

begin 

volt == 4.0;
cond <= 180.0 after 100 ms;
f==cond'ramp(0.5);

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>28.0) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>seche, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

u_MC:  entity maitre_cylindre(one) generic map (S=>1.0e-4, coef_assistance=>10.0)
    port map(hyd=>t4, force => f);

u_REG:  entity regulateur(one) generic map (P=>1.0e-4, tau=>10.0)
    port map(IN_P=>t4, OUT_P => t3, V => t5);

end H; 

--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue, frein, MC et ramp version 2 plus regulateur plus ABS Calculator
--------------------------------------------------------------------------------------------------------------

architecture I of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
terminal t4 : fluidic; 
terminal t5 : electrical; 
quantity f :FORCE := 180.0;
signal COND :real := 0.0;

begin 

cond <= 180.0 after 100 ms, 0.0 after 5000 ms;
f==cond'ramp(0.5, 0.1);
--f==cond;
--break on cond;

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>27.8) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>humide, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

u_MC:  entity maitre_cylindre(one) generic map (S=>1.0e-4, coef_assistance=>10.0)
    port map(hyd=>t4, force => f);

u_REG:  entity regulateur(one) generic map (P=>1.0e-4, tau=>10.0)
    port map(IN_P=>t4, OUT_P => t3, V => t5);

u_ABS:  entity Calc_ABS(simple) port map(veh => t1, roue => t2, hydro => t4, vcmde => t5);

end I; 

--------------------------------------------------------------------------------------------------------------
-- Test véhicule, roue, frein, MC et ramp version 2 plus regulateur plus ABS Calculator
--------------------------------------------------------------------------------------------------------------

architecture J of test is 

terminal t1 : translational_velocity;
terminal t2 : rotational_velocity;
terminal t3 : fluidic;
terminal t4 : fluidic; 
terminal t5 : electrical; 
quantity f :FORCE := 180.0;
quantity motor through t2;
signal COND :real := 0.0;
signal torque : real := 0.0; 

begin 

cond <= 180.0 after 7100 ms, 0.0 after 12000 ms;
f==cond'ramp(0.5, 0.1);
	torque 		<= -900.0 after 0 ms,
			-500.0 after 1000 ms,
			-300.0 after 3000 ms,
			0.0 after 7000 ms;
motor == torque; 
break on torque; 

Auto: 	entity vehicule(one) generic map (m=>m_veh,cx=>0.3,S=>1.8,v_init=>0.028) 
    port map(roue=>t1);

u_Roue:  entity roue(A) generic map(route=>humide, m=>m_veh, rR=>0.275, IR=>0.4, mu0_D=>1.0, As=>0.01, mu0_W=>0.5, Vc=>27.8)
    port map(veh=>t1, frein => t2);

u_frein:  entity frein(one) generic map (coef_fric=>0.36, S=>1.0e-3, R=>0.12)
    port map(MC=>t3, roue => t2);

u_MC:  entity maitre_cylindre(one) generic map (S=>1.0e-4, coef_assistance=>10.0)
    port map(hyd=>t4, force => f);

u_REG:  entity regulateur(one) generic map (P=>1.0e-4, tau=>10.0)
    port map(IN_P=>t4, OUT_P => t3, V => t5);

u_ABS:  entity Calc_ABS(simple) port map(veh => t1, roue => t2, hydro => t4, vcmde => t5);

end J; 



















































