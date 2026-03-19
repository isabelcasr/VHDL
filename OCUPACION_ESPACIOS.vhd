--ENTIDAD PRINCIPAL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OCUPACION_ESPACIOS is
    Port ( CLOCK_50  : in  STD_LOGIC; -- Señal de reloj de 50 MHz de la FPGA
           SW        : in  STD_LOGIC_VECTOR(0 downto 0);  -- Switch físico 0=ocupado, 1=libre
           LEDG      : out STD_LOGIC_VECTOR(0 downto 0); -- Felicitaciones en led verde por haber salido a tiempo
           LEDR      : out STD_LOGIC_VECTOR(0 downto 0); -- Señal de alarma por exceder los 35 seg
           HEX0      : out STD_LOGIC_VECTOR(6 downto 0); -- Las unidades de los segundos en el display
           HEX1      : out STD_LOGIC_VECTOR(6 downto 0); -- las decenas de los segundos en el display
           HEX2      : out STD_LOGIC_VECTOR(6 downto 0) -- unidades del minuto
    );
end OCUPACION_ESPACIOS;

--Arquitectura estructural, o sea que solo conecta otros componentes
architecture Estructural of OCUPACION_ESPACIOS is

    signal sig_1hz   : std_logic; --señal de 1hz genereada por el divisor de reloj
    signal sig_total : integer; --tiempo total que viene del componente de facturacion
    signal v_us, v_ds, v_um : integer; --unidades de seg, decenas de seg y unidades de min para los displays

    component divisor_reloj --convierte el reloj de 50MHz a pulso de 1Hz 
        Port ( clk_50mhz : in  STD_LOGIC; -- Entrada del reloj principal de 50 MHz
               clk_1hz   : out STD_LOGIC); -- Salida a 1 Hz
    end component;

    --Controla el tiempo de ocupación, la alarma y felicitación
    component facturacion
        Port ( clk          : in  STD_LOGIC; -- Entrada de reloj principal
					tick_1s      : in  STD_LOGIC; -- Entrada del pulso de 1 segundo
					sensor       : in  STD_LOGIC; -- 0 ocupado, 1 libre
					alarma       : out STD_LOGIC; -- Led de alarma
					felicidades  : out STD_LOGIC; -- Led de felicitación
					seg_totales  : out integer); --Salida con el tiempo total para mostrar
    end component;

    component logica_salida --convierte el tiempo total en seg a display 7 seg
        Port ( total_seg : in  integer; -- Entrada con el total de segundos a convertir
					u_seg     : out integer range 0 to 9; -- Salida de unidades de segundo
					d_seg     : out integer range 0 to 5; -- Salida de decenas de segundo
					u_min     : out integer range 0 to 9); -- Salida de unidades de minuto
    end component;

    component decodificador_7seg --Pasa los numeros decimales, de 0 a 9, al formato del 7 segmentos
        Port ( num : in  integer range 0 to 9;
               hex : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin
	--Viene del divisor de reloj y convierte 50MHz en 1HZ, base de tiempo para contar segundos
    U_RELOJ: divisor_reloj
        port map(
            clk_50mhz => CLOCK_50, --entrada de reloj de la fpga
            clk_1hz   => sig_1hz --salida de 1 segundo 
        );

	
    -- Del componente de facturación, gestiona el temporizador, da la alarma y felicitaciones
    -- Recibe reloj principal, pulso 1s, estado del sensor
    -- Entrega la señal de alarma, señal de felicitaciones, tiempo total
    U_FACT: facturacion
        port map(
            clk         => CLOCK_50, -- Reloj principal
            tick_1s     => sig_1hz,  -- Pulso de 1 segundo
            sensor      => SW(0), -- switch
            alarma      => LEDR(0), --salida hacia el led de alarma
            felicidades => LEDG(0), --salida hacia el led de felicitaciones
            seg_totales => sig_total --tiempo total en seg
        );
			  
	--Sale del componente de logica de salida, convierte segundos totales a dígitos individuales
    U_SALIDA: logica_salida
        port map(
            total_seg => sig_total, --tiempo total en segundos
            u_seg     => v_us, --unidades de segundo
            d_seg     => v_ds, --decenas de segundo
            u_min     => v_um --unidades de minuto
        ); -- convierte el tiempo total 

	-- Tres instancias del decodificador BCD a 7 segmentos, una por cada display
    D0: decodificador_7seg
        port map(
            num => v_us,
            hex => HEX0
        ); --Unidades de segundo son HEX0

		  --dispplay de decenas de segundo
    D1: decodificador_7seg
        port map(
            num => v_ds,
            hex => HEX1
        ); --Decenas de segundo son HEX1

		  --Display de unidades de minuto
    D2: decodificador_7seg
        port map(
            num => v_um,
            hex => HEX2
        ); --Unidades de minuto son HEX2

end Estructural;