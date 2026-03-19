library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EJERCICIO_3_FINAL is
    Port ( CLOCK_50  : in  STD_LOGIC; -- Entrada del reloj principal de 50 MHz de la fpga
           BUTTON_IN : in  STD_LOGIC; -- Entrada del botón único
           HEX0      : out STD_LOGIC_VECTOR(6 downto 0); -- Salida al display HEX0, donde se muestran las unidades de segundo
           HEX1      : out STD_LOGIC_VECTOR(6 downto 0); -- Salida al display HEX1, donde se muestran las decenas de segundo
           HEX2      : out STD_LOGIC_VECTOR(6 downto 0)); -- Salida al display HEX2, donde se muestran las unidades de minuto
end EJERCICIO_3_FINAL;

architecture Estructural of EJERCICIO_3_FINAL is

		signal sig_1hz : std_logic; -- Señal que transporta el pulso de 1 Hz generado por el divisor de reloj
		signal v_us, v_ds, v_um : integer; -- Señales para unidades de segundo, decenas de segundo y unidades de minuto

	
    component divisor_reloj --toma el reloj de 50 MHz y genera una señal de 1 Hz
        Port ( clk_50mhz : in  STD_LOGIC;-- Entrada del reloj de la fpga
               clk_1hz   : out STD_LOGIC); -- Salida del pulso de 1 seg
    end component;

    -- Contiene la lógica del cronómetro con un solo botón
    -- El botón tiene varias funciones según cuánto tiempo se presione
    component contador_control_unico
        Port ( clk       : in  STD_LOGIC; -- Reloj principal de 50 MHz
               tick_1s   : in  STD_LOGIC; -- Pulso de 1 segundo
               boton     : in  STD_LOGIC; -- Entrada del botón único
               u_seg     : out integer range 0 to 9; -- Salida de unidades de segundo
               d_seg     : out integer range 0 to 5; -- Salida de decenas de segundo
               u_min     : out integer range 0 to 9); -- Salida de unidades de minuto
    end component;

    -- Convierte un número decimal en el patrón de segmentos para el display
    component decodificador_7seg
        Port ( num : in  integer range 0 to 9;-- Digito decimal de entrada
               hex : out STD_LOGIC_VECTOR(6 downto 0)); -- Salida codificada para el display de 7 segmentos
    end component;

begin --inicio de la parte estructural donde se conectan todos los componentes

    -- Unidad1 Divisor de reloj
	 -- Genera la base de tiempo de 1 segundo a partir del reloj de 50 MHz
    U1: divisor_reloj
        port map(
            clk_50mhz => CLOCK_50,-- Se conecta el reloj principal de la  fpga a la entrada del divisor
            clk_1hz   => sig_1hz   -- La salida de 1 Hz del divisor se guarda en la señal interna sig_1hz
        );

    -- Unidad2 Controlador del cronometro con un solo boton
	  -- Este bloque usa:
    -- el reloj principal para medir cuánto dura la pulsación del botón
    -- el pulso de 1 Hz para avanzar el cronómetro segundo a segundo
    U2: contador_control_unico
        port map(
            clk     => CLOCK_50,-- Se conecta el reloj principal de 50 MHz
            tick_1s => sig_1hz,  -- Se conecta la señal de 1 Hz generada por el divisor
            boton   => BUTTON_IN, -- Se conecta el botón único
            u_seg   => v_us, -- Salida de unidades de segundo hacia la señal interna v_us
            d_seg   => v_ds, -- Salida de decenas de segundo hacia la señal interna v_ds
            u_min   => v_um  -- Salida de unidades de minuto hacia la señal interna v_um
        );

    -- Unidad3 Displays de 7 segmentos
	 --Cada display necesita un decodificador independiente para convertir el número correctamente
    D0: decodificador_7seg
        port map(
				num => v_us, -- Se conecta el valor de unidades de segundo
            hex => HEX0  -- Se envía la salida al display HEX0
        );
		  
    D1: decodificador_7seg
        port map(
				num => v_ds, -- Se conecta el valor de decenas de segundo
            hex => HEX1  -- Se envía la salida al display HEX1
        );

    D2: decodificador_7seg
        port map(
            num => v_um, -- Se conecta el valor de unidades de minuto
            hex => HEX2  -- Se envía la salida codificada al display HEX2
        );

end Estructural;