module fpga_top (
    input wire clk,            // Reloj del sistema
    input wire rst_n,          // Reset activo en bajo
    input wire rx,             // Señal de entrada RX (UART)
    input wire [7:0] data_in,  // Dato de 8 bits a enviar por TX
    input wire send,           // Señal para iniciar la transmisión en TX
    output wire tx,            // Señal de salida TX (UART)
    output wire [1:0] data_out,// Datos decodificados (2 bits) desde RX
    output wire valid,         // Señal de datos válidos desde RX
    output wire busy           // Señal que indica si TX está transmitiendo
);
    // Señales internas para UART RX
    wire [7:0] rx_data;
    wire rx_valid;

    // Instancia del módulo UART RX
    uart_rx uart_rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(rx_data),
        .valid(rx_valid)
    );

    // Lógica de decodificación
    reg [1:0] decoded_data;
    always @(*) begin
        case(rx_data[3:0])
            4'b0001, 4'b0010, 4'b0011, 4'b0100: decoded_data = 2'b00;
            4'b0101, 4'b0110, 4'b0111, 4'b1000: decoded_data = 2'b01;
            4'b1001, 4'b1010, 4'b1011, 4'b1100: decoded_data = 2'b10;
            4'b1101, 4'b1110, 4'b1111, 4'b0000: decoded_data = 2'b11;
            default: decoded_data = 2'b00; // Por seguridad
        endcase
    end

    // Instancia del módulo UART TX
    uart_tx uart_tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .send(send),
        .tx(tx),
        .busy(busy)
    );

    // Asignación de salidas
    assign data_out = decoded_data;  // Salida de datos decodificados
    assign valid = rx_valid;         // Salida de validación de datos desde RX

endmodule