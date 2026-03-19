library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_control is
    Port ( clk         : in  STD_LOGIC; -- Entrada del reloj principal
           tick_1s     : in  STD_LOGIC; -- Entrada del pulso de 1 segundo
           btn_start   : in  STD_LOGIC; -- Boton para iniciar el temporizador
           btn_restart : in  STD_LOGIC; -- Boton para resetear el temporizador
           btn_stop    : in  STD_LOGIC; -- Boton para detener
           u_seg       : out integer range 0 to 9; --Salida de unidades de segundo
           d_seg       : out integer range 0 to 5; --Salida de decenas de segundo
           u_min       : out integer range 0 to 9); --salida de unidades de minuto
end contador_control;

architecture Behavioral of contador_control is
    signal corriendo : std_logic := '0'; -- Indica si el temporizador está corriendo en 1 o detenido 0
    signal s1, m1    : integer range 0 to 9 := 0;  -- s1 guarda unidades de segundo, m1 guarda unidades de minuto, ambos inicializados en 0
    signal s2        : integer range 0 to 5 := 0; -- s2 guarda decenas de segundo, inicializado en 0
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Botones en DE0 entregan 0 al ser presionados
            if btn_start = '0' then -- Si el botón de start está presionado
                corriendo <= '1'; -- Se activa el temp y se queda asi
            elsif btn_stop = '0' then --Si el botón de stop está presionado
                corriendo <= '0'; -- Se detiene el temp y se queda asi
            end if;

            if btn_restart = '0' then -- si el boton de restart estápresionado 
                s1 <= 0; s2 <= 0; m1 <= 0; --reinicia a cero todo
                corriendo <= '0'; -- y detiene el temp
            elsif tick_1s = '1' and corriendo = '1' then --si llega el puslo de 1 y el tempo está corriendo
                if s1 = 9 then --si las unidades de segundos llegaron a 9
                    s1 <= 0;-- las reinicia a 0
                    if s2 = 5 then --si las decenas de segundos llegan a 5
                        s2 <= 0; -- reinicia las decenas de seg a 0
                        if m1 = 9 then m1 <= 0; else m1 <= m1 + 1; end if; -- si los minutos llegaron a 9 vuelve a 0, sino suma 1 min
                    else s2 <= s2 + 1; end if; -- si las decenadas de seg no son 5, incrementa 1 decena
                else s1 <= s1 + 1; end if;  -- si las unidades de seg no son 9, incrementa 1
            end if;
        end if;
    end process;

    u_seg <= s1; d_seg <= s2; u_min <= m1;
end Behavioral;