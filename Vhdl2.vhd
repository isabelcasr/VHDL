library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisor_reloj is
    Port ( clk_50mhz : in  STD_LOGIC; -- Entrada del reloj principal de 50 MHz
           clk_1hz   : out STD_LOGIC); -- Salida a 1 Hz
end divisor_reloj;

architecture behavioral of divisor_reloj is
    signal contador : integer := 0; -- Señal interna contador inicializada en 0
begin
    process(clk_50mhz) 
    begin
        if rising_edge(clk_50mhz) then -- Se ejecuta en cada flanco ascendente del reloj
            if contador = 49999999 then -- Si el contador llegó a 49,999,999 se ha cumplido 1 segundo
                contador <= 0; -- Reinicia el contador a 0
                clk_1hz <= '1'; -- Genera un pulso alto de 1 ciclo para indicar 1 segundo
            else
                contador <= contador + 1; -- Incrementa el contador
                clk_1hz <= '0'; -- Mantiene la salida en 0 mientras no llegue al segundo
            end if;
        end if;
    end process;
end behavioral;