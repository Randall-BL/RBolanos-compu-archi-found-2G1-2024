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
        .data_in(data_to_send),    // Dato que la FPGA enviará
        .send(send),               // Señal de transmisión
        .tx(tx),                   // Señal TX
        .busy()                    // Señal que indica si está ocupado
    );

    // Procesamiento de datos y control de LEDs
    assign uart_data_rx = uart_data_full_rx[3:0];  // Solo los 4 bits menos significativos

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            leds <= 4'b0000;            // Inicializar LEDs apagados
            data_to_send <= 8'b0;       // Inicializar dato a enviar
            send <= 0;                  // Inicializar señal de transmisión en 0
            valid_rx_d <= 0;            // Inicializar registro de valid
        end else begin
            valid_rx_d <= valid_rx;     // Almacenar la señal valid anterior
            
            // Si se detecta un flanco ascendente en valid_rx (nuevo dato recibido)
            if (valid_rx && !valid_rx_d) begin
                leds <= uart_data_rx;  // Actualizar LEDs con los datos recibidos
                
                // Posponer el print para asegurar que los LEDs hayan sido actualizados
                #1 $display("Datos recibidos: %b, LEDs actualizados a: %b", uart_data_full_rx, leds);
                
                // Preparar los datos a enviar al Arduino
                data_to_send <= uart_data_full_rx + 8'b1;  // Enviar un dato modificado
                send <= 1;  // Activar señal de transmisión
            end else begin
                send <= 0;  // Desactivar transmisión después de enviar el dato
            end
        end
    end

endmodule
