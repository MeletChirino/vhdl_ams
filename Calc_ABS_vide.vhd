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
	signal clk	: std_logic := '0';
	quantity vv across ii through vcmde;
	quantity pin across din through hydro;
	quantity vit across force through veh;
	quantity omega across tq through roue;
begin

	clk <= not clk after 1 ms;
	--not sure about next few lines
	din == 0.0;
	force == 0.0;
	tq == 0.0;

process(clk)
	--check regulation voltage is vv, if not change vv for the actual value
	variable R	: real := 12; --rayon roue
	variable S	: real; --coeff glisement
	begin 
		if (clk'event and clk = '1') then -- detect rising edge 
			S == (veh - omega * R) / veh; --calculs coeff glissement
			if (veh > 30) then --if trasnlational speed under 30 adjust abs
				--conditions described in paper
				if(S >= 0.5) then 
					vv := vv - 0.5;
				elsif (S < 0.5) then
					vv := vv + 0.1;
					end if;
			elsif(veh < 30 et veh >  0) then 
				--when speed under 30 reestablish adljust voltage
				vv := 5; -- tension de commande (?)	
				end if;
			if (pin = 0) then
				vv := 5;
				end if;
			end if;
		end process;

end simple;
