--COMPONENTE: DIVISOR DE RELOJ
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

entity divisor_reloj is
    Port ( clk_50mhz : in  STD_LOGIC;  -- reloj principal de 50 MHz de la fpga
           clk_1hz   : out STD_LOGIC); -- pulso de 1 Hz 
end divisor_reloj;

architecture behavioral of divisor_reloj is 
    signal contador : integer := 0; -- Contador interno que cuenta ciclos del reloj de 50 MHz
begin
    process(clk_50mhz) 
    begin
        if rising_edge(clk_50mhz) then -- Se ejecuta en cada flanco de subida del reloj

            -- Si el contador llega a 49,999,999, eso equivale a haber contado 50,000,000 ciclos lo que corresponde a 1 segundo
            if contador = 49999999 then 
                contador <= 0;      -- Reinicia el contador para comenzar un nuevo ciclo de 1 segundo
                clk_1hz <= '1';     -- Genera un pulso alto indicando que pasó 1 segundo
            else
                contador <= contador + 1; -- Incrementa el contador en cada ciclo del reloj
                clk_1hz <= '0';     -- Mantiene la salida en bajo mientras no se cumple el segundo
            end if;
        end if;
    end process;
end behavioral; 