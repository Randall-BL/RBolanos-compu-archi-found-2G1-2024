`timescale 1ns / 1ps
module tb_fpga_top;
    reg clk;             // Señal de reloj
    reg rst_n;           // Señal de reset (activo en bajo)
    reg rx;              // Entrada RX desde el Arduino (simulada)
    wire tx;             // Salida TX hacia el Arduino (simulada)
    wire [3:0] leds;     // LEDs de salida

    // Instancia del módulo FPGA completo
    fpga_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .tx(tx),
        .leds(leds)
    );

    // Generador de reloj (50 MHz)
    always #10 clk = ~clk;  // Período de 20 ns (50 MHz)

    // Proceso de simulación
    initial begin
        // Inicialización
        clk = 0;
        rst_n = 0;
        rx = 1; // Inactivo (UART high level cuando no se está transmitiendo)
        
        // Reset del sistema
        #100;
        rst_n = 1;

        // Simular la recepción de datos UART (ejemplo: 8 bits "11001100")
        #100;
        $display("Simulación de la recepción de '11001100'");
        uart_receive(8'b11001100);  // Simular recepción de "11001100"

        // Esperar a que se procese y envíe de vuelta el dato
        #1041670;  // Tiempo necesario para enviar/recibir un byte completo a 9600 baudios

        // Dar más tiempo para la actualización de los LEDs y procesamiento
        #2000000;

        // Simular la recepción de datos UART (ejemplo: 8 bits "10101010")
        #100000;
        $display("Simulación de la recepción de '10101010'");
        uart_receive(8'b10101010);  // Simular recepción de "10101010"

        // Esperar a que se procese y envíe de vuelta el dato
        #1041670;

        // Dar más tiempo para la actualización de los LEDs y procesamiento
        #2000000;

        // Finalizar la simulación
        #100000;
        $finish;
    end

    // Tarea para simular la recepción UART (9600 baudios, 8 bits de datos, sin paridad, 1 bit de parada)
    task uart_receive(input [7:0] data);
        integer i;
        begin
            // Simular el bit de inicio (start bit)
            rx = 0;
            #(104167);  // Tiempo de 1 bit a 9600 baudios (104.167 µs)

            // Enviar los 8 bits de datos (LSB primero)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(104167);  // Tiempo de 1 bit a 9600 baudios
            end

            // Simular el bit de parada (stop bit)
            rx = 1;
            #(104167);  // Tiempo de 1 bit a 9600 baudios
        end
    endtask

    // Monitor para observar los LEDs y la señal TX
    initial begin
        $monitor("Tiempo %t: LEDs = %b, TX = %b", $time, leds, tx);
    end

    // Tarea para capturar y mostrar los datos transmitidos por TX
    task capture_tx;
        reg [7:0] captured_data;
        integer i;
        begin
            @(negedge tx);  // Esperar al bit de inicio
            #(104167/2);  // Mover al centro del bit de inicio

            for (i = 0; i < 8; i = i + 1) begin
                #104167;
                captured_data[i] = tx;
            end

            #104167;  // Esperar el bit de parada
            $display("Tiempo %t: Dato capturado en TX = %b", $time, captured_data);
        end
    endtask

    // Proceso para capturar datos de TX
    initial begin
        forever begin
            capture_tx;
        end
    end

endmodule