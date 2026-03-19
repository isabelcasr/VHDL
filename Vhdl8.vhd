--Este componente toma la señal de alta velocidad de la fpga y genera el pulso de 1 segundo
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisor_reloj is
    Port ( clk_in  : in  STD_LOGIC;  -- Reloj 50MHz
           clk_1hz : out STD_LOGIC); -- salida de pulso 1Hz
end divisor_reloj;

architecture Behavioral of divisor_reloj is
    signal contador : integer := 0; -- Señal interna entera que lleva la cuenta de ciclos del reloj, iniciando en 0
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then -- Solo actúa en el flanco ascendente del reloj
            if contador = 49999999 then 
                contador <= 0;
                clk_1hz <= '1'; -- Genera un pulso alto de un ciclo indicando que pasó 1 segundo
            else
                contador <= contador + 1;
                clk_1hz <= '0'; -- Mantiene la salida en 0 mientras no se cumpla el segundo
            end if;
        end if;
    end process;
end Behavioral;