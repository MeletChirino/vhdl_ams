library ieee;
use ieee.mechanical_systems.all;
use ieee.fluidic_systems.all;
use ieee.electrical_systems.all;
use ieee.std_logic_1164.all;

entity Calc_ABS is
port(
terminal veh : translational_velocity;
terminal roue : rotational_velocity;
terminal hydro : fluidic;
terminal vcmde : electrical
);
end Calc_ABS;

architecture simple of Calc_ABS is
	signal clk	: std_logic := '0';
	signal vcom     : real := 5.0;
	signal g : real;
	quantity vv across ii through vcmde;
	quantity pin across din through hydro;
	quantity vit across force through veh;
	quantity omega across tq through roue;
begin

	clk <= not clk after 1 ms;
	vv == vcom;  
	break on vcom; 
	din == 0.0;
	force == 0.0;
	tq == 0.0;

process(clk)
	--check regulation voltage is vv, if not change vv for the actual value
	variable S	: real; --coeff glisement
	begin 
		if (clk'event and clk = '1') then -- detect rising edge 
			
			if (vit > 8.3) then --if trasnlational speed under 30 adjust abs
				S := (vit - omega * 0.275) / vit; --calculs coeff glissement
				--conditions described in paper
				if(S >= 0.5) then 
					if vcom > 0.5 then 
						vcom <= vcom - 0.5;
						end if; 
				elsif (S < 0.5) then
					if vcom < 4.9 then 
						vcom <= vcom + 0.1;
						end if;
					end if; 
			elsif(vit < 8.3 and vit >  0.0) then 
				--when speed under 30 reestablish adljust voltage
				vcom <= 5.0; -- tension de commande (?)	
				end if;
			if (pin = 0.0) then
				vcom <= 5.0;
				end if;
			end if;
			g<=S;
		end process;

end simple;
