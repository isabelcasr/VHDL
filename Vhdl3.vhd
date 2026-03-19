--CONTROLADOR DE BOTÓN ÚNICO
--Mide cuánto tiempo se mantiene presionado el botón usando un reloj de 1 Hz
--Si la pulsación es corta, alterna entre start o stop
--Si la pulsación dura al menos 1 segundo activa el reset y detiene el sistema

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

entity controlador_multifuncion is
    port (
        clk_1hz : in  std_logic; -- Reloj de 1 Hz
        boton   : in  std_logic; -- Entrada del botón único
        run     : out std_logic; -- Salida que indica si el sistema está corriendo o detenido
        reset   : out std_logic -- Salida que activa el reset del sistema
    );
end entity;

architecture behavioral of controlador_multifuncion is

    signal cuenta_pulsacion : integer range 0 to 5 := 0; -- Contador que mide cuantos segundos se mantiene presionado el botón
    signal estado_running   : std_logic := '0'; -- 0 detenido, 1 corriendo

begin
    process(clk_1hz) begin -- Proceso sincronizado con el reloj de 1 Hz
        if rising_edge(clk_1hz) then -- Se ejecuta en cada flanco de subida

            if boton = '1' then  -- Si el botón está presionado

                if cuenta_pulsacion < 3 then -- Evita que el contador crezca hasta más de 3
                    cuenta_pulsacion <= cuenta_pulsacion + 1; -- Incrementa la duración de la pulsación en 1 segundos
                end if;

                if cuenta_pulsacion >= 1 then -- Si el botón ha estado presionado al menos 1 segundo
                    reset <= '1'; -- Activa la señal de reset
                    estado_running <= '0'; -- Detiene el sistema
                else
                    reset <= '0'; -- Mantiene el reset desactivado si aún no se cumple la condición
                end if;

            else -- Si el botón no está presionado

                -- Detecta una pulsación menor a 1 segundo
                if cuenta_pulsacion > 0 and cuenta_pulsacion < 2 then 
                    estado_running <= not estado_running; -- Alterna entre correr y detener
                end if;

                cuenta_pulsacion <= 0; -- Reinicia el contador al soltar el botón
                reset <= '0'; -- Asegura que el reset esté desactivado

            end if;
        end if;
    end process;

    run <= estado_running; -- Asigna el estado interno a la salida run

end architecture;