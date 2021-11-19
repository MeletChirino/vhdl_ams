library ieee;
use ieee.fluidic_systems.all;

entity maitre_cylindre is
  generic(S : real; coef_assistance : real);
  port(terminal hyd : fluidic; quantity force : in real);
end maitre_cylindre;

architecture one of maitre_cylindre is

  quantity press across debit through hyd;
  
begin
  press==force*coef_assistance/S;
end one;
