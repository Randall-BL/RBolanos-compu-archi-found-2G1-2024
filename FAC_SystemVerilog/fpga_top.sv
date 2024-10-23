`timescale 1ns / 1ps
module fpga_top (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire rx,           // Señal RX de UART (desde Arduino)
    output reg [3:0] leds,   // LEDs de la FPGA
    output wire tx           // Señal TX de UART (hacia Arduino)
);
    wire [7:0] uart_data_full_rx;  // Datos recibidos por UART (desde Arduino)
    wire [3:0] uart_data_rx;       // Solo los 4 bits menos significativos de los datos recibidos
    wire valid_rx;                 // Señal que indica que los datos recibidos son válidos
    reg [7:0] data_to_send;        // Datos que la FPGA enviará a través de UART
    reg send;                      // Señal para iniciar la transmisión
    reg valid_rx_d;                // Registro para almacenar valid anterior

    // Instancia del receptor UART (RX)
    uart_rx uart_receiver (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(uart_data_full_rx),  // Dato completo de 8 bits recibido
        .valid(valid_rx)           // Señal de datos válidos
    );

    // Instancia del transmisor UART (TX)
    uart_tx uart_transmitter (
        .clk(clk),
        .rst_n(rst_n),
        .data(data_to_send),    // Dato que la FPGA enviará
        .start(send),           // Señal de transmisión
        .tx(tx),                // Señal TX
        .busy()                 // Señal que indica si está ocupado (no utilizada)
    );

    // Procesamiento de datos y control de LEDs
    assign uart_data_rx = uart_data_full_rx[3:0];  // Solo los 4 bits menos significativos

    wire valid_edge;
    assign valid_edge = valid_rx & ~valid_rx_d;

    wire [3:0] leds_next;
    assign leds_next = (uart_data_rx & {4{valid_edge}}) | (leds & {4{~valid_edge}});

    wire [7:0] data_to_send_next;
    assign data_to_send_next = (uart_data_full_rx + 8'b1) & {8{valid_edge}} | (data_to_send & {8{~valid_edge}});

    wire send_next;
    assign send_next = valid_edge;

    // Lógica secuencial
    always @(posedge clk or negedge rst_n) begin
        valid_rx_d <= (valid_rx & rst_n) | (1'b0 & ~rst_n);
        leds <= (leds_next & {4{rst_n}}) | (4'b0000 & {4{~rst_n}});
        data_to_send <= (data_to_send_next & {8{rst_n}}) | (8'b0 & {8{~rst_n}});
        send <= (send_next & rst_n) | (1'b0 & ~rst_n);

        // Posponer el print para asegurar que los LEDs hayan sido actualizados
        #1 $display("Datos recibidos: %b, LEDs actualizados a: %b", uart_data_full_rx, leds);
    end

endmodule