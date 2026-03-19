-- Conecta el generador de reloj, el contador y los displays.
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

entity TEMPORIZADOR_959_COMPLETO is 
    Port ( CLOCK_50 : in  STD_LOGIC; -- Entrada del reloj principal de 50 MHz de la FPGA
           BUTTON   : in  STD_LOGIC_VECTOR(2 downto 0); -- Vector de 3 botones start, restart y stop
           HEX0     : out STD_LOGIC_VECTOR(6 downto 0); -- Salida al display HEX0 para unidades de segundo
           HEX1     : out STD_LOGIC_VECTOR(6 downto 0); -- Salida al display HEX1 para decenas de segundo
           HEX2     : out STD_LOGIC_VECTOR(6 downto 0)); -- Salida al display HEX2 para unidades de minutos
end TEMPORIZADOR_959_COMPLETO; 

architecture estructural of TEMPORIZADOR_959_COMPLETO is 

    signal sig_1hz : std_logic; -- Señal que transporta el pulso de 1 Hz 
    signal v_us, v_ds, v_um : integer; -- Señales para unidades de segundo, decenas de segundo y unidades de minuto

    -- Convierte el reloj de 50 MHz en un pulso de 1 Hz
    component divisor_reloj
        Port ( clk_in  : in  STD_LOGIC;
               clk_1hz : out STD_LOGIC);
    end component;
	 
    -- Controla el temporizador usando los botones start, restart y stop
    component contador_control
        Port ( clk         : in  STD_LOGIC;
               tick_1s     : in  STD_LOGIC; --señal que se activa cada 1 seg
               btn_start   : in  STD_LOGIC;
               btn_restart : in  STD_LOGIC;
               btn_stop    : in  STD_LOGIC;
               u_seg       : out integer range 0 to 9;
               d_seg       : out integer range 0 to 5;
               u_min       : out integer range 0 to 9);
    end component;

    -- Convierte un número decimal a la codificación de 7 segmentos
    component decodificador
        Port ( num : in  integer range 0 to 9;
               hex : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin

    -- Convierte la señal de 50 MHz en una señal de 1 Hz, sirve como base de tiempo del temporizador
     U1: divisor_reloj
        port map(
            clk_in  => CLOCK_50, -- Entrada del reloj de la FPGA
            clk_1hz => sig_1hz   -- Salida del pulso de 1 segundo
        );

    U2: contador_control
        port map(
            clk         => CLOCK_50,  -- Reloj principal de 50 MHz
            tick_1s     => sig_1hz,   -- Pulso de 1 segundo
            btn_start   => BUTTON(0), -- Botón Start
            btn_restart => BUTTON(1), -- Botón Restart
            btn_stop    => BUTTON(2), -- Botón Stop
            u_seg       => v_us,      -- Unidades de segundo
            d_seg       => v_ds,      -- Decenas de segundo
            u_min       => v_um       -- Unidades de minuto
        );

   
    -- Cada decodificador toma un dígito decimal y lo convierte al patrón necesario para su respectivo display
    -- Display de unidades de segundo
    D0: decodificador
        port map(
            num => v_us, -- Valor de unidades de segundo
            hex => HEX0  -- Señal al display HEX0
        );

    -- Display de decenas de segundo
    D1: decodificador
        port map(
            num => v_ds, -- Valor de decenas de segundo
            hex => HEX1  -- Señal al display HEX1
        );

    -- Display de unidades de minuto
    D2: decodificador
        port map(
            num => v_um, -- Valor de unidades de minuto
            hex => HEX2  -- Señal al display HEX2
        );

end estructural;