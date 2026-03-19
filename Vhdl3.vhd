library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_ocupacion is
    Port ( clk          : in  STD_LOGIC;-- Reloj principal
           tick_1s      : in  STD_LOGIC; --Pulso de un segundo
           sensor_input : in  STD_LOGIC; -- 0 persona dentro, 1 afuera
           led_alarma   : out STD_LOGIC; -- Led por exceder los 35 seg
           u_seg        : out integer range 0 to 9; -- Unidades de segundo para display
           d_seg        : out integer range 0 to 5; -- Decenas de segundo para display
           u_min        : out integer range 0 to 9); -- Unidades de minuto para display
end control_ocupacion;

architecture Behavioral of control_ocupacion is

 -- Señales para manejar el tiempo en formato de display
    signal seg_unidades : integer range 0 to 9 := 0; -- Unidades de segund
    signal seg_decenas  : integer range 0 to 5 := 0; -- Decenas de segundo (0–5)
    signal min_unidades : integer range 0 to 9 := 0; -- Unidades de minuto

    signal tiempo_total : integer := 0; -- Contador total de los segundos transcurridos
begin
    process(clk) -- Proceso sincronizado con el reloj principal
    begin
        if rising_edge(clk) then -- Se ejecuta en flanco de subida del reloj
            -- Si el sensor detecta que el espacio está libre o sea switch en 1
            if sensor_input = '1' then --Reinicia el sistema
                seg_unidades <= 0; -- o sea unidaes y decenas de segundos a 0
                seg_decenas  <= 0;
                min_unidades <= 0; -- Minutos a cero
                tiempo_total <= 0; --Y reinicia el contador total
                led_alarma   <= '0'; --También apaga el led de alarma
            
            -- Pero si el espacio está ocupado, switch en 0
            elsif tick_1s = '1' then -- actualiza cada segundo
                tiempo_total <= tiempo_total + 1; -- Incrementa el tiempo total en segundos
                
                -- Activar alarma si pasa los 35 segundos
                if tiempo_total >= 35 then
                    led_alarma <= '1'; --Enciende la alarma
                else
                    led_alarma <= '0'; --Si aún no llega a los 35 la mantiene apagada
                end if;

                -- Lógica de incremento de tiempo para el display
                if seg_unidades = 9 then -- Si unidades de segundo llegó a 9
                    seg_unidades <= 0; --reinicia a 0
                    if seg_decenas = 5 then-- Si decenas de segundo llegó a 5
                        seg_decenas <= 0;--Reinicia a 0
                        if min_unidades = 9 then -- Si minutos llegó a 9
                            min_unidades <= 0; --Reinicia a 0
                        else 
                            min_unidades <= min_unidades + 1; -- Incrementa minutos
                        end if;
                    else
                        seg_decenas <= seg_decenas + 1; -- Incrementa decenas de segundo
                    end if;
                else
                    seg_unidades <= seg_unidades + 1; -- Incrementa unidades de segundo
                end if;
            end if;
        end if;
    end process;
	 
  u_seg <= seg_unidades; -- Salida de unidades de segundo
    d_seg <= seg_decenas;  -- Salida de decenas de segundo
    u_min <= min_unidades; -- Salida de minutos
end Behavioral;
