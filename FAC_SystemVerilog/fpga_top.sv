module fpga_top (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire rx,           // Señal RX de UART
    output wire [1:0] leds   // Salida para controlar los LEDs
);
    // Señales internas para UART
    wire [1:0] uart_data_rx; // Datos recibidos por UART
    wire valid_rx;           // Señal de datos válidos

    // Registro para almacenar el estado actual de los LEDs
    reg [1:0] leds_reg;

    // Registro para detectar flanco ascendente de valid_rx
    reg valid_rx_d;

    // Señal para detectar flanco ascendente de valid_rx
    wire valid_rx_rising;

    // Instancia del receptor UART
    uart_rx uart_receiver (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(uart_data_rx),
        .valid(valid_rx)
    );

    // Detección de flanco ascendente de valid_rx sin 'if', 'case' ni '?'
    assign valid_rx_rising = valid_rx & ~valid_rx_d;

    // Lógica combinacional para calcular el siguiente estado de los LEDs
    wire [1:0] leds_next;
    assign leds_next = ( {2{valid_rx_rising}} & uart_data_rx ) |
                       ( {2{~valid_rx_rising}} & leds_reg );

    // Lógica secuencial para actualizar el registro de LEDs y valid_rx_d
    always @(posedge clk or negedge rst_n) begin
        // Actualización de valid_rx_d
        valid_rx_d <= ( (valid_rx & rst_n) | (1'b0 & ~rst_n) );
        // Actualización de leds_reg
        leds_reg <= ( (leds_next & {2{rst_n}}) | (2'b00 & {2{~rst_n}}) );
    end

    // Asignación de la salida de los LEDs
    assign leds = leds_reg;

endmodule
