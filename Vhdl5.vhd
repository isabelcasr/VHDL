--DECODIFICADOR 7 SEGMENTOS
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador_7seg is
    Port ( num : in  integer range 0 to 9; -- Cambiado de bcd a num
           hex : out STD_LOGIC_VECTOR(6 downto 0));
end decodificador_7seg;

architecture flujo_de_datos of decodificador_7seg is
begin
    process(num)
    begin
         case num is --Estructura case para seleccionar el patrón del display según el numero 
            when 0 => hex <= "1000000"; when 1 => hex <= "1111001"; -- Si num=0 muestra 0, si num=1 muestra 1
            when 2 => hex <= "0100100"; when 3 => hex <= "0110000"; -- Si num=2 muestra 2, si num=3 muestra 3
            when 4 => hex <= "0011001"; when 5 => hex <= "0010010"; -- Si num=4 muestra 4, si num=5 muestra 5
            when 6 => hex <= "0000010"; when 7 => hex <= "1111000"; -- Si num=6 muestra 6, si num=7 muestra 7
            when 8 => hex <= "0000000"; when 9 => hex <= "0011000";  -- Si num=8 muestra 8, si num=9 muestra 9
            when others => hex <= "1111111"; -- En cualquier otro caso apaga todos los segmentos
        end case;
    end process;
end flujo_de_datos;