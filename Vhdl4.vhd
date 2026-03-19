library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity facturacion is
    Port ( clk          : in  STD_LOGIC; -- Entrada de reloj principal
           tick_1s      : in  STD_LOGIC; -- Entrada del pulso de 1 segundo
           sensor       : in  STD_LOGIC; -- 0 ocupado, 1 libre
           alarma       : out STD_LOGIC; -- Led de alarma
           felicidades  : out STD_LOGIC; -- Led de felicitación
           seg_totales  : out integer); --Salida con el tiempo total para mostrar
end facturacion;

architecture Behavioral of facturacion is
    signal cuenta       : integer := 0; --Lleva la cuenta de segundos
    signal timer_verde  : integer := 0; --controla cuánto tiempo dura encendido el led de felicitación
    signal mostrar_feli : std_logic := '0'; --indica si debe mostrar la felicitación
    signal estado_extra : std_logic := '0'; -- 0 es Tiempo normal y 1 es Tiempo extra
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Caso 1: La persona sale del espacio o sea que switch en 1
            if sensor = '1' then --indica que el espacio queda libre
                if estado_extra = '0' and cuenta > 0 then
                    mostrar_feli <= '1'; -- Activa la felicitación
                    timer_verde  <= 0; --reinicia el temporizador del led de felicitación
                end if;
                cuenta <= 0; --reinicia el contador principal
                estado_extra <= '0'; -- Regresa al estado de tiempo normal
                alarma <= '0'; --y apaga la alarma
            
            -- Caso 2: La persona sigue ocupando el espacio el switch en 0
            elsif tick_1s = '1' then --si el espacio sigue ocupado y llegó un pulso de un segundo
                mostrar_feli <= '0'; -- ya apaga la felicitación mientras sigue ocupado
                
                -- Verificar en qué etapa está
                if estado_extra = '0' then -- si aun está en la etapa de tiempo normal entonces
                    -- Etapa 1 de los primeros 35 segundos
                    if cuenta >= 34 then 
                        cuenta <= 0;         --reinicia la cuenta a cero a los 35s para contar el tiempo extra
                        estado_extra <= '1'; -- Cambiamos al estado de tiempo extra
                    else -- si aún no llega a los 35s
                        cuenta <= cuenta + 1;
                    end if; 
                else
                    -- Etapa 2 del tiempo extra para facturación
                    cuenta <= cuenta + 1; -- Ahora cuenta desde cero el tiempo extra
                end if; --termina verificar la etapa
            end if;

            -- Control de la alarma, el led que se enciende solo en la etapa de tiempo extra
            alarma <= estado_extra;

            -- Temporizador de auto apagado a los 5s para el led de felicitación
            if mostrar_feli = '1' then
                if tick_1s = '1' then --cambia con cada pulso de 1 segundo
                    if timer_verde < 5 then --si aún no llega a 5 sigue aumentando
                        timer_verde <= timer_verde + 1;
                    else
                        mostrar_feli <= '0'; --apaga la felicitación
                    end if;
                end if;
            end if;
        end if;
    end process;

    felicidades <= mostrar_feli; --asigna la señal a la salida felicidades
    seg_totales <= cuenta; -- envía elvalor actual de cuenta a la salida para los displays
end Behavioral;