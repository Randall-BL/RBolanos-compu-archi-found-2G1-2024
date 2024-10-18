`timescale 1ns / 1ps

module tb_fpga_top;

    // Parámetros para la simulación
    parameter CLK_FREQ = 50000000;  // Frecuencia de reloj (50 MHz)
    parameter BAUD_RATE = 9600;     // Velocidad de UART
    localparam CLK_PERIOD = 1000000000 / CLK_FREQ;  // Periodo de reloj en nanosegundos
    localparam BAUD_PERIOD = 1000000000 / BAUD_RATE; // Periodo de baudios en nanosegundos

    // Señales
    reg clk;
    reg rst_n;
    reg rx;
    wire [1:0] leds;  // Señal para los LEDs

    // Instancia del módulo fpga_top
    fpga_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .leds(leds)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;  // Genera un reloj de 50 MHz
    end

    // Inicialización de señales
    initial begin
        rst_n = 1;    // Comienza en 1 (reset inactivo)
        #50;
        rst_n = 0;    // Activa el reset
        #200;         // Mantiene el reset activo por 200 ns
        rst_n = 1;    // Desactiva el reset
        rx = 1;       // Línea RX en reposo (nivel alto)
    end

    // Tarea para enviar un dato por UART
    task send_uart_data;
        input [1:0] data_in;
        integer i;
        begin
            // Enviar bit de inicio (start bit)
            rx = 0;
            #(BAUD_PERIOD);

            // Enviar bits de datos (LSB primero)
            for (i = 0; i < 2; i = i + 1) begin
                rx = data_in[i];
                #(BAUD_PERIOD);
            end

            // Enviar bit de parada (stop bit)
            rx = 1;
            #(BAUD_PERIOD);

            // Esperar un tiempo antes de enviar el siguiente dato
            #(BAUD_PERIOD * 2);

            // Agregar un mensaje entre las recepciones de datos
            $display("Tiempo %t ns: Estado de LEDs entre datos: LEDs=%b", $time, leds);
        end
    endtask

    // Proceso de simulación
    initial begin
        // Esperar un tiempo antes de comenzar la transmisión
        #1000;

        // Enviar datos de prueba
        $display("Tiempo %t ns: Iniciando transmisión de datos", $time);
        send_uart_data(2'b11);  // Enviar '11' (ambos LEDs encendidos)
        send_uart_data(2'b01);  // Enviar '01' (LED0 apagado, LED1 encendido)
        send_uart_data(2'b10);  // Enviar '10' (LED0 encendido, LED1 apagado)
        send_uart_data(2'b00);  // Enviar '00' (ambos LEDs apagados)

        // Finalizar la simulación después de un tiempo
        #(BAUD_PERIOD * 20);
        $stop;
    end

    // Monitoreo de señales en momentos clave
    always @(posedge clk) begin
        // Detectar cuando 'valid' se activa
        if (uut.uart_receiver.valid) begin
            $display("Tiempo %t ns: Datos recibidos: Data=%b, Valid=%b, LEDs=%b", $time, uut.uart_receiver.data, uut.uart_receiver.valid, leds);
        end
    end

    // Monitoreo de eventos de recepción
    always @(negedge rx) begin
        $display("Tiempo %t ns: Inicio de recepción (Start bit detectado)", $time);
    end

    always @(posedge rx) begin
        if (rx === 1'b1) begin
            $display("Tiempo %t ns: Fin de recepción (Stop bit detectado)", $time);
        end
    end

    // Monitoreo periódico del estado de los LEDs
    initial begin
        forever begin
            #(BAUD_PERIOD * 5);
            $display("Tiempo %t ns: Estado actual de LEDs: LEDs=%b", $time, leds);
        end
    end

endmodule
