--Utiliza el reloj de la fpga para saber si han pasado más de 2 segundos con el botón presionado

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_control_unico is
    Port ( clk       : in  STD_LOGIC;  -- Reloj principal de 50 MHz
           tick_1s   : in  STD_LOGIC;  -- Pulso de 1 Hz
           boton     : in  STD_LOGIC;  -- Entrada del único botón
           u_seg     : out integer range 0 to 9; -- Salida de unidades de segundo
           d_seg     : out integer range 0 to 5; -- Salida de decenas de segundo
           u_min     : out integer range 0 to 9); -- Salida de unidades de minuto
end contador_control_unico;

architecture Behavioral of contador_control_unico is
    signal corriendo : std_logic := '0'; -- Indica si el cronómetro está corriendo 1 o detenido 0
    signal s1, m1    : integer range 0 to 9 := 0; -- s1 = unidades de segundo, m1 = unidades de minuto
    signal s2        : integer range 0 to 5 := 0; -- s2 = decenas de segundo
    
    -- Señales para detectar el tiempo presionado
    signal cuenta_pulso : integer := 0; -- Cuenta cuántos ciclos del reloj de 50 MHz dura la pulsación
    signal boton_antes  : std_logic := '1'; -- Para detectar flancos
begin
    process(clk)
    begin
        if rising_edge(clk) then
		  
            if boton = '0' then -- Boton presionado
                if cuenta_pulso < 100000000 then -- Mientras no llegue a 2 segundos
                    cuenta_pulso <= cuenta_pulso + 1; -- Incrementa la cuenta de ciclos
                end if;
                
                -- Si llega a 2 segundos (100 millones de ciclos a 50MHz)
                if cuenta_pulso = 100000000 then
                    s1 <= 0; s2 <= 0; m1 <= 0;-- Reinicia el tiempo mostrado a 0:00
                    corriendo <= '0'; -- Detiene el cronómetro
                end if;
            else
				
                -- Si se suelta ANTES de los 2 segundos, es un start o stop
                if boton_antes = '0' and cuenta_pulso < 100000000 then
                    corriendo <= not corriendo; -- Alterna entre Start y Stop
                end if;
                cuenta_pulso <= 0; -- Reiniciar contador de pulso al soltar
            end if;
            
            boton_antes <= boton; -- Guardar estado para el siguiente ciclo

            if tick_1s = '1' and corriendo = '1' then
                if s1 = 9 then -- Si unidades de segundo llegó a 9
                    s1 <= 0; -- Reinicia unidades de segundo
                    if s2 = 5 then -- Si decenas de segundo llegó a 5
                        s2 <= 0; -- Reinicia decenas de segundo
                        if m1 = 9 then 
                            m1 <= 0; -- Si minutos llegó a 9, vuelve a 0
                        else 
                            m1 <= m1 + 1; -- Si no, incrementa minutos
                        end if;
                    else 
                        s2 <= s2 + 1; -- Incrementa decenas de segundo
                    end if;
                else 
                    s1 <= s1 + 1; -- Incrementa unidades de segundo
                end if;
            end if;
        end if;
    end process;
	 
	u_seg <= s1; -- Unidades de segundo
    d_seg <= s2; -- Decenas de segundo
    u_min <= m1; -- Unidades de minuto
end Behavioral;
