library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logica_salida is
    Port ( total_seg : in  integer; -- Entrada con el total de segundos a convertir
           u_seg     : out integer range 0 to 9; -- Salida de unidades de segundo
           d_seg     : out integer range 0 to 5; -- Salida de decenas de segundo
           u_min     : out integer range 0 to 9); -- Salida de unidades de minuto
end logica_salida;

architecture Dataflow of logica_salida is --Arquitectura con flujo de datos
begin
    u_seg <= (total_seg mod 60) mod 10;  -- Obtiene las unidades de segundo a partir del total de segundos
    d_seg <= (total_seg mod 60) / 10; --Lo mismo para las decenas de los segundos
    u_min <= (total_seg / 60) mod 10; --Lo mismo para las unidades de los minutos
end Dataflow;